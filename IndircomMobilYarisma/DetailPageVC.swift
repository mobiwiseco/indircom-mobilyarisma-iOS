//
//  DetailPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 20/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import Alamofire

class DetailPageVC: UIViewController{
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var appName: UILabel!
    @IBOutlet var appLogo: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    var appList = [App]()
    var imageList = [UIImage]()
    var currentPosition = 0
    var token : String?
    var userID : String?
    
    var anyPreviousAppLeft : Bool?
    
    var logo1 = UIView()
    var logo2 = UIView()
    
    let placeHolderImage = UIImageView(image: UIImage(named: "image_placeholder"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = Defaults["token"].string
        userID = Defaults["id"].string
        
        self.nextButton.hidden = true
        self.previousButton.hidden = true
        
        placeHolderImage.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        appLogo.addSubview(placeHolderImage)
        
        appName.text = "Loading.."

        self.getUnratedApps()
    }
    
    func updateUI(position: Int, flipDirection: Int) {
        let currentApp = appList[position]
        
        if let a = placeHolderImage as UIView? {
            placeHolderImage.removeFromSuperview()
        }
     
        if let a = logo2 as UIView? {
            logo2.removeFromSuperview()
        }
        
        if imageList.count <= position {
            logo1 = placeHolderImage
        } else {
            logo1 = UIImageView(image: imageList[(position == 0 ? 0 : position-1)])
        }
        
        if imageList.count <= position {
            logo2 = placeHolderImage
        } else if let image = imageList[position] as UIImage? {
            logo2 = UIImageView(image: imageList[position])
        } else {
            logo2 = UIImageView(image: UIImage(named: "image_placeholder"))
        }
        
        logo1.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        logo2.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        appLogo.addSubview(logo1)
        
        var views = (frontView: logo1, backView: logo2)
        if flipDirection > 0 {
            let transitionOptions: UIViewAnimationOptions = UIViewAnimationOptions.TransitionFlipFromRight
            UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.4, options: transitionOptions, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = UIViewAnimationOptions.TransitionFlipFromLeft
            UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.4, options: transitionOptions, completion: nil)
        }
        
        appName.text = currentApp.appName
        
        self.likeButton.setImage(UIImage(named: "icon_like_unselected"), forState: UIControlState.Normal)
        self.dislikeButton.setImage(UIImage(named: "icon_dislike_unselected"), forState: UIControlState.Normal)
        
        if self.getNextUnratedAppPosition(self.currentPosition) > -1 {
            self.nextButton.hidden = false
        } else {
            self.nextButton.hidden = true
        }
        
        if self.getPreviousUnratedAppPosition(self.currentPosition) > -1 {
            self.previousButton.hidden = false
        } else {
            self.previousButton.hidden = true
        }
    }
    
