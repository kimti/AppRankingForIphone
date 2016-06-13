//
//  HttpDownloader.swift
//  Ranking
//
//  Created by kimti on 5/13/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
import UIKit

class HttpDownloader{
    
    let urlStr : String
    var task: NSURLSessionDataTask!
    
    init(urlStr:String) {
        self.urlStr = urlStr
    }
    
    func request(completionHandler:(NSData?,NSError!) -> ()){
        
        let url = NSURL(string:urlStr)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            completionHandler(data,error)
        })
        task.resume()
    }
    
    
    func cancel() {
        task.cancel()
    }
    
    func isRunning() -> Bool{
        return task.state == NSURLSessionTaskState.Running || task.state == NSURLSessionTaskState.Completed
    }
    
    func suspend(){
        task.suspend()
    }
    
    func resume(){
        task.resume()
    }
}