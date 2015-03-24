//
//  DetailPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 20/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import Alamofire

class DetailPageVC: UIViewController {
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var appName: UILabel!
    @IBOutlet var appLogo: UIImageView!
    var appList = [App]()
    var currentPosition = 0
    var token : String?
    var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = Defaults["token"].string
        userID = Defaults["id"].string

        self.getUnratedApps()
        

    }
    
    func updateUI(position: Int) {
        let currentApp = appList[position]
        let imageURL = NSURL(string: "http://gabrielecirulli.github.io/2048/meta/og_image.png")
        let imageData = NSData(contentsOfURL: imageURL!)
        appLogo.image = UIImage(data: imageData!)
        appName.text = currentApp.appID
        self.likeButton.setImage(UIImage(named: "icon_like_unselected"), forState: UIControlState.Normal)
        self.dislikeButton.setImage(UIImage(named: "icon_dislike_unselected"), forState: UIControlState.Normal)
        
    }
    
    @IBAction func onDislikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_dislike_selected"), forState: UIControlState.Normal)
        
            self.shakeButtonWithPop(self.dislikeButton, rate: "0")
        
        }
    
    @IBAction func onLikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_like_selected"), forState: UIControlState.Normal)
        
           // self.shakeButton(self.likeButton)
            self.shakeButtonWithPop(self.likeButton,rate: "1")
        
    }
    
    @IBAction func onInfoButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func onNextButtonClick(sender: UIButton) {
        
        
        self.currentPosition++
        self.updateUI(self.currentPosition)
    }
    
    @IBAction func onPreviousButtonClick(sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Servis Methodları */
    /* ###################################################### */
    
    func getUnratedApps()
    {
        let network = NetworkApi()
        network.getUnratedApps(userID!, token: token!) { (request, response, data, error) -> Void in
            
            if let feed = data as? NSDictionary {
                if let entries = feed["apps"] as? NSArray {
                    for entry in entries {
                        if let name = entry as? NSDictionary {
                            self.appList.append(App(appInfo: name))
                            println(name)
                            
                        }
                    }
                    self.updateUI(0)
                }
            } else {
                //we should handle the error
                self.alertWithTitle("Hata", message: "Uygulamalar gösterilirken bir hata oluştu!")
            }
            
        }
    }
    
    func sendAppRate(appID : String , rate : String)
    {
        let network = NetworkApi()
        
        network.sendAppRate(appID, rate: rate, userID: userID!, token: token!) { (request, response, data, error) -> Void in
            
            println(data?)
            println(appID)
            
        }
    }
    
    /* ###################################################### */

    
    func appRateConfig(rate : String)
    {
        if( appList.count > 0){
        
        var currentApp = appList[self.currentPosition]
        self.sendAppRate(currentApp.appID!, rate:rate)
        self.appList.removeAtIndex(self.currentPosition)
        self.updateUI(self.currentPosition)
        
            }
        
    }
    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func shakeButton(button : UIButton!){
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.5
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.fromValue = NSValue(CGPoint: CGPointMake(button.center.x - 5, button.center.y + 5))
        shake.toValue = NSValue(CGPoint: CGPointMake(button.center.x + 5, button.center.y - 5))
        button?.layer.addAnimation(shake, forKey: "position")
    
    }
    

    func shakeButtonWithPop(button : UIButton! , rate : String)
    {
        button.userInteractionEnabled = false
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        positionAnimation.velocity = 2000
        positionAnimation.springBounciness = 18
        positionAnimation.completionBlock = {(animation, finished) in
            
            self.appRateConfig(rate)
            button.userInteractionEnabled = true
            println("pop animation finished")
        }
        button.layer .pop_addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
//    func scaleLabelAnimation(appNameLabel : UILabel!)
//    {
//        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
//        scaleAnimation.toValue = NSValue(CGSize: CGSizeMake(0.5, 0.5))
//        scaleAnimation.springBounciness = 10.0
//        scaleAnimation.completionBlock = {(animation, finished) in
//            
//        }
//        
//        appNameLabel.pop_addAnimation(scaleAnimation, forKey: "springAnimation")
//    }
    
    
}
