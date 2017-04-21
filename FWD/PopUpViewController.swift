//
//  PopUpViewController.swift
//  FWD
//
//  Created by Nathan Cohen on 22/04/2017.
//  Copyright © 2017 Sudo-Code Software. All rights reserved.
//

import Foundation

import UIKit

class PopUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    var firstNumberText = ""
    var secondNumberText = ""
    var op = ""
    var isFirstNumber = true
    var hasOp = false
    var canClear = true
    
    
    @IBAction func handleButtonPress(sender: UIButton) {
        let currentText = resultLabel.text!
        let textLabel = sender.titleLabel?.text
        if textLabel == "Copy" {
            let shareData = ShareData.sharedInstance
            shareData.calcSave = currentText;
            UIPasteboard.general.string = currentText
        }
        else {
            if canClear {
                resultLabel.text = ""
                canClear = false
            }
            if let text = textLabel {
                switch text {
                case "+", "*", "/", "-":
                    if hasOp {
                        return
                    }
                    op = text
                    isFirstNumber = false
                    hasOp = true
                    resultLabel.text = "\(currentText) \(op) "
                    break
                case "=":
                    isFirstNumber = true
                    hasOp = false
                    canClear = true
                    let result = calculate()
                    resultLabel.text = "\(result)"
                    break
                default:
                    if isFirstNumber {
                        firstNumberText = "\(firstNumberText)\(text)"
                    } else {
                        secondNumberText = "\(secondNumberText)\(text)"
                    }
                    resultLabel.text = "\(currentText)\(text)"
                    break;
                }
            }
        }
    }
    
    func calculate() -> Double {
        let firstNumber = Double(firstNumberText)!
        let secondNumber = Double(secondNumberText)!
        firstNumberText = ""
        secondNumberText = ""
        switch op {
        case "+":
            return firstNumber + secondNumber
        case "-":
            return firstNumber - secondNumber
        case "*":
            return firstNumber * secondNumber
        case "/":
            return firstNumber / secondNumber
        default:
            return 0
        }
    }
    
}
