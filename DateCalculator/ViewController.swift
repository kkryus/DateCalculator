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
    @IBOutlet weak var daysSinceNowTextBox: UITextField!
    @IBOutlet weak var monthsSinceNowTextBox: UITextField!
    @IBOutlet weak var easterDateTextBox: UITextField!
    @IBOutlet weak var dayOfTheWeekTextBox: UITextField!
    @IBOutlet weak var beenYearsTextBox: UITextField!
    @IBOutlet weak var beenMonthsTextBox: UITextField!
    @IBOutlet weak var beenDaysTextBox: UITextField!
    
    @IBOutlet weak var calculateWorkingDaysButton: UIButton!
    
    var dateFormat: String = "dd.MM.yyyy"
    var country: String = "Poland"
    var calendarType: String = "Gregorian"
    var namesOfDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var monthsCodes: [Int] = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startButton_OnTouchUp(_ sender: Any) {
        setDateFormat()
        setCountry()
        if(!determineCalendar()){
            clearView()
            return
        }
        if(!countDaysSinceDate()){
            clearView()
            return
        }
        countDayOfTheWeek()
        countEasterDate()
        
        
        //calendarOutputTextBox.text = dateFormat
       // let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = dateFormat
       // let date = dateFormatter.date(from: dateInputTextBox.text!)
        //calendarOutputTextBox.text = dateFormatter.string(from: date!)
    }
    
    @IBAction func calculateWorkingDaysButton_OnClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DateMinusDays", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "dateMinusDaysViewControllerID") as! UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func determineCalendar() -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateInputTextBox.text!) else {
            return false
        }
        if(country == "Hungary"){
            guard let dateAfterChange = dateFormatter.date(from: "01.11.1587") else {
                return false
            }
            if(date < dateAfterChange){
                calendarType = "Julian"
                calendarOutputTextBox.text = "Julian"
                guard let dateOfChange = dateFormatter.date(from: "21.10.1587") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                }
            }
            else {
                calendarType = "Gregorian"
                calendarOutputTextBox.text = "Gregorian"
            }
            
        }
        else if(country == "Great Britain"){
            guard let dateAfterChange = dateFormatter.date(from: "14.08.1752") else {
                return false
            }
            if(date < dateAfterChange){
                calendarType = "Julian"
                calendarOutputTextBox.text = "Julian"
                guard let dateOfChange = dateFormatter.date(from: "02.08.1752") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                }
            }
            else {
                calendarType = "Gregorian"
                calendarOutputTextBox.text = "Gregorian"
            }
            
        }
        else {
            guard let dateAfterChange = dateFormatter.date(from: "15.10.1582") else {
                return false
            }
            if(date < dateAfterChange){
                calendarType = "Julian"
                calendarOutputTextBox.text = "Julian"
                guard let dateOfChange = dateFormatter.date(from: "04.10.1582") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                }
            }
            else {
                calendarType = "Gregorian"
                calendarOutputTextBox.text = "Gregorian"
            }
            
            
        }
        return true
    }
    
   
    
    private func countEasterDate() -> Bool{
        if(calendarOutputTextBox.text == "Gregorian"){
            easterDateTextBox.text = ""
        }
        else {
            let calendar = Calendar.current
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let date = dateFormatter.date(from: dateInputTextBox.text!)
            
            if(date == nil){
                return false
            }
            let date1 = calendar.startOfDay(for: date!)
            
            let been = calendar.dateComponents([.year], from: date1)
            
            
            let goldenNumber = (been.year! % 19) + 1
            easterDateTextBox.text = String(describing:goldenNumber)
            return true
        }
        return true
    }
    
    private func countDayOfTheWeek() -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateInputTextBox.text!) else {
            return false
        }
        if(calendarType == "Gregorian"){
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            dayOfTheWeekTextBox.text = namesOfDays[weekDay - 1 ]
            return true
        }
        else {
            //https://blog.artofmemory.com/how-to-calculate-the-day-of-the-week-4203.html
            let calendar = Calendar.current
            let been = calendar.dateComponents([.day, .month, .year], from: date)
            
            let yyyyString = String(describing: been.year!)
            let yy = yyyyString.substring(from:yyyyString.index(yyyyString.endIndex, offsetBy: -2))
            let yearCode = ((Int(yy)! / 4) + Int(yy)!) % 7
            
            let monthCode = monthsCodes[been.month! - 1]
            var y1 = ""
            if(been.year! >= 1000){
                y1 = String(yyyyString.characters.prefix(2))//yyyyString.substring(from:yyyyString.index(yyyyString.begIndex, offsetBy: 2))
            }
            else {
                y1 = String(yyyyString.characters.prefix(1))//yyyyString.substring(from:yyyyString.index(yyyyString.endIndex, offsetBy: 1))
            }
            let centuryCode = (18 - Int(y1)!) % 7
            var leapCode = 0
            if(Int(yyyyString)! % 4 == 0 ){
                if(been.month! == 1 || been.month! == 2){
                    leapCode = 1
                }
            }
            let dayCode = (yearCode + monthCode + centuryCode + been.day! - leapCode) % 7
            dayOfTheWeekTextBox.text = namesOfDays[dayCode]
            return true
        }
    }
    
    private func countDaysSinceDate() -> Bool{
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateInputTextBox.text!)
        
        if(date == nil){
            return false
        }
        
        let date1 = calendar.startOfDay(for: date!)
        let date2 = calendar.startOfDay(for: Date())
        
        let been = calendar.dateComponents([.day, .month, .year], from: date1, to: date2)
        beenDaysTextBox.text = String(describing: been.day!)
        beenMonthsTextBox.text = String(describing: been.month!)
        beenYearsTextBox.text = String(describing: been.year!)
        
        let sinceDays = calendar.dateComponents([.day], from: date1, to: date2)
        daysSinceNowTextBox.text = String(describing: sinceDays.day!)
        
        let sinceMonths = calendar.dateComponents([.month], from: date1, to: date2)
        monthsSinceNowTextBox.text = String(describing: sinceMonths.month!)
        return true
    }
    
    private func setDateFormat(){
        if dateInputTextBox.text!.range(of:"/") != nil{
            dateFormat = "dd/MM/yyyy"
            return
        }
        else if dateInputTextBox.text!.range(of:"-") != nil {
            dateFormat = "dd-MM-yyyy"
            return
        }
        dateFormat = "dd.MM.yyyy"
    }
    
    private func setCountry(){
        if countryInputTextBox.text!.range(of:"Hungary") != nil {
            country = "Hungary"
            return
        }
        else if countryInputTextBox.text!.range(of:"Spain") != nil{
            country = "Spain"
            return
        }
        else if countryInputTextBox.text!.range(of:"Great Britain") != nil {
            country = "Great Britain"
            return
        }
        country = "Poland"
        countryInputTextBox.text = "Poland"
    }
    
    private func clearView(){
        calendarOutputTextBox.text = ""
        daysSinceNowTextBox.text = ""
        monthsSinceNowTextBox.text = ""
        easterDateTextBox.text = ""
        dayOfTheWeekTextBox.text = ""
        beenYearsTextBox.text = ""
        beenMonthsTextBox.text = ""
        beenDaysTextBox.text = ""
    }
    
}

