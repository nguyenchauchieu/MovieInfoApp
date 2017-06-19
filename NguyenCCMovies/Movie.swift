//
//  MovieModel.swift
//  NguyenCCMovies
//
//  Created by Nguyen Chau Chieu on 6/19/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import Foundation

struct Movie {
    var title: String!
    var overview: String!
    var releaseDate: String!
    var ratedCount: String!
    var averageRated: String!
    var posterPath: String!
    init(movie: NSDictionary) {
        title = "\(String(describing: movie["title"]!))"
        overview = "\(String(describing: movie["overview"]!))"
        releaseDate = "\(String(describing: movie["release_date"]!))"
        ratedCount = "\(String(describing: movie["vote_count"]!))"
        averageRated = "\(String(describing: movie["vote_average"]!))"
        posterPath = "\(String(describing: movie["poster_path"]!))"
    }
}
