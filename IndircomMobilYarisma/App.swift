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
    
    init(appInfo: NSDictionary) {
        self.appID = appInfo["app_id"] as? String
        self.appName = appInfo["app_name"] as? String
        self.appDescription = appInfo["app_description"] as? String
        self.appDownloadURL = appInfo["app_download_url"] as? String
    }
}