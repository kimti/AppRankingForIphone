//
//  ViewController.swift
//  Ranking
//
//  Created by kimti on 5/8/16.
//  Copyright © 2016 kimti. All rights reserved.
//

import UIKit
import StoreKit
//reviews
//http://itunes.apple.com/rss/customerreviews/id=400274934/json

//feed
//http://itunes.apple.com/us/rss/toppaidapplications/limit=300/genre=6014/json

//Search
//http://itunes.apple.com/lookup?id=400274934

class ViewController: UIViewController, NSXMLParserDelegate,UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate{
    
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var feedTypeButton: UIButton!
    @IBOutlet weak var genreButton: UIButton!
    
    @IBOutlet weak var backendView: UIView!
    
    @IBOutlet weak var spaceView1: UIView!
    @IBOutlet weak var spaceView2: UIView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var refreshImageView: UIImageView!
    @IBOutlet weak var refreshLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButtonTouch(sender: UIButton) {
        
        backendStart()
    }
    
    @IBAction func countryButtonTouch(sender: UIButton) {
        let countryView = CountryView(frame: self.view.frame)
        countryView.reloadData(countries)
        self.view.addSubview(countryView)
    }
    
    @IBAction func feedTypeButtonTouch(sender: UIButton) {
        
        let feedTypeView = FeedTypeView(frame: self.view.frame)
        feedTypeView.reloadData(feedTypes, mediaTypes: mediaTypes)
        self.view.addSubview(feedTypeView)
    }
    
    @IBAction func genreButtonTouch(sender: UIButton) {
        let genreView = GenreView(frame: self.view.frame)
        genreView.reloadData(genres, mediaTypes: mediaTypes)
        self.view.addSubview(genreView)
    }
    
    var entries = [Entry]();
    var tempEntries = [Entry]();
    var currentValue:String = "";
    var startEntry = false;
    var storingCharacterData = false;
    
    let limit = "limit=200/"
    let genreTranslationKeyDefault = "all";
    let countryDefault = "us"
    let feedTypeTranslationKeyDefault = "toppaidipadapplications"
    
    //创建一个NSOperationQueue实例并添加operation
    let queue:NSOperationQueue = NSOperationQueue()
    
    
    var feedTypes: [FeedType] = []
    var genres:[Genre] = []
    var countries:[String:String] = [:]
    var mediaTypes:[String:String] = [:]
    
    func findFeedType(translation_key:String) -> FeedType?{
        for feedType in feedTypes{
            if feedType.translation_key == translation_key{
                return feedType
            }
        }
        return nil
    }
    
    func findGenre(translation_key:String) -> Genre?{
        for genre in genres{
            if genre.translation_key == translation_key{
                return genre
            }
        }
        return nil
    }
    
    func cachePath() -> String {
        
        let chchePath1=NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache/")
        let fileManager = NSFileManager.defaultManager()
        
        if !(fileManager.fileExistsAtPath(chchePath1)) {
            do{
                try fileManager.createDirectoryAtPath(chchePath1, withIntermediateDirectories: true, attributes: nil)
            }catch{
                //TODO
            }
        }
        
        let chchePath = NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache/data1.xml")
        return chchePath
    }
    
    func downloadData(urlStr:String) -> NSData?{
        do{
            
            //            let url = NSURL(string: urlStr)!
            //            let chchePath = cachePath()
            //            var data = NSData(contentsOfFile: chchePath)
            //            if data == nil{
            //                data = try NSData(contentsOfURL: url, options: .DataReadingMappedIfSafe)
            //                do{
            //                    try data?.writeToFile(chchePath, options: NSDataWritingOptions.DataWritingWithoutOverwriting)
            //                } catch{
            //
            //                }
            //            }
            
            let url = NSURL(string: urlStr)!
            let data = try NSData(contentsOfURL: url, options: .DataReadingMappedIfSafe)
            return data
        }catch{
            //TODO
        }
        return NSData()
    }
    
