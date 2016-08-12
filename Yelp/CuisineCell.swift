//
//  CuisineCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CuisineCellDelegate {
    optional func cuisineCell(switchCell: CuisineCell, didChangeValue: Bool) //
}


class CuisineCell: UITableViewCell {
    

    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var cuisineLabel: UILabel!
    weak var delegate: CuisineCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        onSwitch.addTarget(self, action: #selector(CuisineCell.switchValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }

    func switchValueChanged(){
        print("switch value changed")
        delegate?.cuisineCell!(self, didChangeValue: onSwitch.on)
    }

}
