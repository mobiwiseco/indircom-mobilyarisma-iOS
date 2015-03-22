//
//  User.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 20/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var name : String = ""
    var surname :String = ""
    var id : String = ""
    var code : String = ""
    var token : String = ""
    var image : String = ""
    
    override init()
    {
        code = "x2AbXnciUE3lb8aHpMWnwpqT2EIuO8l1og5xsp1MXBhKG03aHK5jDVJxfoBj"
    }
    
    init( user_name : String , user_surname : String , user_id : String)
    {
        self.name = user_name
        self.surname = user_surname
        self.id = user_id
        code = "x2AbXnciUE3lb8aHpMWnwpqT2EIuO8l1og5xsp1MXBhKG03aHK5jDVJxfoBj"
    }
    
    
}
