//
//  CountryView.swift
//  Ranking
//
//  Created by kimti on 5/11/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit

@IBDesignable class CountryView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var view:UIView!;
    
    
    
    var countrys: [String:String] = [:]
    var items:[String] = []
    
    func reloadData(countrys: [String:String]) {
        
        self.countrys.removeAll()
        self.countrys.update(countrys)
        
        self.items.removeAll()
        self.items += self.countrys.values
        self.items = self.items.sort{$0 < $1}
        
        self.tableView.reloadData();
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
        let nib = UINib(nibName: "CountryView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        let cellNib = UINib(nibName: "CountryTableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "CountryTableViewCell")
        
        
        self.tableView.separatorColor = UIColor.hexStringToColor("#489dff")
        
        self.closeButton.setTitleColor(UIColor.hexStringToColor("#489dff"), forState: .Highlighted)
        self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.closeButton.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
        self.closeButton.setBackgroundColor(UIColor.hexStringToColor("#489dff"), forState: .Normal)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CountryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CountryTableViewCell")! as! CountryTableViewCell

        let country = self.items[indexPath.row];
        
        cell.cellLabel?.text = country
        
        let shortName = self.countrys.allKeysForValue(country)[0]
        
        cell.cellImageView!.image = UIImage(named:shortName)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let country = self.items[index]
        let shortName = self.countrys.allKeysForValue(country)[0]
        NSNotificationCenter.defaultCenter().postNotificationName("NSNOTIFICATIONCENTER_SAVE_COUNTRY", object: shortName)
        self.removeFromSuperview()
    }
    
}
