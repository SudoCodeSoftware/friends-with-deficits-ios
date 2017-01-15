//
//  AddDebtViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 3/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit


class AddDebtViewController: UIViewController {


    func BoolToString(_ b: Bool?)->String { return b?.description ?? "<None>"}
    
    
    var friendIndex:Int!
    var editIndex:Int!
    
    
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var debtText: UITextField!
    
    @IBOutlet weak var NegorPos: UISwitch!
    
    @IBOutlet weak var Description: UITextField!
    
    
    
    @IBAction func additem(_ sender: AnyObject){
        if debtText.text != "" && Description.text != ""{
            var summary:String = ""
            summary = debtText.text!
            summary += ";" as String!
            summary += BoolToString(NegorPos.isOn)
            summary += ";" as String!
            summary += Description.text!
            summary += ";" as String!
            let first = Float(friendsList[friendIndex][1].components(separatedBy: "$")[1].components(separatedBy: ";")[0])
            let second = Float(debtText.text!)
            var result = 0
            if NegorPos.isOn {
                result = Int(Float(first! + second!))
            } else {
                result = Int(Float(first! - second!))
            }
            friendsList[friendIndex][1] = ("$"+String(result))
            if editIndex != -1 {
                friendsList[friendIndex][editIndex + 2] = summary
                
            } else {
                friendsList[friendIndex].append(summary)
            }
            debugPrint(friendsList)
            UserDefaults.standard.set(friendsList, forKey: "Friends_With_Defecits_List")

            performSegue(withIdentifier: "BackToDetail", sender: nil)
        } else {
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter Debt and a Description"
                alert.addButton(withTitle: "Ok")
                alert.show()
            
            }
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NegorPos.onTintColor = UIColor.green
        
        NegorPos.tintColor = UIColor.red
        
        
        if UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") != nil {
            friendsList = UserDefaults.standard.object(forKey: "Friends_With_Defecits_List") as! [[String]]
        }
        let shareData = ShareData.sharedInstance
        friendIndex = shareData.friendIndex
        editIndex = shareData.editIndex
        
        friendName.text = friendsList[friendIndex][0]
       
        if editIndex != -1 {
            debtText.text = friendsList[friendIndex][editIndex + 2].components(separatedBy: ";")[0]
            Description.text = friendsList[friendIndex][editIndex + 2].components(separatedBy: ";")[2]
            debugPrint(editIndex)
            if friendsList[friendIndex][editIndex + 2].components(separatedBy: ";")[1] == "true" {
                NegorPos.setOn(true, animated: true)
            }
            else {
                NegorPos.setOn(false, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debtText.resignFirstResponder()
        Description.resignFirstResponder()
        
        return true
    }


}
