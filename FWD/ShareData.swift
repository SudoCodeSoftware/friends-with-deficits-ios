//
//  ShareData.swift
//  FWD
//
//  Created by Nathan Cohen on 2/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import Foundation
/*
class ShareData {
    private static var __once: () = {
            Static.instance = ShareData()
        }
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: Int = 0
        }
        
        _ = ShareData.__once
        
        return Static.instance!
    }
    
    
    var friendIndex : Int!
    var editIndex : Int!
}
 */

class ShareData {
    static let sharedInstance: ShareData = { ShareData() }()
    
    var friendIndex: Int!
    var editIndex: Int!
    var calcSave: String!
    var accessToken: String!
    var username: String!
    var friendsList = [Any]()
}
