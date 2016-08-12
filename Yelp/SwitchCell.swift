//
//  SwitchCell.swift
//  Yelp
//
//  Created by ximin_zhang on 8/9/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue: Bool) //
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var onSwitch: UISwitch! 

    weak var delegate: SwitchCellDelegate?

//    var filterRowIdentifier: FilterRowIdentifier! {
//        didSet {
//            switchLabel?.text = filterRowIdentifier?.rawValue
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), forControlEvents: UIControlEvents.ValueChanged)

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged(){
        print("(Offer a deal) switch value changed")
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }
}