    @IBAction func onDislikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_dislike_selected"), forState: UIControlState.Normal)
        self.shakeButtonWithPop(self.dislikeButton, rate: "0", shakeDirection: -1)
    }
    
    @IBAction func onLikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_like_selected"), forState: UIControlState.Normal)
        self.shakeButtonWithPop(self.likeButton, rate: "1", shakeDirection: 1)
    }
    
    @IBAction func onInfoButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func onNextButtonClick(sender: UIButton) {
        self.currentPosition = self.getNextUnratedAppPosition(currentPosition)
        self.shakeButtonWithPop(self.nextButton, shakeDirection: 1, currentPosition: self.currentPosition)
    }
    
    @IBAction func onPreviousButtonClick(sender: UIButton) {
        self.currentPosition = self.getPreviousUnratedAppPosition(currentPosition)
        self.shakeButtonWithPop(self.previousButton, shakeDirection: -1, currentPosition: self.currentPosition)
    }
    
    @IBAction func aboutPageButtonTapped(sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Servis Methodları */
    /* ###################################################### */
    
    func getUnratedApps() {
        let network = NetworkApi()
        network.getUnratedApps(userID!, token: token!) { (request, response, data, error) -> Void in
            print(data!)
            if let feed = data as? NSDictionary {
                if let entries = feed["apps"] as? NSArray {
                    for entry in entries {
                        if let name = entry as? NSDictionary {
                            self.appList.append(App(appInfo: name))
                            println(name)
                        }
                    }
                    self.getImages(0)
                }
                else{
                    self.performSegueWithIdentifier("ThanksPageVC", sender: self)
                }
            } else {
                //we should handle the error
                self.alertWithTitle("Hata", message: "Uygulamalar gösterilirken bir hata oluştu!")
            }
            
        }
    }
    
    func getImages(position: Int) {
        let url = NSURL(string: appList[position].appImageURL!)
        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageDownloaderOptions.LowPriority, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
            
        }, completed: { (image: UIImage!, data: NSData!, error: NSError!, finished Bool) -> Void in
            self.imageList.append(image)
            if (position+1 < self.appList.count) {
                self.getImages(position+1)
            }
            // update UI when the first app image is downloaded
            if (position == 0 || self.currentPosition == self.imageList.count - 1) {
                self.updateUI(position, flipDirection: 1)
            }
        })
    }
    
    func sendAppRate(appID : String , rate : String)
    {
        let network = NetworkApi()
        network.sendAppRate(appID, rate: rate, userID: userID!, token: token!) { (request, response, data, error) -> Void in
            
        }
    }
    /* ###################################################### */

    func appRateConfig(rate : String)
    {
        if( appList.count > 0){
            var currentApp = appList[self.currentPosition]
            self.sendAppRate(currentApp.appID!, rate:rate)
            currentApp.isVoted = true
            
            var pos = getNextUnratedAppPosition(currentPosition)
            if pos > -1 {
                self.currentPosition = pos
            } else {
                self.currentPosition = getPreviousUnratedAppPosition(currentPosition)
            }
            
            if self.currentPosition > -1 {
                if pos == -1 {
                    self.updateUI(self.currentPosition, flipDirection: -1)
                } else {
                    self.updateUI(self.currentPosition, flipDirection: 1)
                }
            } else {
                self.performSegueWithIdentifier("ThanksPageVC", sender: self)
                Defaults.remove("token")
                Defaults.remove("id")
            }
        }
    }
    
    func getNextUnratedAppPosition(currentPos: Int) -> Int {
        var pos = currentPos + 1
        if pos >= appList.count {
            return -1
        } else if !appList[pos].isVoted! {
            return pos
        } else {
            return self.getNextUnratedAppPosition(pos)
        }
    }
    
    func getPreviousUnratedAppPosition(currentPos: Int) -> Int {
        var pos = currentPos - 1
        if pos == -1 {
            return -1
        } else if !appList[pos].isVoted! {
            return pos
        } else {
            return self.getPreviousUnratedAppPosition(pos)
        }
    }
    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func shakeButtonWithPop(button: UIButton!, rate: String, shakeDirection: Int)
    {
        button.userInteractionEnabled = false
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        positionAnimation.velocity = shakeDirection * 2000
        positionAnimation.springBounciness = 18
        positionAnimation.completionBlock = {(animation, finished) in
            self.appRateConfig(rate)
            button.userInteractionEnabled = true
        }
        button.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    func shakeButtonWithPop(button: UIButton!, shakeDirection: Int, currentPosition: Int)
    {
        button.userInteractionEnabled = false
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        positionAnimation.velocity = shakeDirection * 500
        positionAnimation.springBounciness = 18
        positionAnimation.completionBlock = {(animation, finished) in
            button.userInteractionEnabled = true
            self.updateUI(self.currentPosition, flipDirection: shakeDirection)
        }
        button.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "InfoPageVC"){
            
            let infoPage = segue.destinationViewController as InfoPageVC
            var currentApp : App = appList[self.currentPosition]
            infoPage.currentApp = currentApp
            
        }
        
        else if(segue.identifier == "AboutPageVC")
        {
            let aboutPage = segue.destinationViewController as AboutPageVC
            
        }
        
    }
    
}
