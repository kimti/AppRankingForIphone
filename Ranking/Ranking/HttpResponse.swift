//
//  HttpResponse.swift
//  Ranking
//
//  Created by kimti on 5/14/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
public protocol ResponseConvertible{
    static func convertFromData(data:NSData!) -> (Self?,NSError?)
}