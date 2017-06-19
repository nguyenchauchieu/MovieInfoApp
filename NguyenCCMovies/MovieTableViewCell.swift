//
//  MovieTableViewCell.swift
//  NguyenCCMovies
//
//  Created by Nguyen Chau Chieu on 6/15/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var movieImageView: UIImageView!

    @IBOutlet var noResultMessage: UILabel!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        movieDescriptionLabel.baselineAdjustment = .alignCenters
        movieDescriptionLabel.sizeThatFits(CGSize(width: 232, height: 150))
        
        movieImageView.sizeThatFits(CGSize(width: 80, height: 100))

        // Configure the view for the selected state
    }

}
