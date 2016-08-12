//
//  CuisineCategoryCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol CuisineCategoryCellDelegate: class {
    func cuisineCategoryCellDidToggle(cuisineCategoryCell: CuisineCategoryCell, newValue: Bool)
}

class CuisineCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    weak var delegate: CuisineCategoryCellDelegate? // not !
    
    var cuisineFilters: CuisineFilters!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didToggleSwitch(sender: AnyObject) {

        print(switchControl.on)
        delegate?.cuisineCategoryCellDidToggle(self, newValue: self.switchControl.on)
    }

}
