//
//  EntryTableViewCell.swift
//  Ranking
//
//  Created by kimti on 5/19/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNumberLabel: UILabel!
    @IBOutlet weak var cellCategoryLabel: UILabel!
    
    @IBOutlet weak var cellPriceLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var cellUserRatingCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
