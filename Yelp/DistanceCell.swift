//
//  DistanceCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol DistanceCellDelegate {
    func distanceCell(distanceCell: DistanceCell, didChangeValue: Bool)
}

class DistanceCell: UITableViewCell {


    @IBOutlet weak var onSelect: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!

    var isCellSelected: Bool!

    var delegate: DistanceCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

}
