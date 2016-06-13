//
//  HttpDataDownloaderManager.swift
//  Ranking
//
//  Created by kimti on 5/13/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
import UIKit

class HttpDataDownloaderManager {
    static let shareSingleOne = HttpDataDownloaderManager()
    
    var map = [String : HttpDownloader]()
    
    private func add(urlStr : String, completionHandler:(NSData?,NSError!) -> ()) {
        let cacheData = FileCache.readCacheFromUrl(urlStr,suffix:"")
        if cacheData != nil{
            completionHandler(cacheData,nil);
            return
        }
        
        if self.map[urlStr] == nil{
            let downloader = HttpDownloader(urlStr: urlStr);
            self.map[urlStr] = downloader
            downloader.request { (data, error) in
                self.map.removeValueForKey(urlStr)
                if data != nil{
                    FileCache.writeCacheToUrl(urlStr, data:data!, suffix:"")
                    completionHandler(data,nil);
                }
            }
        }
    }
    
    private func cancel(urlStr : String) {
        if let downloader = self.map[urlStr]{
            downloader.cancel()
            self.map.removeValueForKey(urlStr)
        }
    }
    
    
    
    func resume(url:String, completionHandler:(NSData?,NSError!) -> ()){
        let downloader = map[url]
        if  downloader == nil{
            add(url, completionHandler: {data,error in
                
                completionHandler(data, error)
                
            })
        }else{
            downloader?.resume()
        }
    }
    
    func removeAllNotRunning(){
        var temp = [String]();
        for (k, v) in map{
            if !v.isRunning(){
                temp.append(k)
            }
        }
        
        for k in temp{
            cancel(k)
        }
    }
    
    func suspendAll(){
        for (_, v) in map{
            v.suspend()
        }
    }
    
}