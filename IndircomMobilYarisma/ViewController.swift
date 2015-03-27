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
    
    var user : User = User()
    
    
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var contentView = HUDContentView.ProgressView()
        HUDController.sharedController.contentView = contentView
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func twitterLogInTapped(sender: AnyObject)
    {

        if IJReachability.isConnectedToNetwork(){
            Twitter.sharedInstance().logInWithCompletion {
                (session, error) -> Void in
                if (session != nil) {
                    println("signed in as \(session.userName)");
                    println("user ID :  \(session.userID)");
                    println("Session : \(session)")
                    
                    
                    HUDController.sharedController.show()
                    Twitter.sharedInstance().APIClient.loadUserWithID(session.userID, completion: { (user : TWTRUser!, error :NSError!) -> Void in
                        
                        println("USER info TWITTER : \(user.profileImageLargeURL)")
                        
                        
                        var fullNameArr = split(user.name) {$0 == " "}
                        var firstName: String = fullNameArr[0]
                        var lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
                        
                        self.user.name = firstName
                        self.user.surname = lastName!
                        self.user.id = session.userID
                        self.user.image = user.profileImageLargeURL
                        
                        self.registerUser(self.user.name, surname: self.user.surname, id: self.user.id, code: self.user.code)
                        
                    })
                    
                } else {
                    println("error: \(error.localizedDescription)");
                    HUDController.sharedController.hide(animated: true)
                }
            }

        }
        else{
            self.alertWithTitle("Bağlantı Hatası", message: "Lütfen internet bağlantınızı kontrol ediniz")
        }
        
    }
    
    @IBAction func loginWithFacebook(sender: AnyObject)
    {
      if IJReachability.isConnectedToNetwork()
        {
            if (FBSession.activeSession().state == FBSessionState.Open || FBSession.activeSession().state == FBSessionState.OpenTokenExtended)
            {
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                FBSession.activeSession().closeAndClearTokenInformation()
                facebookLabel.text! = "Facebook ile giriş"
                
                
            }
            else
            {
                
                HUDController.sharedController.show()

                // Open a session showing the user the login UI
                // You must ALWAYS ask for public_profile permissions when opening a session
                FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: {
                    (session:FBSession!, state:FBSessionState, error:NSError!) in
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                    appDelegate.sessionStateChanged(session, state: state, error: error)
                    
                    if(FBSession.activeSession().state == FBSessionState.Open){
                        
                        
                        /* Session açıldıktan sonra */
                        let request = FBRequest(session: FBSession.activeSession(), graphPath: "/me")
                        request.startWithCompletionHandler({ (connection, result, error) -> Void in
                            
                            self.user.name = result["first_name"] as String
                            self.user.surname = result["last_name"] as String
                            self.user.id = result["id"] as String
                            
                            
                            //Facebook ile giriş yaptıktan sonra servise post edip kaydı gerçekleştiriyorz
//                            self.registerUser(self.user.name, surname: self.user.surname, id: self.user.id, code: self.user.code)
                            
                            self.registerUser(self.user.name, surname: self.user.surname, id: self.user.id, code: self.user.code)
                            
                        })
                    }
                    
                })
            }
        }
        else
        {
            self.alertWithTitle("Bağlantı Hatası", message: "Lütfen internet bağlantınızı kontrol ediniz")
            HUDController.sharedController.hide(animated: true)

        }
        
        
    }
    
    func goDetailPage()
    {
        self.performSegueWithIdentifier("DetailPageVC", sender: self)
    }
    
   
    
    /* Request atılıp veri alındıktan sonra user objemize kayıt edip onu da userdefault'a kaydediyoruz*/
    func saveDefaults(userObj : User)
    {
        Defaults["name"] = userObj.name
        Defaults["surname"] = userObj.surname
        Defaults["id"] = userObj.id
        Defaults["token"] = userObj.token
    }
    
    /* Servis methodları */
    /* ###################################################### */
    
    func registerUser(name : String , surname : String , id : String , code : String)
    {
        let network = NetworkApi()
        network.registerUser(name, surname: surname, id: id, code: code) { (request, response, data, error) -> Void in
            
            if error == nil{
                
                print(" \nError : \(error) \n")
                
                if let json = data as? NSDictionary {
                    if let info = json["user"] as? NSArray
                    {
                        let dic : NSDictionary = info[0] as NSDictionary
                        self.user.token = dic["token"] as String
                        
                        println("info : \(info)")
                    }
                    
                    var message = json["message"]? as String
                    println("message : \(message)")
                }
                
                println("TOKEN : \(self.user.token) \n")
                
                self.saveDefaults(self.user)
                
                HUDController.sharedController.hide(animated: true)
                self.goDetailPage()
                
            } else {
                self.alertWithTitle("Hata", message: "Giriş yapılırken bir hata ile karşılaşıldı !")
            }
            
        }
    }
    
    /* ###################################################### */
    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

