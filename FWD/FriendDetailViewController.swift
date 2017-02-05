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
        
        
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110))
        tableViewFooter.layer.cornerRadius = 8.0
        tableViewFooter.clipsToBounds = true
        tableViewFooter.backgroundColor = UIColor.purple
        
        
        
        let totalCredit = UILabel(frame: CGRect(x: tableView.frame.width/14 , y: 10, width: tableView.frame.width*(2/3), height: 50))
        totalCredit.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalCredit.textColor = UIColor.white
        tableViewFooter.addSubview(totalCredit)
        
        
        
        let totalCreditDescription = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.width*(2/3), height: 20))
        totalCreditDescription.text = "Total Credits"
        totalCreditDescription.textColor = UIColor.white
        totalCreditDescription.textAlignment = .left
        totalCreditDescription.font = UIFont(name: "YEEZYTSTAR-Bold", size: 10)
        tableViewFooter.addSubview(totalCreditDescription)
        
        
        
        let totalDebt = UILabel(frame: CGRect(x: tableView.frame.width/5 , y: 10, width: tableView.frame.width*(1/3), height: 50))
        totalDebt.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalDebt.textColor = UIColor.white
        totalDebt.backgroundColor = UIColor.black
        tableViewFooter.addSubview(totalDebt)
        
        
        let totalDebtDescription = UILabel(frame: CGRect(x: totalDebt.frame.origin.x , y: 0, width: tableView.frame.width*(1/3), height: 20))
        totalDebtDescription.text = "Total Debts"
        totalDebtDescription.textColor = UIColor.white
        totalDebtDescription.font = UIFont(name: "YEEZYTSTAR-Bold", size: 10)
        totalDebtDescription.backgroundColor = UIColor.black
        tableViewFooter.addSubview(totalDebtDescription)
        
        
        
        
        let netStanding  = UILabel(frame: CGRect(x: self.view.center.x , y: 60, width: tableView.frame.width , height: 50))
        netStanding.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        netStanding.textColor = UIColor.white
        netStanding.backgroundColor = UIColor.darkGray
        netStanding.center.x = self.view.center.x
        netStanding.textAlignment = .center
        tableViewFooter.addSubview(netStanding)
        
        let netStandingDescription = UILabel(frame: CGRect(x: 0 , y: 60, width: tableView.frame.width/10, height: 20))
        netStandingDescription.text = "Net Standing"
        netStandingDescription.textColor = UIColor.white
        netStandingDescription.backgroundColor = UIColor.darkGray
        netStandingDescription.textAlignment = .left
        netStandingDescription.font = UIFont(name: "YEEZYTSTAR-Bold", size: 10)
        tableViewFooter.addSubview(netStandingDescription)
        
        
        tableView.tableFooterView  = tableViewFooter

        
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
        
        var totalDebtFloat: Float = 0
        var totalCreditFloat: Float = 0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! DetailPrototypeCell
        
        cell.contentView.backgroundColor = UIColor(red:0.5, green:0.00, blue:0.5, alpha:1.0)
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
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



