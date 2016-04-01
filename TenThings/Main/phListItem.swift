//
//  phListItem.swift
//  TenThings
//
//  Created by joe on 2/28/16.
//  Copyright © 2016 joe. All rights reserved.
//

import Cocoa

class phListItem: NSView {

    @IBOutlet weak var descriptionLabel: NSTextField!
    
    @IBOutlet weak var commentLink: NSButton!
    
    @IBOutlet weak var articleLink: NSButton!
    @IBOutlet weak var hoverBgView: NSView!
    var trackingArea:NSTrackingArea!

    var _ph: ProductHunt!
    var separator: NSView!
    
    // MARK: - Initializers
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // set tracking area
        let opts: NSTrackingAreaOptions = ([NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways])
        trackingArea = NSTrackingArea(rect: bounds, options: opts, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // set tracking area
        let opts: NSTrackingAreaOptions = ([NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways])
        trackingArea = NSTrackingArea(rect: bounds, options: opts, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func awakeFromNib() {
        initSeparator()
        initHoverBg()
    }
    
    func initHoverBg() {
//        let calayer: CALayer = CALayer()
//        calayer.backgroundColor = NSColor.controlColor().CGColor
//        calayer.opacity = 0.9
//        hoverBgView.wantsLayer = true
//        hoverBgView.layer = calayer
        hoverBgView.alphaValue = 0.7
        hoverBgView.hidden = true
    }
    
    func initSeparator() {
        separator = NSView(frame: CGRect(x: 0, y: self.frame.minY + 1, width: self.frame.width, height: 1))
        let calayer: CALayer = CALayer()
        calayer.backgroundColor = NSColor.lightGrayColor().CGColor
        separator.wantsLayer = true
        separator.layer = calayer
        self.addSubview(separator)
    }
    
    func setPH(ph: ProductHunt) {
        _ph = ph
        descriptionLabel.stringValue = "\(ph.Name) (\(ph.VotesCount) votes): \(ph.Tagline)"
    }
    
    // MARK: Mouse events
    override func mouseEntered(theEvent: NSEvent) {
        hoverBgView.hidden = false
        
    }
    override func mouseExited(theEvent: NSEvent) {
        hoverBgView.hidden = true
        
    }
    
    @IBAction func articleLinkClicked(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: _ph.RedirectUrl)!)
        
    }
    
}
