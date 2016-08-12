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

    @IBOutlet weak var yelpSwitchUIButton: YelpSwitchButton!

    weak var delegate: SwitchCellDelegate?

//    var yelpSwitchOn: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), forControlEvents: UIControlEvents.ValueChanged)

//        yelpSwitchUIButton.addTarget(self, action: #selector(SwitchCell.touchDownYelpSwitch), forControlEvents: UIControlEvents.ValueChanged)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged(){
        print("(Offer a deal) switch value changed")
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)

    }

    @IBAction func touchDownYelpSwitch(sender: YelpSwitchButton) {
        sender.on = !sender.on
        if(sender.on ){
            yelpSwitchUIButton.setImage(UIImage(named: "SwitchOn"), forState: .Normal)
        }else{
            yelpSwitchUIButton.setImage(UIImage(named: "SwitchOff"), forState: .Normal)
        }


        delegate?.switchCell?(self, didChangeValue: sender.on)
    }

}
