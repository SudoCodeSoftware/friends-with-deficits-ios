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
        
        let shareData = ShareData.sharedInstance
        shareData.friendIndex = -1
        shareData.editIndex = -1
        
        //Check if a friends list has previously been saved
        if UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") != nil {
            //Set the friends list to that which has been saved
            friendsList = UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") as! [[String]]
            debugPrint(friendsList)
        }

        
        for i in (0..<friendsList.count) {
            var curr:Float
            curr = 0.0
            
            for j in (2..<friendsList[i].count) {
                if friendsList[i][j].components(separatedBy: ";")[1] == "true"{
                    curr += Float(friendsList[i][j].components(separatedBy: ";")[0])!
                    friendsList[i][1] = "$" + String(curr)
                    
                } else {
                    curr += Float(friendsList[i][j].components(separatedBy: ";")[0])!
                    friendsList[i][1] = "-$" + String(curr)
                }
                
            }
        }
        
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
    
    let customGreen = UIColor(red: 89/255, green: 205/255, blue: 144/255, alpha: 1)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        
        
        if friendsList[(indexPath as NSIndexPath).row][2].components(separatedBy: ";")[1] == "true" {
            
            cell.debtLabel.textColor = customGreen
            
        } else {
            
            cell.debtLabel.textColor = UIColor.red // new red: #d65c5c
            
        }
 

        return cell
 
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            friendsList.remove(at: (indexPath as NSIndexPath).row)
            UserDefaults.standard.set(friendsList, forKey: "Friends_With_Defecits_List")
            tableView.reloadData()
            
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

