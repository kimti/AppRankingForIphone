//
//  FileCache.swift
//  Ranking
//
//  Created by kimti on 5/16/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
import CryptoSwift

class FileCache{
    
    static func readCacheFromUrl(path:String, suffix:String)->NSData?{
        var data:NSData?
        let cachePath = getFullCachePathFromUrl(path, suffix:suffix)
        if NSFileManager.defaultManager().fileExistsAtPath(cachePath) {
            data = NSData(contentsOfFile: cachePath)
        }
        return data
    }
    
    
    class func writeCacheToUrl(path:String, data:NSData, suffix:String){
        let cachePath = getFullCachePathFromUrl(path, suffix:suffix)
        data.writeToFile(cachePath, atomically: true)
    }
    
    
    class func getFullCachePathFromUrl(path:String, suffix:String)->String{
        let chchePath=NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache/")
        let fileManager = NSFileManager.defaultManager()
        
        if !(fileManager.fileExistsAtPath(chchePath)) {
            do{
                try fileManager.createDirectoryAtPath(chchePath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                //TODO
            }
        }
        let newPath = chchePath + path.md5() + suffix
        return newPath
    }
    
    class func cleanCache(){
        let chchePath=NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache/")
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(chchePath)
        }catch{
            
        }
        
    }
}
