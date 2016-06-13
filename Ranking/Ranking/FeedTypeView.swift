//
//  FeedTypeView.swift
//  Ranking
//
//  Created by kimti on 5/14/16.
//  Copyright © 2016 kimti. All rights reserved.
//


import UIKit

@IBDesignable class FeedTypeView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var view:UIView!;
    
    var feedTypes : [FeedType] = []
    var mediaTypes:[String:String] = [:]
    
    func reloadData(feedTypes : [FeedType], mediaTypes:[String:String]) {
        self.feedTypes.removeAll()
        self.feedTypes += feedTypes
        self.tableView.reloadData()
        self.mediaTypes.removeAll()
        self.mediaTypes.update(mediaTypes)
    }
    
    
    
    @IBAction func closeButtonTouchDown(sender: UIButton) {
        self.removeFromSuperview()
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FeedTypeView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        let cellNib = UINib(nibName: "ImageTableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "ImageTableViewCell")
        self.tableView.separatorColor = UIColor.hexStringToColor("#489dff")
        
        
        self.closeButton.setTitleColor(UIColor.hexStringToColor("#489dff"), forState: .Highlighted)
        self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.closeButton.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
        self.closeButton.setBackgroundColor(UIColor.hexStringToColor("#489dff"), forState: .Normal)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedTypes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ImageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell")! as! ImageTableViewCell
        
        
        
        let feedType = self.feedTypes[indexPath.row];
        let genreName = self.mediaTypes[feedType.translation_key!]
        cell.cellLabel?.text = genreName
        
        cell.cellImageView.image = UIImage(named:feedType.translation_key!)

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let index = indexPath.row
        
        let feedType = self.feedTypes[index]
        
        let key = feedType.translation_key
        NSNotificationCenter.defaultCenter().postNotificationName("NSNOTIFICATIONCENTER_SAVE_FEEDTYPE", object: key)
        
        self.removeFromSuperview()
    }

}
