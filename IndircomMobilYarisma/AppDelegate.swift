//
//  AppDelegate.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 13/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FBLoginView.self
        FBProfilePictureView.self
        
        Fabric.with([Twitter()])
        
        
        // Whenever a person opens app, check for a cached session
        if (FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {
            
            // If there's one, just open the session silently, without showing the user the login UI
            FBSession.openActiveSessionWithReadPermissions(["public_profile","email"] , allowLoginUI: true, completionHandler: { (session : FBSession!, state : FBSessionState!, error : NSError!) -> Void in
                
                self.sessionStateChanged(session, state: state, error: error)
                
                //[appDelegate sessionStateChanged:session state:state error:error];
                
            })
        }
        
         return true
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool
    {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    
        return true
    }
   

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
    
    func openActiveSessionWithPermissions(permissions : [String] , allowLoginUI : Bool)
    {
        FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI: allowLoginUI) { (session : FBSession!, status : FBSessionState!, error : NSError!) -> Void in
            
            var sessionStateInfo = [session : "session", status :"status" , error : "error", nil]
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("SessionStateChangeNotification", object: nil, userInfo: nil)
        }
    }
        */
    
    func sessionStateChanged(session:FBSession, state:FBSessionState, error:NSError?){
        if ((error) != nil){
            NSLog("Error")
            FBSession.activeSession().closeAndClearTokenInformation()
        }
        else{
            if (state == FBSessionState.Open){
                //I would like to get the user token or FBGraphUser here but i don't know how
            }
            
        }
        if (state == FBSessionState.Closed || state == FBSessionState.ClosedLoginFailed){
            NSLog("Session Clossed")
        }
        if (FBErrorUtility.shouldNotifyUserForError(error) == true){
            NSLog("Something went wrong")
        }
        else{
            if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled){
                NSLog("User cancelled login")
            }
            else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession){
                NSLog("Current session is no valid")
            }
        }
    }
}

