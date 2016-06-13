//
//  AppDelegate.swift
//  Ranking
//
//  Created by kimti on 5/8/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
//    func encryptConfig() {
//        let path = "/Users/kimti/Desktop/new/Ranking/Ranking/resources/config_en/"
//        
//        let path1 = "/Users/kimti/Desktop/new/Ranking/Ranking/resources/config/"
//        let fileManager = NSFileManager.defaultManager()
//        let enumerator:NSDirectoryEnumerator! = fileManager.enumeratorAtPath(path)
//        while let element = enumerator?.nextObject() as? String {
//            if element.hasSuffix(".json") {
//                let url = NSURL(fileURLWithPath: path + element)
//                let data = NSData(contentsOfURL: url)
//                
//                let encrypted = data!.encrypted()
//                encrypted.writeToFile(path1 + element, atomically: true)
//            }
//        }
//    }
//    
//    func encryptFlag() {
//        let path = "/Users/kimti/Desktop/new/Ranking/Ranking/resources/flag_en/"
//        
//        let path1 = "/Users/kimti/Desktop/new/Ranking/Ranking/resources/flag/"
//        let fileManager = NSFileManager.defaultManager()
//        let enumerator:NSDirectoryEnumerator! = fileManager.enumeratorAtPath(path)
//        while var element = enumerator?.nextObject() as? String {
//            if element.hasSuffix(".png") {
//                
//                
//                let url = NSURL(fileURLWithPath: path + element)
//                let data = NSData(contentsOfURL: url)
//                
//                let range = element.rangeOfString(".png")
//                if range != nil{
//                    element = element.substringToIndex((range?.startIndex)!)
//                }
//                let encrypted = data!.encryptedImage()
//                encrypted.writeToFile(path1 + element + ".img", atomically: true)
//            }
//        }
//    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        encryptConfig()
//        encryptFlag() 国旗不要加密，会慢
        return true
    }
    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}

