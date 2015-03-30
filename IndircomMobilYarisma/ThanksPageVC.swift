//
//  ThanksPageVC.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 30/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class ThanksPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        
      //  self.dismissViewControllerAnimated(true, completion: nil)
        
//        let firstPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as ViewController
//        self.navigationController?.pushViewController(firstPage, animated: false)
        
        exit(0)
        
    }

}

