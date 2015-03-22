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
    
    var userToken : String = ""
    @IBOutlet var appName: UILabel!
    @IBOutlet var appLogo: UIImageView!
    var appList = [App]()
    var currentPosition = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Tamam token geldi : \(userToken) ")

        Alamofire.request(.POST, "http://www.akilliyazilim.org/indircom/indir.com/public/api/v1/161941334/unrated", parameters: ["token": "ocGkK3kjb7RjdRghFL1brnMlepYrPpO3HbjAPZyaJZi4onb7Trj85kqX7WdX"], encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                if let feed = data as? NSDictionary {
                    if let entries = feed["apps"] as? NSArray {
                        for entry in entries {
                            if let name = entry as? NSDictionary {
                                self.appList.append(App(appInfo: name))
                            }
                        }
                        self.updateUI(0)
                    }
                } else {
                    //we should handle the error
                }
        }

    }
    
    func updateUI(position: Int) {
        let currentApp = appList[position]
        let imageURL = NSURL(string: "http://gabrielecirulli.github.io/2048/meta/og_image.png")
        let imageData = NSData(contentsOfURL: imageURL!)
        appLogo.image = UIImage(data: imageData!)
        appName.text = currentApp.appName
    }
    
    @IBAction func onDislikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_dislike_selected"), forState: UIControlState.Normal)
    }
    
    @IBAction func onLikeButtonClick(sender: UIButton) {
        sender.setImage(UIImage(named: "icon_like_selected"), forState: UIControlState.Normal)
    }
    
    @IBAction func onInfoButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func onNextButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func onPreviousButtonClick(sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
