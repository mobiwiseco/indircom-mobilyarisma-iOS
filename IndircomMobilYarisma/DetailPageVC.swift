//
//  DetailPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 20/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class DetailPageVC: UIViewController {

    @IBOutlet var appName: UILabel!
    @IBOutlet var appCategory: UILabel!
    @IBOutlet var appLogo: UIImageView!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
