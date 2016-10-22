//
//  SwitchCell.swift
//  Yelp
//
//  Created by jason on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


 @objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var switchSwitch: UISwitch!

    weak var delegate: SwitchCellDelegate?
    @IBOutlet weak var labelSwitch: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func switchValueChanged(){
        print("switch value chagned")
        delegate?.switchCell?(switchCell: self, didChangeValue: switchSwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
