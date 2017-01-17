//
//  FriendDetailViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 1/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit


class FriendDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func BoolToString(_ b: Bool?)->String { return b?.description ?? "<None>"}
    var friendIndex:Int!
    var friendSummary = [String]()

    
    
    @IBOutlet weak var Back: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var friendName: UILabel!
    
    
    @IBAction func Edit(_ sender: AnyObject) {
        let shareData = ShareData.sharedInstance
        shareData.editIndex = sender.tag;
        performSegue(withIdentifier: "AddDebt", sender: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "4ByUK.png")
        
        Back.setBackgroundImage(backImage, for: UIControlState())
        Back.setTitle("", for: UIControlState())
        
        if UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") != nil {
            friendsList = UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") as! [[String]]
        }
        let shareData = ShareData.sharedInstance
        friendIndex = shareData.friendIndex
        shareData.editIndex = -1
        
        debugPrint(friendIndex)
        
        friendName.text = friendsList[friendIndex][0]
        for i in 0..<(friendsList[friendIndex].count - 2) {
            friendSummary.append(friendsList[friendIndex][i+2])
        }
        self.tableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows that should be instantiated
        return friendSummary.count
    }
    
    let customGreen = UIColor(red: 89/255, green: 205/255, blue: 144/255, alpha: 1)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! DetailPrototypeCell
        
        cell.transactionDebt.text = "$" + friendSummary[(indexPath as NSIndexPath).row].components(separatedBy: ";")[0]
        
        
        if friendSummary[(indexPath as NSIndexPath).row].components(separatedBy: ";")[1] == "true" {
            
            cell.transactionDebt.textColor = customGreen // new green: #59CD90
            
        } else {
            
            cell.transactionDebt.textColor = UIColor.red // new red: #EE6352
            
        }
        
        
        cell.edit.tag = (indexPath as NSIndexPath).row
        
        cell.transactionDescription.text = friendSummary[(indexPath as NSIndexPath).row].components(separatedBy: ";")[2]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if friendsList[friendIndex][(indexPath as NSIndexPath).row + 2].components(separatedBy: ";")[1] == "true" {
                friendsList[friendIndex][1] = "$" + String( Float(friendsList[friendIndex][1].components(separatedBy: "$")[1])! - Float(friendsList[friendIndex][(indexPath as NSIndexPath).row + 2].components(separatedBy: ";")[0])!)
                
            } else {
                friendsList[friendIndex][1] = "$" + String( Float(friendsList[friendIndex][1].components(separatedBy: "$")[1])! + Float(friendsList[friendIndex][(indexPath as NSIndexPath).row + 2].components(separatedBy: ";")[0])!)
                
            }
            
            
            friendsList[friendIndex].remove(at: ((indexPath as NSIndexPath).row + 2))
            friendSummary.remove(at: (indexPath as NSIndexPath).row)
            UserDefaults.standard.set(friendsList, forKey: "Friends_With_Defecits_List")
            tableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            debugPrint(friendSummary[indexPath.row])

    
            return 140
            
        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.backgroundColor = UIColor.white
        
        if selectedRowIndex != -1 {
            tableView.cellForRow(at: (IndexPath(row: self.selectedRowIndex, section: 0)))?.backgroundColor = UIColor.white
        }
        
        if selectedRowIndex != indexPath.row {
            thereIsCellTapped = true
            selectedRowIndex = indexPath.row
        }
        else {
            thereIsCellTapped = false
            selectedRowIndex = -1
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
}



