//
//  Model.swift
//  Ranking
//
//  Created by kimti on 5/9/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
import UIKit

class FeedType {
    var translation_key:String?
    var urlPrefix:String?
    var urlSuffix:String?
}

class Genre {
    var id:String?
    var translation_key:String?
}

class Entry {
    var id:String?
    var name:String?
    var imageLink:String?
    var summary:String?
    var price:String?
    var rights:String?
    var link:String?
    var category:String?
    var releaseDate:String?
    var image = UIImage(named: "appIcon10241")
    var isImageLoaded = false
    
    var isRatingLoaded = false
    var averageUserRating:Float = 0.0
    var userRatingCount:Int = 0
    var ratingView:UIView?
}