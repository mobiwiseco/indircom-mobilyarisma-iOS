//
//  App.swift
//  IndircomMobilYarisma
//
//  Created by Kaan Mamikoğlu on 22/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import Foundation

class App {
    var appID: String?
    var appName: String?
    var appDescription: String?
    var appDownloadURL: String?
    var appImageURL: String?
    
    init(appInfo: NSDictionary) {
        self.appID = appInfo["app_id"] as? String
        self.appName = appInfo["app_name"] as? String
        self.appDescription = appInfo["app_description"] as? String
        self.appDownloadURL = appInfo["app_ios_download_url"] as? String
        self.appImageURL = appInfo["app_image_url"] as? String
    }
}