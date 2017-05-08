//
//  Debt.swift
//  FWD
//
//  Created by Nathan Cohen on 8/05/2017.
//  Copyright © 2017 Sudo-Code Software. All rights reserved.
//

import UIKit

class Debt {
    var debt: Float
    var debtorID: Int
    var debtedID: Int
    var description: String
    var time: String
    
    init(debt: Float, debtorID: Int, debtedID: Int, description: String, time: String) {
        self.debt = debt
        self.debtorID = debtorID
        self.debtedID = debtedID
        self.description = description
        self.time = time
    }

}
