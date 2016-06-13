//
//  GenreView.swift
//  Ranking
//
//  Created by kimti on 5/14/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit

@IBDesignable class GenreView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    var view:UIView!;
    
    @IBOutlet weak var closeButton: UIButton!
    var genres:[Genre] = []
    var mediaTypes:[String:String] = [:]
    
    func reloadData(genres:[Genre], mediaTypes:[String:String]) {
        self.genres.removeAll()
        self.genres += genres
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
        let nib = UINib(nibName: "GenreView", bundle: bundle)
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
        return self.genres.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell")! as! ImageTableViewCell
        
        
        
        let genre = self.genres[indexPath.row];
        let genreName = self.mediaTypes[genre.translation_key!]
        cell.cellImageView.image = UIImage(named:genre.translation_key!)
        
        
        cell.cellLabel?.text = genreName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let index = indexPath.row
        
        let genre = self.genres[index]
        
        let key = genre.translation_key
        NSNotificationCenter.defaultCenter().postNotificationName("NSNOTIFICATIONCENTER_SAVE_GENRE", object: key)
        
        self.removeFromSuperview()
    }

    
}
