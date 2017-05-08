//
//  LoginViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 22/04/2017.
//  Copyright © 2017 Sudo-Code Software. All rights reserved.
//

import Foundation
import Alamofire


class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var debugText: UILabel!
    

        override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.object(forKey: "accessToken") as! String!)
        // Check if Access Token is still valid
            let parameters: Parameters = [
                "access_token": UserDefaults.standard.object(forKey: "accessToken") as! String!,
                "req_type": "loginCheck"
            ]
            
            Alamofire.request("https://www.sudo-code.tk/cgi-bin/fwd/fwd.cgi", method: .post, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if let data = response.result.value as? [Any] {
                            let statusCode = data[0] as! String
                            let shareData = ShareData.sharedInstance
                            switch statusCode {
                            case "0":
                                shareData.accessToken = UserDefaults.standard.object(forKey: "accessToken") as! String!
                                self.performSegue(withIdentifier: "FromLogin", sender: self)
                            case "1":
                                self.debugText.text = "There is no account registered with this email"
                                debugPrint("There is no account registered with this email")
                            case "2":
                                self.debugText.text = "Incorrect password"
                                debugPrint("Incorrect password")
                            default:
                                print("1")
                            }
                        } else {
                            print("2")
                        }
                        
                    case .failure( _):
                        print("3")
                    }
            }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    @IBAction func login() {
        
        self.debugText.text = ""
        
        let parameters: Parameters = [
            "username": username.text!,
            "password": password.text!,
            "req_type": "login"
        ]
        
        Alamofire.request("https://www.sudo-code.tk/cgi-bin/fwd/fwd.cgi", method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value as? [Any] {
                        let statusCode = data[0] as! String
                        let shareData = ShareData.sharedInstance
                        switch statusCode {
                        case "0":
                            debugPrint(data)
                            let token = data[1] as! String
                            shareData.accessToken = token
                            shareData.username = self.username.text
                            UserDefaults.standard.set(token, forKey: "accessToken")
                            print(token)
                            self.performSegue(withIdentifier: "FromLogin", sender: self)
                        case "1":
                            self.debugText.text = "There is no account registered with this email"
                            debugPrint("There is no account registered with this email")
                        case "2":
                            self.debugText.text = "Incorrect password"
                            debugPrint("Incorrect password")
                        default:
                            print("1")
                        }
                    } else {
                        print("2")
                    }
                    
                case .failure( _):
                    print("3")
                }
        }
        
       
        
    }
    
    @IBAction func signup() {
        
        
        self.debugText.text = ""
        
        let parameters: Parameters = [
            "username": username.text!,
            "password": password.text!,
            "req_type": "signup"
        ]

        
        Alamofire.request("https://www.sudo-code.tk/cgi-bin/fwd/fwd.cgi", method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value as? [Any] {
                        let shareData = ShareData.sharedInstance
                        let statusCode = data[0] as! String
                        switch statusCode {
                        case "0":
                            let token = data[1] as! String
                            shareData.accessToken = token
                            shareData.username = self.username.text
                            print(token)
                            self.performSegue(withIdentifier: "MainView", sender: nil)
                        case "1":
                            debugPrint("There is no account registered with this email")
                        case "2":
                            debugPrint("Incorrect password")
                        default:
                            print("1")
                        }
                    } else {
                        print("2")
                    }
                    
                case .failure( _):
                    print("3")
                }
        }
        
    }
}

