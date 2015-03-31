//
//  InfoPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 25/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit


class InfoPageVC: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var appImage: UIImageView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var appContentTV: UITextView!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var downloadButtonView: UIView!
    
    var currentApp : App?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIwithAppObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UI setted here with App object
    func setUIwithAppObject()
    {
        appNameLabel?.text = self.currentApp?.appName!
        appContentTV?.text = self.currentApp?.appDescription!
        
        if var urlStr = self.currentApp?.appImageURL{
            var imageURL = NSURL(string: urlStr)
            
            self.appImage?.sd_setImageWithURL(imageURL, completed: { (image : UIImage!, error : NSError!, cashType : SDImageCacheType, imageUrl : NSURL!) -> Void in
                
            })
        }
        
        if currentApp?.appDownloadURL?.rangeOfString("itunes.apple") == nil {
            self.downloadButton.enabled = false
            self.downloadButtonView.hidden = true
        }
    }
    
    //download button takes to user appstore or webview
    @IBAction func downloadButtonTapped(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: self.currentApp!.appDownloadURL!)!)

    }
    
    @IBAction func closeButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
}
