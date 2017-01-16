//
//  AddFriendViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 1/03/2016.
//  Copyright © 2016 Sudo-Code Software. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newFriendName: UITextField!
    
    @IBAction func additem(_ sender: AnyObject){
        if newFriendName.text != ""{
            let currFriend = [newFriendName.text!.lowercased(), "$0"]
            friendsList.append(currFriend)
            newFriendName.text = ""
            UserDefaults.standard.set(friendsList, forKey: "Friends_With_Defecits_List")

            performSegue(withIdentifier: "ToMain", sender: nil)
        } else {
            let alert = UIAlertView()
            alert.title = "No Text"
            alert.message = "Please Enter Friend's Name"
            alert.addButton(withTitle: "Ok")
            alert.show()
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newFriendName.delegate = self
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newFriendName.resignFirstResponder()
        
        return true
    }
    
}
