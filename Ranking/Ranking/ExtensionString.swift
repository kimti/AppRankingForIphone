//
//  ExtensionString.swift
//  AppRanking
//
//  Created by kimti on 6/14/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
extension String {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for _ in 0..<digestLen {
            hash.appendFormat("%02x", result)
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
}