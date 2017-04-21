//
//  MainViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 1/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit
import Alamofire


var friendsList = [[String]]()
var filteredFriends = [String]()



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //Initialises the search button/controller/bar
    let searchController = UISearchController(searchResultsController: nil)
    
    //@IBOutlet weak var friendSearch: UIBarButtonItem!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ToFriendDetail") {
            let shareData = ShareData.sharedInstance
            shareData.friendIndex = (sender as AnyObject).tag
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Stuff For the Footer
        
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110))
        tableViewFooter.layer.cornerRadius = 8.0
        tableViewFooter.clipsToBounds = true
        tableViewFooter.backgroundColor = UIColor.purple
        
        
        
        let totalCredit = UILabel(frame: CGRect(x: tableView.frame.width/30 , y: 10, width: tableView.frame.width*(1/2), height: 50))
        totalCredit.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalCredit.textColor = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        tableViewFooter.addSubview(totalCredit)
        
        
        
        let totalCreditDescription = UILabel(frame: CGRect(x: 0 , y: 0, width: tableView.frame.width*(2/3), height: 20))
        totalCreditDescription.text = "Total Credits"
        totalCreditDescription.textColor = UIColor.white
        totalCreditDescription.textAlignment = .left
        totalCreditDescription.font = UIFont(name: "YEEZYTSTAR-Bold", size: 10)
        tableViewFooter.addSubview(totalCreditDescription)
        
        
        
        let totalDebt = UILabel(frame: CGRect(x: self.view.center.x , y: 10, width: tableView.frame.width, height: 50))
        totalDebt.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalDebt.textColor = UIColor.white
        totalDebt.backgroundColor = UIColor.black
        tableViewFooter.addSubview(totalDebt)
        
        
        let totalDebtDescription = UILabel(frame: CGRect(x: self.view.center.x , y: 0, width: tableView.frame.width, height: 20))
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
        
        let netStandingDescription = UILabel(frame: CGRect(x: 0 , y: 60, width: tableView.frame.width/12, height: 20))
        netStandingDescription.text = "Net Standing"
        netStandingDescription.textColor = UIColor.white
        netStandingDescription.backgroundColor = UIColor.darkGray
        netStandingDescription.textAlignment = .left
        netStandingDescription.font = UIFont(name: "YEEZYTSTAR-Bold", size: 10)
        tableViewFooter.addSubview(netStandingDescription)

        
        tableView.tableFooterView  = tableViewFooter
        
        
        let shareData = ShareData.sharedInstance
        shareData.friendIndex = -1
        shareData.editIndex = -1
        
        //Check if a friends list has previously been saved
        if UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") != nil {
            //Set the friends list to that which has been saved
            friendsList = UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") as! [[String]]
            debugPrint(friendsList)
        }
        var totalDebtFloat: Float = 0
        var totalCreditFloat: Float = 0
        for i in (0..<friendsList.count) {
            var curr:Float
            curr = 0
            
            for j in (2..<friendsList[i].count) {
                if friendsList[i][j].components(separatedBy: ";")[1] == "true"{
                    curr += Float(friendsList[i][j].components(separatedBy: ";")[0])!
                } else {
                    curr -= Float(friendsList[i][j].components(separatedBy: ";")[0])!
                }
            }
            if curr >= 0 {
                friendsList[i][1] = "$" + String(curr)
                totalCreditFloat += curr
                
            } else if curr < 0 {
                friendsList[i][1] = "-$" + String(-1*curr)
                totalDebtFloat -= curr
            }
        
        }
        
        totalCredit.text = "$" + String(totalCreditFloat)
        totalDebt.text = "    -$" + String(totalDebtFloat)
        
        var netStandingFloat: Float = 0
        netStandingFloat = totalCreditFloat - totalDebtFloat
        
        if netStandingFloat >= 0 {
            netStanding.text = "$" + String(netStandingFloat)
            
        } else if netStandingFloat < 0 {
            netStanding.text = "-$" + String(-1*netStandingFloat)
        }

        
        self.tableView.delegate = self
        
        /*Search Bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
         */
    }
    /*
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        var friendsOnly = [String]()
        for i in 0..<friendsList.count {
            friendsOnly.append(friendsList[i][0].lowercased())
        }
        let predicate = NSPredicate(format: "SELF contains %@", searchText)
        filteredFriends = friendsOnly.filter { predicate.evaluate(with: $0)}
        tableView.reloadData()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    //Stuff For Main Friend Table
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows that should be instantiated
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredFriends.count
        }
        return friendsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let customGreen = UIColor(red: 89/255, green: 205/255, blue: 144/255, alpha: 1)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! MainPrototypeCell
        
        cell.contentView.backgroundColor = UIColor(red:0.51, green:0.30, blue:0.62, alpha:1.0)
    
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 70))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

        if searchController.isActive && searchController.searchBar.text != "" {
            cell.friendName.text = filteredFriends[(indexPath as NSIndexPath).row]
        }
        else {
            
            cell.friendName.text = friendsList[(indexPath as NSIndexPath).row][0]
            cell.debtLabel.tag = (indexPath as NSIndexPath).row
            cell.tag = (indexPath as NSIndexPath).row
            cell.debtLabel.text = friendsList[(indexPath as NSIndexPath).row][1]
            
        }
        
        let netValue = friendsList[(indexPath as NSIndexPath).row][1]
        if netValue == "$0" || netValue == "$0.0" {
            cell.debtLabel.textColor = UIColor.black
        } else if  netValue[0] == "-" {
            cell.debtLabel.textColor = UIColor.red // new red: #d65c5c
            
        } else {
            cell.debtLabel.textColor = customGreen
        
            
        }
    return cell
 
    }
    
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            friendsList.remove(at: (indexPath as NSIndexPath).row)
            UserDefaults.standard.set(friendsList, forKey: "Friends_With_Defecits_List")
            tableView.reloadData()
            viewDidLoad()
        }
    }
    
    //Reloads the table everytime the view apears
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}
/*
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
 */

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}


