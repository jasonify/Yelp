//
//  BusinessCellTableViewCell.swift
//  Yelp
//
//  Created by jason on 10/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var dollars: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votingImage: UIImageView!
    @IBOutlet weak var heroImage: UIImageView!
    
    
    var business : Business! {
        didSet {
            titleLabel.text = business.name
            heroImage.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            address.text = business.address
            
            reviews.text = " \(business.reviewCount!) Reviews"
            votingImage.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        heroImage.layer.cornerRadius = 3
        heroImage.clipsToBounds = true
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
