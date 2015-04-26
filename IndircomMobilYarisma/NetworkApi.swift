//
//  NetworkApi.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 23/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import Alamofire

class NetworkApi: NSObject {
    
    var BASE_URL : String = "http://www.akilliyazilim.org/indircom/indir.com/public"

    
    func registerUser(name : String, surname : String, id : String, email: String, code : String, completionHandler:(request : NSURLRequest?, response : NSHTTPURLResponse?, data : AnyObject?, error : NSError?) -> Void) {
        
        let parameters = [
            "name": name,
            "surname": surname,
            "user_auth_id": id,
            "email": email,
            "api_key" : code
        ]
        
        
        Alamofire.request(.POST, BASE_URL+"/api/v1/register", parameters: parameters, encoding: .JSON
            )
            .responseJSON( completionHandler:{ (request, response, data, error) in
                if error == nil{
                    
                  completionHandler(request: request, response: response, data: data, error: error)
                    
                } else {
                    println("Error | registerUser | : \(error)")
                }
        })
        
        
    }
    
    func getUnratedApps(userID : String, token : String, completionHandler:(request : NSURLRequest?, response : NSHTTPURLResponse?, data : AnyObject?, error : NSError?) -> Void) {
        
        let parameters = [
            "token": token
        ]
        
        
        Alamofire.request(.POST, BASE_URL+"/api/v1/\(userID)/unrated", parameters: parameters, encoding: .JSON)
            .responseJSON( completionHandler:{ (request, response, data, error) in
          
                if error == nil{
                    
                    completionHandler(request: request, response: response, data: data, error: error)
                    
                } else {
                    println("Error | getUnratedApps | : \(error)")
                }
                
        })
        
    }
    
    func sendAppRate(appID : String , rate : String, userID :String, token : String ,completionHandler:(request : NSURLRequest?, response : NSHTTPURLResponse?, data : AnyObject?, error : NSError?) -> Void) {
        
        let parameters = [ "rate" : rate,
                           "token": token
        ]
        
        
        Alamofire.request(.POST, BASE_URL+"/api/v1/\(userID)/rate/\(appID)", parameters: parameters, encoding: .JSON)
            .responseJSON( completionHandler:{ (request, response, data, error) in
                
                if error == nil{
                    
                    completionHandler(request: request, response: response, data: data, error: error)
                    
                } else {
                    println("Error | sendAppRate | : \(error)")
                }
        })
        
    }
    
    

}
