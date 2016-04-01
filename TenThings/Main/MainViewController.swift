//
//  MainViewController.swift
//  TenThings
//
//  Created by joe on 2/7/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    // MARK: - Vars
    // MARK:data
    var tenThingsData: TenThings!
    
    // MARK:ontrol
    @IBOutlet weak var settingsButton: NSButton!
    
    @IBOutlet weak var ycButton: NSButton!
    @IBOutlet weak var phButton: NSButton!
    @IBOutlet weak var ghButton: NSButton!
    
    // MARK: GH sub buttons
    @IBOutlet weak var jsButton: NSButton!
    @IBOutlet weak var goButton: NSButton!
    @IBOutlet weak var swiftButton: NSButton!
    @IBOutlet weak var pythonButton: NSButton!
    @IBOutlet weak var rubyButton: NSButton!
    var subButtonArr = [NSButton]()
    
    @IBOutlet weak var timerLabel: NSTextField!
    var timerCounter:NSTimeInterval!
    var countdownTimer: NSTimer!

    // MARK:view
    @IBOutlet weak var collectionView: NSScrollView!
    var currentViews = [NSView]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yesterdayStr = yesterdayString()
        readJsonFromWeb("https://raw.githubusercontent.com/10things/data/master/\(yesterdayStr).json")
        initSeparator()
        
        ycButton.alphaValue = 1.0
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 0.2
        
        subButtonArr = [jsButton, goButton, swiftButton, rubyButton, pythonButton]
        setGhSubButtonsAlpha(0.2)
        
        // count down
        beginCountdown()

    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        
