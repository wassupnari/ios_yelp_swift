//
//  BusinessCell.swift
//  Yelp
//
//  Created by Nari Shin on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dollarSignLabel: UILabel!
    
    var business: Business! {
        didSet {
            restaurantNameLabel.text = business.name
            restaurantImageView.setImageWith(business.imageURL!)
            reviewsLabel.text = "\(business.reviewCount) Reviews"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            distanceLabel.text = business.distance
            ratingsImageView.setImageWith(business.ratingImageURL!)
            dollarSignLabel.text = "$$"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restaurantImageView.layer.cornerRadius = 3
        restaurantImageView.clipsToBounds = true
        
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
