//
//  MainTableViewController.swift
//  Experiments-CoreML
//
//  Created by Andrew Ashurov on 11/19/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    @IBAction func customModelSwitch(_ sender: UISwitch) {
        ImageNNetHelper.useCustomModel = sender.isOn
    }
    
}
