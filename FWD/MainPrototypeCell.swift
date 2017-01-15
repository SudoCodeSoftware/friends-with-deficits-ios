//
//  PrototypeCell.swift
//  FWD
//
//  Created by Nathan Cohen on 1/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit

class MainPrototypeCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
   
    @IBOutlet weak var debtLabel: UILabel!
    
    @IBOutlet weak var toFriendDetail: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }


}

