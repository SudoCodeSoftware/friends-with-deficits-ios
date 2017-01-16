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
    
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            return 140
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRow(at: indexPath as IndexPath)?.backgroundColor = UIColor.gray
        
        // avoid paint the cell is the index is outside the bounds
        if self.selectedRowIndex != -1 {
            tableView.cellForRowAtIndexPath(IndexPath(forRow: self.selectedRowIndex, inSection: 0))?.backgroundColor = UIColor.white
        }
        
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
        }
        else {
            // there is no cell selected anymore
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}

