//
//  DetailPrototypeCell.swift
//  FWD
//
//  Created by Nathan Cohen on 3/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit

class DetailPrototypeCell: UITableViewCell {
    
    @IBOutlet weak var transactionDebt: UILabel!
    
    @IBOutlet weak var edit: UIButton!
    
    @IBOutlet weak var transactionDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }


}

