//
//  ExpandCell.swift
//  Yelp
//
//  Created by jason on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol ExpandCellDelegate {
    @objc optional func expandCell(expandCell: ExpandCell)
}
class ExpandCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    weak var delegate: ExpandCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("set selected expanded cell!", selected)
        if(selected){
            delegate?.expandCell?(expandCell: self)    
        }
        
        // Configure the view for the selected state
    }

}
