//
//  DetailViewController.swift
//  NguyenCCMovies
//
//  Created by Nguyen Chau Chieu on 6/15/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var movieImage: UIImageView!
    var movieTitle = ""
    var posterPath = ""
    var backgroundImage = UIImage()
    var movieReleaseDate = ""
    var movieOverview = ""
    var movieAverageRated = ""
    var movieVoteCount = ""
    let lowResolutionimageBaseURL = "https://image.tmdb.org/t/p/w45"
    let highResolutionimageBaseURL = "https://image.tmdb.org/t/p/original"
    @IBOutlet var movieDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        movieDetailTableView.separatorStyle = .none
        movieDetailTableView.showsVerticalScrollIndicator = false
        movieDetailTableView.showsHorizontalScrollIndicator = false
        movieDetailTableView.allowsSelection = false
        backgroundImage = preProcessImage(image: backgroundImage)
        view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preProcessImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        image.draw(in: view.bounds)
        let resultImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        header.layer.backgroundColor = UIColor.clear.cgColor
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieDetailTableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        let index = movieReleaseDate.index(movieReleaseDate.startIndex, offsetBy: 4)
        let yearRelease = movieReleaseDate.substring(to: index)
        cell.movieTitle.text = movieTitle + " (\(yearRelease))"
        cell.movieAverageRated.text = "\(movieAverageRated) / 10"
        cell.movieTitle.sizeToFit()
        cell.movieReleaseDate.text = "Released date: \(movieReleaseDate)"
        cell.movieReleaseDate.sizeToFit()
        cell.movieVoteCount.text = "Voted: \(movieVoteCount)"
        cell.movieVoteCount.sizeToFit()
        cell.movieOverview.text = "Overview: \(movieOverview)"
        cell.movieOverview.sizeToFit()
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        movieDetailTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(white: 0, alpha: 0.8)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }

}
