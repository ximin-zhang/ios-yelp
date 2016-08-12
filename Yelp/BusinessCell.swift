//
//  BusinessCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/8/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if business.imageURL != nil{
                thumbImageView.setImageWithURL(business.imageURL!)
            }
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true // Why?

//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }


    override func layoutSubviews() {
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



}
