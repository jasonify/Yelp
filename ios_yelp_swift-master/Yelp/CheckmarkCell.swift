//
//  CheckmarkCell.swift
//  Yelp
//
//  Created by jason on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol CheckmarkCellDelegate {
    @objc optional func checkmarkCell(checkmarkCell : CheckmarkCell)
}

class CheckmarkCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    weak var delegate : CheckmarkCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected){
            delegate?.checkmarkCell?(checkmarkCell: self)
        }
        
        
        // Configure the view for the selected state
    }

}
