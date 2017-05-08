//
//  Friend.swift
//  FWD
//
//  Created by Nathan Cohen on 8/05/2017.
//  Copyright © 2017 Sudo-Code Software. All rights reserved.
//

import UIKit


class Friend {
    var userID: Float
    var debts: NSArray
    var totalDebt: Float
    init(userID: Float, debts: NSArray, totalDebt: Float) {
        self.userID = userID
        self.debts = debts
        self.totalDebt = totalDebt
    }
    
}
