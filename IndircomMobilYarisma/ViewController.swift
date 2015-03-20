//
//  ViewController.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 13/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import TwitterKit
import Alamofire




class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func twitterLogInTapped(sender: AnyObject)
    {
        
        Twitter.sharedInstance().logInWithCompletion {
            (session, error) -> Void in
            if (session != nil) {
                println("signed in as \(session.userName)");
                println("user ID :  \(session.userID)");
                
               // self.alertWithTitle("Twitter", message: "You are logged in")
                
                self.goDetailPage()
                
            } else {
                println("error: \(error.localizedDescription)");
            }
        }
        
    }

    // Facebook Delegate Methods
    
//    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
//        println("User Logged In")
//    }
//    
//    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
//        println("User: \(user)")
//        println("User ID: \(user.objectID)")
//        println("User Name: \(user.name)")
//        
//    }
//    
//    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//         println("User Logged Out")
//    }
//    
//    func loginView(loginView : FBLoginView!, handleError:NSError) {
//        println("Error: \(handleError.localizedDescription)")
//    }

    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginWithFacebook(sender: AnyObject)
    {
     
        if (FBSession.activeSession().state == FBSessionState.Open || FBSession.activeSession().state == FBSessionState.OpenTokenExtended)
        {
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            FBSession.activeSession().closeAndClearTokenInformation()
        }
        else
        {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) in
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                appDelegate.sessionStateChanged(session, state: state, error: error)
                
                
                let request = FBRequest(session: FBSession.activeSession(), graphPath: "/me")
                request.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    println(result)
                   
                })
                
            })
        }
    }
    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        
//        if segue.identifier == "DetailPageVC"
//        {
//            let vc = segue.destinationViewController as DetailPageVC
//            
//        }
//    
//    }
    
    
    func goDetailPage()
    {
        self.performSegueWithIdentifier("DetailPageVC", sender: self)
    }
    
    
    func registerUser()
    {
        Alamofire.request(.POST, "rezervasyon?key=f9a3226fc9fbd886c59a707ed7bd16ed", parameters: nil
            )
            .response {(request, response, _, error) in
                if error == nil{
                   
                } else {
                    
                }
        }
    }
 
    
}

