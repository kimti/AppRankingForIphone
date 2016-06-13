//
//  LoadingOverlay.swift
//  Ranking
//
//  Created by kimti on 5/24/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    var isShow:Bool = false
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        overlayView.addSubview(activityIndicator)
    }
    
    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
        self.isShow = true
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        self.isShow = false
    }
    
    
    
    
}