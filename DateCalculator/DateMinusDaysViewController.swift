//
//  DateMinusDaysViewController.swift
//  DateCalculator
//
//  Created by WTF on 29/11/2018.
//  Copyright © 2018 RMS2018. All rights reserved.
//
import UIKit
import Foundation


class DateMinusDaysViewController : UIViewController {
 
    @IBOutlet weak var julianCalendarSwitch: UISwitch!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryInputTextBox: UITextField!
    @IBOutlet weak var dateInputTextBox: UITextField!
    @IBOutlet weak var workingDaysInputTextBox: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finalDateInputTextBox: UITextField!
    @IBOutlet weak var missingDaysTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func julianCalendarSwitch_OnClick(_ sender: Any) {
        countryLabel.isEnabled = julianCalendarSwitch.isOn
        countryInputTextBox.isEnabled = julianCalendarSwitch.isOn
    }
}
