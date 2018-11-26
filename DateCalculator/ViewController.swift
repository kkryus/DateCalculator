//
//  ViewController.swift
//  DateCalculator
//
//  Created by RMS2018 on 25.10.2018.
//  Copyright © 2018 RMS2018. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var dateInputTextBox: UITextField!
    @IBOutlet weak var countryInputTextBox: UITextField!
    @IBOutlet weak var calendarOutputTextBox: UITextField!
    
    var dateFormat: String = "dd.mm.yyyy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startButton_OnTouchUp(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateInputTextBox.text!)
        calendarOutputTextBox.text = dateFormat//dateFormatter.string(from: date!)//inputDateTextBox.text

        
    }
    @IBAction func dateInput_OnValueChanged(_ sender: Any) {
        if dateInputTextBox.text!.range(of:".") != nil {
            calendarOutputTextBox.text = "kropka"
            dateFormat = "dd.mm.yyyy"
        }
        else if dateInputTextBox.text!.range(of:"/") != nil{
            calendarOutputTextBox.text = "2"
            dateFormat = "dd/mm/yyyy"
        }
        else if dateInputTextBox.text!.range(of:"-") != nil {
            calendarOutputTextBox.text = "3"
            dateFormat = "dd-mm-yyyy"
        }
        calendarOutputTextBox.text = "4"
        /*if dateInputTextBox.text!.range(of:".") != nil {
            dateFormat = "dd.mm.yyyy"
        }
        else if dateInputTextBox.text!.range(of:"/") != nil{
            dateFormat = "dd/mm/yyyy"
        }
        else if dateInputTextBox.text!.range(of:"-") != nil {
            dateFormat = "dd-mm-yyyy"
        }*/
    }
    @IBAction func dateInput_OnEditingEnd(_ sender: Any) {
        /*if dateInputTextBox.text!.range(of:".") != nil {
            dateFormat = "dd.mm.yyyy"
        }
        else if dateInputTextBox.text!.range(of:"/") != nil{
            dateFormat = "dd/mm/yyyy"
        }
        else if dateInputTextBox.text!.range(of:"-") != nil {
            dateFormat = "dd-mm-yyyy"
        }*/
    }
}

