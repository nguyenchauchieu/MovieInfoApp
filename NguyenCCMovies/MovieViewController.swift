//
//  MainViewController.swift
//  NguyenCCMovies
//
//  Created by Nguyen Chau Chieu on 6/14/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var noInternetConnectionLabel: UILabel!
    let refreshControl = UIRefreshControl()
    let imageBaseURL = "https://image.tmdb.org/t/p/w342"
    let lowResolutionimageBaseURL = "https://image.tmdb.org/t/p/w45"
    let highResolutionimageBaseURL = "https://image.tmdb.org/t/p/original"
    @IBOutlet var moviesTableView: UITableView!
    var searchActive = false
    
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshPage), for: UIControlEvents.valueChanged)
        
        moviesTableView.insertSubview(refreshControl, at: 0)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.rowHeight = 120
        
        searchBar.delegate = self
        
        fetchMovieData()
    }
    
    @IBAction func retryButton(_ sender: Any) {
        fetchMovieData()
    }
    
    
    
    func fetchMovieData() -> Void {
        if Reachability.isConnectedToNetwork() {
            moviesTableView.isHidden = false
            noInternetConnectionLabel.isHidden = true
            retryButton.isHidden = true
            
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
            let request = URLRequest(
                url: url!,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 20)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main
            )
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let task: URLSessionDataTask =
                session.dataTask(with: request,
                                 completionHandler: { (dataOrNil, response, error) in
                                    if let data = dataOrNil {
                                        if let responseDictionary = try! JSONSerialization.jsonObject(
                                            with: data, options:[]) as? NSDictionary {
                                            self.movies = responseDictionary["results"] as! [NSDictionary]
                                            self.moviesTableView.reloadData()
                                            self.refreshControl.endRefreshing()
                                        }
                                    }
                                    
                                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            task.resume()
        } else {
            moviesTableView.isHidden = true
            noInternetConnectionLabel.isHidden = false
            retryButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! DetailViewController
        
        let indexPath = moviesTableView.indexPathForSelectedRow
        moviesTableView.deselectRow(at: indexPath!, animated: true)
        let currentCell = moviesTableView.cellForRow(at: indexPath!) as! MovieTableViewCell
        
        let image = currentCell.movieImageView.image
        let movieTitle = getValue(for: "title", in: movies, at: indexPath!)
        let releaseDate = getValue(for: "release_date", in: movies, at: indexPath!)
        let overview = getValue(for: "overview", in: movies, at: indexPath!)
        let rated = getValue(for: "vote_average", in: movies, at: indexPath!)
        let numberOfVote = getValue(for: "vote_count", in: movies, at: indexPath!)
        nextViewController.backgroundImage = image!
        nextViewController.movieTitle = movieTitle
        nextViewController.movieReleaseDate = releaseDate
        nextViewController.movieOverview = overview
        nextViewController.movieAverageRated = rated
        nextViewController.movieVoteCount = numberOfVote
    }
    
    func refreshPage() -> Void {
        fetchMovieData()
    }
    
    func getValue(for key: String, in movies: [NSDictionary], at indexPath: IndexPath) -> String {
        return "\(String(describing: movies[(indexPath.row)].value(forKey: key)!))"
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            if filteredMovies.count == 0 {
                return 0
            } else {
                return filteredMovies.count
            }
            
        } else {
            return movies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        if searchActive == true {
            loadMovieToCell(movies: filteredMovies, indexPath: indexPath, cell: cell)
        } else {
            loadMovieToCell(movies: movies, indexPath: indexPath, cell: cell)
        }
        return cell
    }
    
    func loadMovieToCell(movies: [NSDictionary], indexPath: IndexPath, cell: MovieTableViewCell) -> Void {
        let imagePath = imageBaseURL + "\(movies[indexPath.row]["poster_path"]!)"
        let posterRequest = URLRequest(url: URL(string: imagePath)!)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.brown
        cell.selectedBackgroundView = backgroundView
        cell.movieTitleLabel.text = "\(movies[indexPath.row]["title"]!)"
        cell.movieDescriptionLabel.text = "\(movies[indexPath.row]["overview"]!)"
        cell.movieImageView.setImageWith(
            posterRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    cell.movieImageView.alpha = 0.0
                    cell.movieImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.movieImageView.alpha = 1.0
                    })
                } else {
                    cell.movieImageView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
    }
}

extension MovieViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchActive = false
        moviesTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredMovies = movies.filter({ (movie) -> Bool in
                let title = movie.value(forKey: "title") as! String
                let range = title.lowercased().contains(searchText.lowercased())
                return range
            })
        } else {
            filteredMovies = movies
        }
        searchActive = true;
        moviesTableView.reloadData()
    }
}
