//
//  MainViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 1/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit

var friendsList = [[String]]()
var filteredFriends = [String]()


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalLabel: UIToolbar!
    
    
    //Initialises the search button/controller/bar
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var friendSearch: UIBarButtonItem!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ToFriendDetail") {
            let shareData = ShareData.sharedInstance
            shareData.friendIndex = (sender as AnyObject).tag
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Stuff For the Footer
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        tableViewFooter.layer.cornerRadius = 8.0
        tableViewFooter.clipsToBounds = true
        tableViewFooter.backgroundColor = UIColor.purple
        let totalCredit = UILabel(frame: CGRect(x: tableView.frame.width/14 , y: 0, width: tableView.frame.width*(2/3), height: 50))
        let totalDebt = UILabel(frame: CGRect(x: tableView.frame.width/5 , y: 0, width: tableView.frame.width*(1/3), height: 50))
        totalDebt.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalDebt.textColor = UIColor.white
        totalDebt.backgroundColor = UIColor.black
        tableViewFooter.addSubview(totalDebt)
        totalCredit.font = UIFont(name: "YEEZYTSTAR-Bold", size: 30)
        totalCredit.textColor = UIColor.white
        tableViewFooter.addSubview(totalCredit)
        
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
        totalDebt.text = "     -$" + String(totalDebtFloat)
        /*
        if totalDebtFloat >= 0 {
            let customGreen = UIColor(red: 89/255, green: 205/255, blue: 144/255, alpha: 1)
            totalDebt.textColor = customGreen
            totalDebt.text = "$" + String(totalDebtFloat)
        } else if totalDebtFloat < 0 {
            totalDebt.text = "-$" + String(-1*totalDebtFloat)
            totalDebt.textColor = UIColor.red
        }
        */
        
        
        self.tableView.delegate = self
        
        //Search Bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        var friendsOnly = [String]()
        for i in 0..<friendsList.count {
            friendsOnly.append(friendsList[i][0])
        }
        let predicate = NSPredicate(format: "SELF contains %@", searchText)
        filteredFriends = friendsOnly.filter { predicate.evaluate(with: $0)}
        tableView.reloadData()
    }

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

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
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