//        let menu = NSMenu()
//        
//        menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
//        menu.addItem(NSMenuItem.separatorItem())
//        menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
        
        exit(0)
        
    }
    
    
    
    // MARK: Data
    
    func yesterdayString() -> String {
        let calendar = NSCalendar.currentCalendar()
        let oneDaysAgo = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let components = calendar.components([.Year, .Month, .Day], fromDate: oneDaysAgo!)
        
        let month = String(format: "%02d", components.month)
        let day = String(format: "%02d", components.day)
        return "\(components.year)-\(month)-\(day)"
    }
    
    func twoDaysString() -> String {
        let calendar = NSCalendar.currentCalendar()
        let oneDaysAgo = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
        let components = calendar.components([.Year, .Month, .Day], fromDate: oneDaysAgo!)
        
        let month = String(format: "%02d", components.month)
        let day = String(format: "%02d", components.day)
        return "\(components.year)-\(month)-\(day)"
    }
    
    func readJsonFromFile() {
        let filePath = NSBundle.mainBundle().pathForResource("2016-02-22",ofType:"json")
        if let d = NSData(contentsOfFile: filePath! ) {
            let json = JSON(data: d)
            print("json: \(json)")
            tenThingsData = TenThings(data: json)
            print("Data:\n\(tenThingsData)")

        }
        
    }
    
    func readJsonFromWeb(var url: String) {
        
        if let d = NSData(contentsOfURL: NSURL(string: url)!) {
            let json = JSON(data: d)
            print("json: \(json)")
            tenThingsData = TenThings(data: json)
            print("Data:\n\(tenThingsData)")
            
            if tenThingsData != nil {
                initLists()
            }
        } else {
            let twoDays = twoDaysString()
            url = "https://raw.githubusercontent.com/10things/data/master/\(twoDays).json"
            if let d = NSData(contentsOfURL: NSURL(string: url)!) {
                let json = JSON(data: d)
                print("json: \(json)")
                tenThingsData = TenThings(data: json)
                print("Data:\n\(tenThingsData)")
                
                if tenThingsData != nil {
                    initLists()
                }
            }
        }
        
    }
    
    func setBackground(color:CGColorRef) {
        let calayer: CALayer = CALayer()
        calayer.backgroundColor = color
        view.wantsLayer = true
        view.layer = calayer
    }
    
    func initSeparator() {
        let separator = NSView(frame: CGRect(x: 15, y: collectionView.frame.maxY + 10, width: view.frame.width - 30, height: 1))
        let calayer: CALayer = CALayer()
        calayer.backgroundColor = NSColor.lightGrayColor().CGColor
        separator.wantsLayer = true
        separator.layer = calayer
        view.addSubview(separator)
    }
    
    // MARK: Init list
    func initLists() {
        showHnList()
    }
    
    func showHnList() {
        
        removeAllLists()
        for i in 0...9 {
            
            var objects: NSArray?;
            NSBundle.mainBundle().loadNibNamed("hnListItem", owner: self, topLevelObjects: &objects)
            for o in objects! {
                if let  ycView = o as? hnListItem {
                    ycView.frame = CGRect(x: 0, y: CGFloat(i*60), width: collectionView.frame.width, height: 60.0)
                    ycView.setHN(i+1, hn: tenThingsData.HN[i])
                    collectionView.addSubview(ycView)
                    if i == 9 {
                        ycView.separator.removeFromSuperview()
                    }
                    currentViews.append(ycView)
                }
                
            }
        }
        view.layout()
        collectionView.layout()

    }
    
    func showGhList(language: String) {
        let reposArr = tenThingsData.findGithubRepoByLanguage(language)
        if reposArr.count < 10 {
            return
        }
        removeAllLists()
        for i in 0...9 {
            
            var objects: NSArray?;
            NSBundle.mainBundle().loadNibNamed("ghListItem", owner: self, topLevelObjects: &objects)
            for o in objects! {
                if let  ghView = o as? ghListItem {
                    ghView.frame = CGRect(x: 0.0, y: CGFloat(i*60), width: collectionView.frame.width, height: 60)
                    
                    // repos
                    ghView.setGH(reposArr[i])
                    collectionView.addSubview(ghView)
                    if i == 9 {
                        ghView.separator.removeFromSuperview()
                    }
                    currentViews.append(ghView)
                }
                
            }
        }
    }
    
    func showPhList() {
        removeAllLists()
        for i in 0...9 {
            
            var objects: NSArray?;
            NSBundle.mainBundle().loadNibNamed("phListItem", owner: self, topLevelObjects: &objects)
            for o in objects! {
                if let  phView = o as? phListItem {
                    phView.frame = CGRect(x: 0.0, y: CGFloat(i*60), width: collectionView.frame.width, height: 60)
                    phView.setPH(tenThingsData.PH[i])
                    collectionView.addSubview(phView)
                    if i == 9 {
                        phView.separator.removeFromSuperview()
                    }
                    currentViews.append(phView)
                }
                
            }
        }
    }
    
    func removeAllLists() {
        for s in currentViews {
            s.removeFromSuperview()
        }
    }
    
    // MARK: Count down
    func beginCountdown() {
        timerCounter = NSTimeInterval(10 * 60)
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func onTimer(timer:NSTimer!) {
        // Here is the string containing the timer
        // Update your label here
        timerLabel.stringValue = (stringFromTimeInterval(timerCounter))
        timerCounter!--
        if timerCounter < 1 {
            countdownTimer.invalidate()
        }
    }
    
    func stopTimer() {
        countdownTimer.invalidate()
        for s in view.subviews {
            s.removeFromSuperview()
        }
        
        // show a warning
        let backToWorkLabel = NSTextField(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        backToWorkLabel.stringValue = "Time's up!\nBack To Work!"
        backToWorkLabel.font = NSFont(name: "SF-UI", size: 40)
    }
    
    // MARK: Button clicks
    @IBAction func ycClicked(sender: AnyObject) {
        ycButton.alphaValue = 1.0
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 0.2
        setGhSubButtonsAlpha(0.2)
        showHnList()
    }
    
    @IBAction func phClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 1
        ghButton.alphaValue = 0.2
        setGhSubButtonsAlpha(0.2)
        showPhList()

    }
    
    @IBAction func ghClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(0)
        showGhList("javascript")
    }
    
    @IBAction func jsClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(0)
        showGhList("javascript")
    }
    
    @IBAction func goClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(1)
        showGhList("go")
    }
    
    @IBAction func swiftClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(2)
        showGhList("swift")
    }
    @IBAction func rubyClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(3)
        showGhList("ruby")
    }
    @IBAction func pythonClicked(sender: AnyObject) {
        ycButton.alphaValue = 0.2
        phButton.alphaValue = 0.2
        ghButton.alphaValue = 1
        showSubButton(4)
        showGhList("python")
    }
    
    func setGhSubButtonsAlpha(alpha: CGFloat) {
        for b in subButtonArr {
            b.alphaValue = alpha
        }
    }
    
    func showSubButton(index: Int) {
        setGhSubButtonsAlpha(0.2)

        if index < 0 || index > subButtonArr.count - 1 {
            return
        }
        subButtonArr[index].alphaValue = 1
    }
    
    func showGhSubButtons() {
        for b in subButtonArr {
            b.hidden = false
        }
    }
    
    func hideGhSubButtons() {
        for b in subButtonArr {
            b.hidden = true
        }
    }
}
