//
//  SortOptionCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


class SortOptionCell: UITableViewCell {

    @IBOutlet weak var sortOptionLabel: UILabel!
    @IBOutlet weak var onSelect: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
