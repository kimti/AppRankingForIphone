//
//  ImageTableViewCell.swift
//  Ranking
//
//  Created by kimti on 5/24/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellLabel.textColor = UIColor.hexStringToColor("#489dff")
        
        self.cellImageView!.layer.masksToBounds = true
        self.cellImageView!.contentMode = .ScaleAspectFit
        self.cellImageView!.autoresizingMask =  [.FlexibleHeight, .FlexibleWidth]
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
