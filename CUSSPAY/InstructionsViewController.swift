//
//  InstructionsViewController.swift
//  CUSSPAY
//
//  Created by Darpan Tanna on 9/18/16.
//  Copyright © 2016 BigRedHacks#3. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    // Update balance
    var numberOfCurses:Int = 0
    var oldBalance:Int = 100
    var newBalance:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update the balance of credits
    func updateBalance() {
        // Number of curses from Audio
        numberOfCurses = 0
        // Subtract
        oldBalance = Int(balanceLabel.text!)!
        newBalance = String(oldBalance - numberOfCurses)
        // Update balanceLabel
        balanceLabel.text = newBalance
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
