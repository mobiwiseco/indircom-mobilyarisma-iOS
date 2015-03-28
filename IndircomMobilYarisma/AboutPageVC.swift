//
//  AboutPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 28/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class AboutPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
