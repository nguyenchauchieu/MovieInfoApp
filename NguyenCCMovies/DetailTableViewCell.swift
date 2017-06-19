//
//  DetailTableViewCell.swift
//  NguyenCCMovies
//
//  Created by Nguyen Chau Chieu on 6/17/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieAverageRated: UILabel!
    @IBOutlet var movieReleaseDate: UILabel!
    @IBOutlet var movieVoteCount: UILabel!
    @IBOutlet var movieOverview: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