    let KEY_FEED = "KEY_FEED"
    let KEY_GENRE = "KEY_GENRE"
    let KEY_COUNTRY = "KEY_COUNTRY"
    let KEY_DATE = "KEY_DATE"
    
    
    func getSetting(key : String, defaultValue : String)->String{
        var value = NSUserDefaults.standardUserDefaults().stringForKey(key)
        if (value == nil){
            value = defaultValue
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
        return value!
    }
    
    func saveSetting(key : String, value : String){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setButtonsTitle(){
        
        
        let country = getSetting(KEY_COUNTRY, defaultValue: countryDefault)
        let feedType = getSetting(KEY_FEED, defaultValue: feedTypeTranslationKeyDefault)
        let gnere = getSetting(KEY_GENRE, defaultValue: genreTranslationKeyDefault)
        
        
        parseMediaTypes(country)
        
        let countryName = countries[country]
        let feedTypeName = mediaTypes[feedType]
        let genreName = mediaTypes[gnere]
        
        
        
        
        setButtonTitle(self.countryButton, title: countryName!)
        setButtonTitle(self.feedTypeButton, title: feedTypeName!)
        setButtonTitle(self.genreButton, title: genreName!)
        
        let image = UIImage(named: gnere)
        self.genreButton.setImage(image, forState: .Normal)
//        self.genreButton.setBackgroundImage(image, forState: .Normal)
        
        
        self.genreButton.imageView!.layer.masksToBounds = true
        self.genreButton.imageView!.contentMode = .ScaleAspectFit
        self.genreButton.imageView!.autoresizingMask =  [.FlexibleHeight, .FlexibleWidth]
        self.genreButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        
        setFlag()
        
        
    }
    
    func setFlag() {
        
        let country = getSetting(KEY_COUNTRY, defaultValue: "us")
        let shortName = country
        let image = UIImage(named:shortName)
        self.countryButton.setImage(image, forState: .Normal)
        //        self.countryButton.setBackgroundImage(image,forState:.Normal)
        
    }
    
    
    func setButtonTitle(button:UIButton, title:String){
        button.setTitle(title, forState:UIControlState.Normal) //普通状态下的文字
        button.setTitle(title, forState:UIControlState.Highlighted) //触摸状态下的文字
        button.setTitle(title, forState:UIControlState.Disabled) //禁用状态下的文字
        
        button.setTitleColor(UIColor.hexStringToColor("#489dff"), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        button.setBackgroundColor(UIColor.hexStringToColor("#489dff"), forState: .Highlighted)
        
    }
    
    
    func saveCountry(country : NSNotification) {
        let c = country.object as! String
        saveSetting(KEY_COUNTRY, value: c)
        setButtonsTitle()
        backendStart()
    }
    
    func saveFeedType(feedType : NSNotification) {
        let c = feedType.object as! String
        saveSetting(KEY_FEED, value: c)
        setButtonsTitle()
        backendStart()
    }
    
    func saveGenre(genre : NSNotification) {
        let c = genre.object as! String
        saveSetting(KEY_GENRE, value: c)
        setButtonsTitle()
        backendStart()
    }
    
    
    func start(completionHandler:() -> (), operation:NSOperation){
        
        var country = getSetting(KEY_COUNTRY, defaultValue: countryDefault)
        let feedSetting = getSetting(KEY_FEED, defaultValue: feedTypeTranslationKeyDefault)
        let feedType = findFeedType(feedSetting)
        let genreSetting = getSetting(KEY_GENRE, defaultValue: genreTranslationKeyDefault)
        let genre = findGenre(genreSetting)
        
        var genreParameter = ""
        let genreID = genre?.id
        if !genreID!.isEmpty{
            genreParameter = "genre=" + genreID! + "/"
        }
        
        let urlSuffix = feedType?.urlSuffix
        let urlPrefix = feedType?.urlPrefix
        
        let parameters = limit + genreParameter + urlSuffix!
        
        let range = country.rangeOfString("_")
        if range != nil{
            country = country.substringToIndex((range?.startIndex)!)
        }
        
        let url = urlPrefix!.stringByReplacingOccurrencesOfString("<%= country_code %>", withString: country).stringByReplacingOccurrencesOfString("<%= parameters %>", withString: parameters);
        
        let data = downloadData(url)
        if(operation.cancelled){
            return
        }
        parseData(data!, completionHandler: {NSOperationQueue.mainQueue().addOperationWithBlock({
            completionHandler()
        })})
    }
    
    func parseData(data : NSData, completionHandler:() -> ()){
        self.tempEntries.removeAll()
        let parse = NSXMLParser(data: data)
        parse.delegate = self
        parse.parse()
        completionHandler()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
        if elementName.compare(Constant.kEntryStr) == .OrderedSame{
            let entry = Entry();
            self.tempEntries.append(entry)
            self.startEntry = true;
        }
        if self.startEntry{
            let entry = tempEntries.last;
            if elementName.compare(Constant.kReleaseDateStr) == .OrderedSame{
                entry?.releaseDate = attributeDict["label"];
            }
            if elementName.compare(Constant.kId) == .OrderedSame{
                entry?.id = attributeDict["im:id"];
            }
            if elementName.compare(Constant.kLinkStr) == .OrderedSame{
                entry?.link = attributeDict["href"];
            }
            if elementName.compare(Constant.kCategorytype) == .OrderedSame{
                entry?.category = attributeDict["label"];
            }
            self.storingCharacterData = Constant.elementsToParse.contains(elementName)
        }
        
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        if startEntry {
            let entry = tempEntries.last
            if storingCharacterData{
                let value = currentValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if elementName.compare(Constant.kNameStr) == .OrderedSame{
                    entry?.name = value;
                }
                
                if elementName.compare(Constant.kSummaryStr) == .OrderedSame{
                    entry?.summary = value;
                }
                
                if elementName.compare(Constant.kPriceStr) == .OrderedSame{
                    entry?.price = value;
                }
                
                
                if elementName.compare(Constant.kRightsStr) == .OrderedSame{
                    entry?.rights = value;
                }
                
                if elementName.compare(Constant.kImageStr) == .OrderedSame{
                    entry?.imageLink = value;
                }
                
                
                currentValue = "";
            }
            
            if elementName == Constant.kEntryStr {
                startEntry = false
            }
        }
        
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String){
        if self.storingCharacterData {
            self.currentValue.appendContentsOf(string)
        }
    }
    
    func addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.saveCountry(_:)), name: "NSNOTIFICATIONCENTER_SAVE_COUNTRY", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.saveFeedType(_:)), name: "NSNOTIFICATIONCENTER_SAVE_FEEDTYPE", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.saveGenre(_:)), name: "NSNOTIFICATIONCENTER_SAVE_GENRE", object: nil)
    }
    
    
    func closeButtonDidTouch(sender:UIButton){
        NSLog("按钮点击了事件")
    }
    
    func backendStart() {
        
        self.refreshButton.hidden = true
        self.refreshLabel.hidden = true
        self.refreshImageView.hidden = true
        
        LoadingOverlay.shared.showOverlay(self.view)
        
        queue.cancelAllOperations()
        
        let operation = NSBlockOperation()
        operation.addExecutionBlock({
            [weak operation, weak self] in
            self!.start({}, operation: operation!)
        })
        
        operation.completionBlock = {
            [weak operation, weak self] in
            if(operation!.cancelled){
                return
            }
            
            if self?.tempEntries.count > 0{
                self!.entries.removeAll()
                self!.entries += self!.tempEntries
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableView.hidden = false
                    self?.refreshButton.hidden = true
                    self?.refreshLabel.hidden = true
                    self?.refreshImageView.hidden = true
                    self?.tableView.reloadData()
                    LoadingOverlay.shared.hideOverlayView()
                })
            } else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.refreshButton.hidden = false
                    self?.refreshImageView.hidden = false
                    self?.refreshLabel.hidden = false
                    self?.tableView.hidden = true
                    LoadingOverlay.shared.hideOverlayView()
                })
                
            }
        }
        queue.addOperation(operation)
    }
    
    
    
    
    func stringWithFormat(_ format:String = "yyyy-MM-dd HH:mm:ss") {
        var formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        let d = NSDate().timeIntervalSince1970 - 24 * 60 * 60
        
        print(formatter.stringFromDate(NSDate(timeIntervalSince1970: d)))
    }
    
    func checkCache(){
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let date = getSetting(KEY_DATE, defaultValue: "1970-01-01")
        let oldDate = dateFormatter2.dateFromString(date)
        let old = Int(oldDate!.timeIntervalSince1970 / (24 * 60 * 60))
        let nowDate = NSDate()
        let now = Int(nowDate.timeIntervalSince1970 / (24 * 60 * 60))
        
        if(old != now){
            saveSetting(KEY_DATE, value: dateFormatter2.stringFromDate(nowDate))
            FileCache.cleanCache()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCache()
        
        self.refreshLabel.textColor = UIColor.hexStringToColor("#489dff")
        
        self.refreshImageView!.layer.masksToBounds = true
        self.refreshImageView!.contentMode = .ScaleAspectFit
        self.refreshImageView!.autoresizingMask =  [.FlexibleHeight, .FlexibleWidth]
        
        
        //        #489dff
        self.backendView.layer.masksToBounds = true;
        self.backendView.layer.cornerRadius = 4
        self.backendView.layer.borderColor  = UIColor.hexStringToColor("#489dff").CGColor
        self.backendView.layer.borderWidth = 1
        
        self.spaceView1.backgroundColor = UIColor.hexStringToColor("#489dff")
        self.spaceView2.backgroundColor = UIColor.hexStringToColor("#489dff")
        
        
        self.tableView.hidden = true
        addObserver()
        
        let nib = UINib(nibName: "EntryTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.tableView.registerNib(nib, forCellReuseIdentifier: "EntryTableViewCell")
        
        //        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let country = getSetting(KEY_COUNTRY, defaultValue: countryDefault)
        parseGenre()
        parseCountry()
        parseFeedType()
        parseMediaTypes(country)
        
        setButtonsTitle()
        
        backendStart()
    }
    func parseFeedType(){
        do {
            let url = NSBundle.mainBundle().URLForResource("feed_types", withExtension: "json")
            let encryptData = NSData(contentsOfURL: url!)
            
//            let data = encryptData?.decrypted()
            let data = encryptData
            
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let array = object as? NSArray {
                for feedType in array {
                    let translation_key = feedType["translation_key"] as? String
                    let urlPrefix = feedType["urlPrefix"] as? String
                    let urlSuffix = feedType["urlSuffix"] as? String
                    
                    let feed = FeedType();
                    feed.translation_key =  translation_key
                    feed.urlPrefix = urlPrefix
                    feed.urlSuffix = urlSuffix
                    feedTypes.append(feed)
                    
                }
            }
        } catch {
            // Handle Error
        }
    }
    
    func parseGenre(){
        do {
            let url = NSBundle.mainBundle().URLForResource("genre", withExtension: "json")
            let encryptData = NSData(contentsOfURL: url!)
//            let data = encryptData?.decrypted()
            let data = encryptData
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let array = object as? NSArray {
                for genreObject in array {
                    let id = genreObject["id"] as? String
                    let translation_key = genreObject["translation_key"] as? String
                    
                    let genre = Genre();
                    genre.translation_key =  translation_key
                    genre.id = id
                    genres.append(genre)
                }
            }
        } catch {
            // Handle Error
        }
    }
    
    func parseCountry(){
        do {
            let url = NSBundle.mainBundle().URLForResource("country_us", withExtension: "json")
            let encryptData = NSData(contentsOfURL: url!)
//            let data = encryptData?.decrypted()
            let data = encryptData
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            let tempCountries = (object as? [String : String])!
            
            for (k, v) in tempCountries{
                let range = k.rangeOfString("_")
                if range == nil{
                    countries[k] = v
                }
            }
            
        } catch {
            // Handle Error
        }
    }
    
    func parseMediaTypes(countrySubfix: String){
        do {
            var url = NSBundle.mainBundle().URLForResource("media_types_" + countrySubfix, withExtension: "json")
            let path = url?.absoluteString
            if path == nil{
                url = NSBundle.mainBundle().URLForResource("media_types_" + "us", withExtension: "json")
            }
            
            let encryptData = NSData(contentsOfURL: url!)
//            let data = encryptData?.decrypted()
            let data = encryptData
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            mediaTypes = (object as? [String : String])!
        } catch {
            // Handle Error
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("EntryTableViewCell")! as! EntryTableViewCell
        
        let entry = self.entries[indexPath.row]
        
        for view in cell.ratingView.subviews{
            view.removeFromSuperview()
        }
        cell.cellUserRatingCount.text = ""
        
        if(entry.isRatingLoaded){
            cell.ratingView.addSubview(entry.ratingView!)
            if(entry.userRatingCount > 0){
                cell.cellUserRatingCount.text = "(" + String(entry.userRatingCount) + ")"
            }
        }
        
        
        cell.cellLabel.text = entry.name
        cell.cellPriceLabel.text = entry.price
        cell.cellPriceLabel.layer.borderWidth = 1
        cell.cellPriceLabel.layer.borderColor = UIColor.hexStringToColor("#489dff").CGColor
        cell.cellPriceLabel.layer.masksToBounds = true
        cell.cellPriceLabel.layer.cornerRadius = 5
        cell.cellPriceLabel.textColor = UIColor.hexStringToColor("#489dff")
        
        cell.cellNumberLabel.text = String(indexPath.row + 1)
        cell.cellCategoryLabel.text = entry.category
        cell.cellImageView!.image = entry.image
        cell.cellImageView.layer.cornerRadius = 12
        cell.cellImageView!.layer.masksToBounds = true
        cell.cellImageView!.clipsToBounds = true
        cell.cellImageView!.contentMode = .ScaleAspectFit
        cell.cellImageView!.autoresizingMask =  [.FlexibleHeight, .FlexibleWidth]
        
        //        cell.setNeedsLayout()
        if (!tableView.dragging && !tableView.decelerating) {
            resumeOrAdd(cell, entry: entry)
        }
        
        return cell
        
    }
    
    class func addRating(averageUserRating:Float, userRatingCount:Int, cell:EntryTableViewCell) ->UIView {
        
        let view = UIView(frame: cell.ratingView.bounds)
        
        if(userRatingCount > 0){
            let width = CGFloat(15)
            var ratingImage:UIImage
            for index in 1...5 {
                if(averageUserRating > Float(index - 1) && Float(averageUserRating) < Float(index)){
                    ratingImage = UIImage(named: "half-rating")!
                } else if(averageUserRating > Float(index) || averageUserRating == Float(index)){
                    ratingImage = UIImage(named: "full-rating")!
                }else{
                    ratingImage = UIImage(named: "empty-rating")!
                }
                
                let imageView1 = UIImageView(frame: CGRectMake((CGFloat(index) - CGFloat(1.0)) * width, 0, width, width))
                imageView1.image = ratingImage
                view.addSubview(imageView1)
                if userRatingCount > 0{
                    cell.cellUserRatingCount.text = "(" + String(userRatingCount) + ")"
                }
                
            }
        }
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 90
    }
    
    
    private func getRatingFromJson(data:NSData) -> (averageUserRating: Float, userRatingCount:Int){
        var averageUserRating:Float = 0
        var userRatingCount:Int = 0
        do {
            
            let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let results = object["results"] as? NSArray
            if let array = results {
                for result in array {
                    let a = result["averageUserRatingForCurrentVersion"]
                    let b = result["userRatingCountForCurrentVersion"]
                    if a != nil &&  a! != nil{
                        averageUserRating = (a as? Float)!
                    }
                    if b != nil && b! != nil{
                        userRatingCount = (b as? Int)!
                    }
                }
            }
        } catch {
            // Handle Error
        }
        return (averageUserRating,userRatingCount)
    }
    
    private func resumeOrAdd(cell: EntryTableViewCell, entry:Entry){
        if !entry.isImageLoaded {
            HttpDownloaderManager.shareSingleOne.resume(entry.imageLink!, completionHandler: {image,error in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    [weak self] in
                    
                    entry.image = image
                    cell.cellImageView.image = entry.image
                    entry.isImageLoaded = true
                })
            })
        }
        
        if !entry.isRatingLoaded {
            let country = getSetting(KEY_COUNTRY, defaultValue: countryDefault)
            let link = "https://itunes.apple.com/" + country + "/lookup?id=" + entry.id!
            //            let link = "https://itunes.apple.com/cn/lookup?id=1113509694"
            HttpDataDownloaderManager.shareSingleOne.resume(link, completionHandler:  {[weak self] data,error in
                
                let json = self!.getRatingFromJson(data!)
                let averageUserRating = json.averageUserRating
                let userRatingCount = json.userRatingCount
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    [weak self] in
                    
                    entry.averageUserRating = averageUserRating
                    entry.userRatingCount = userRatingCount
                    
                    let view = ViewController.addRating(entry.averageUserRating, userRatingCount:entry.userRatingCount, cell:cell)
                    entry.ratingView = view
                    
                    entry.isRatingLoaded = true
                    
                    cell.ratingView.addSubview(entry.ratingView!)
                })
                
                })
        }
    }
    
    private func resumeOrAdd(indexPath: NSIndexPath, entry:Entry){
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EntryTableViewCell
        resumeOrAdd(cell, entry: entry)
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        HttpDownloaderManager.shareSingleOne.suspendAll()
        HttpDataDownloaderManager.shareSingleOne.suspendAll()
    }
    
    
    
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            loadImagesForOnscreenCells()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        loadImagesForOnscreenCells()
    }
    
    
    func loadImagesForOnscreenCells () {
        
        if let pathsArray = self.tableView.indexPathsForVisibleRows {
            for p in pathsArray{
                let row = p.row;
                let entry = self.entries[row]
                resumeOrAdd(p, entry: entry)
            }
        }
        
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !LoadingOverlay.shared.isShow{
            let index = indexPath.row
            let entry = self.entries[index]
            print(entry.name)
            openAppUrl(entry.link!)
            //            openAppstore(entry.id!)
        }
    }
    
    private func openAppUrl(url: String) {
        let nativeURL = url.stringByReplacingOccurrencesOfString("https:", withString: "itms-apps:")
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:nativeURL)!) {
            UIApplication.sharedApplication().openURL(NSURL(string:url)!)
        }
    }
    
    func productViewControllerDidFinish(viewController:SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true,
                                                     completion: nil)
    }
    
    private func openAppstore(id:String){
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [SKStoreProductParameterITunesItemIdentifier :
            id]
        
        storeViewController.loadProductWithParameters(parameters,
                                                      completionBlock: {result, error in
                                                        if result {
                                                            self.presentViewController(storeViewController,
                                                                animated: true, completion: nil)
                                                        }
                                                        
        })
    }
    
}

