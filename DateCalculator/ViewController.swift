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
    
    //@IBOutlet weak var tmp: UIButton!
    @IBOutlet weak var calculateWorkingDaysButton: UIButton!
    
    var dateFormat: String = "dd.MM.yyyy"
    var country: String = "Poland"
    var calendarType: String = "Gregorian"
    var namesOfDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var julianEasterDates: [String] = ["5.04", "25.03", "13.04", "2.04", "22.03", "10.04", "30.03", "18.04", "7.04", "27.03", "15.04", "4.04", "24.03", "12.04", "1.04", "21.03", "9.04", "29.03", "17.04"]
    var dayOfTheWeekNumber: Int = -1
    var monthsCodes: [Int] = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startButton_OnTouchUp(_ sender: Any) {
       // resignFirstResponder()
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
                setCalendarAsJulian()
                guard let dateOfChange = dateFormatter.date(from: "21.10.1587") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                     setCalendarAsGregorian()
                }
            }
            else {
                setCalendarAsGregorian()
            }
        }
        else if(country == "Great Britain"){
            guard let dateAfterChange = dateFormatter.date(from: "14.08.1752") else {
                return false
            }
            if(date < dateAfterChange){
                setCalendarAsJulian()
                guard let dateOfChange = dateFormatter.date(from: "02.08.1752") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                     setCalendarAsGregorian()
                }
            }
            else {
                setCalendarAsGregorian()
            }
            
        }
        else {
            guard let dateAfterChange = dateFormatter.date(from: "15.10.1582") else {
                return false
            }
            if(date < dateAfterChange){
                setCalendarAsJulian()
                guard let dateOfChange = dateFormatter.date(from: "04.10.1582") else {
                    return false
                }
                if(date > dateOfChange){
                    dateInputTextBox.text = dateFormatter.string(from: dateAfterChange)
                    setCalendarAsGregorian()
                }
            }
            else {
                setCalendarAsGregorian()
            }
        }
        return true
    }
    
    private func setCalendarAsJulian(){
        calendarType = "Julian"
        calendarOutputTextBox.text = "Julian"
    }
    
    private func setCalendarAsGregorian(){
        calendarType = "Gregorian"
        calendarOutputTextBox.text = "Gregorian"
    }
   
    
    private func countEasterDate() -> Bool{
        if(calendarOutputTextBox.text == "Gregorian"){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            guard let date = dateFormatter.date(from: dateInputTextBox.text!) else {
                return false
            }
            let components = countGregorianEasterDate(date: date)
            let calendar = Calendar(identifier: .gregorian)
            let easterDate = calendar.date(from: components)!
            easterDateTextBox.text = dateFormatter.string(from: easterDate)
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
            
            let goldenNumber = (been.year! % 19)
            let dateBeforeEaster = julianEasterDates[goldenNumber]
            let fullDateBeforeEaster = dateFormatter.date(from: dateBeforeEaster + "." + String(describing:been.year!))
            let julianDayOfTheWeekCode = countJulianDayOfTheWeek(date: fullDateBeforeEaster!)
            let easterDate = Calendar.current.date(byAdding: .day, value: 7 - julianDayOfTheWeekCode, to: fullDateBeforeEaster!)
            easterDateTextBox.text = dateFormatter.string(from: easterDate!)
            //easterDateTextBox.text = String(describing:easterDate!)
            return true
        }
        return true
    }
    
    private func countGregorianEasterDate(date: Date) -> DateComponents{
        let calendar = Calendar.current
        let been = calendar.dateComponents([.year], from: date)
        let a = been.year! % 19
        let b = Int(floor(Double(been.year!) / 100))
        let c = been.year! % 100
        let d = Int(floor(Double(b) / 4))
        let e = b % 4
        let f = Int(floor(Double(b+8) / 25))
        let g = Int(floor(Double(b-f+1) / 3))
        let h = (19*a + b - d - g + 15) % 30
        let i = Int(floor(Double(c) / 4))
        let k = c % 4
        let L = (32 + 2*e + 2*i - h - k) % 7
        let m = Int(floor(Double(a + 11*h + 22*L) / 451))
        var components = DateComponents()
        components.year = been.year!
        components.month = Int(floor(Double(h + L - 7*m + 114) / 31))
        components.day = ((h + L - 7*m + 114) % 31) + 1
        return components
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
            let dayCode = countJulianDayOfTheWeek(date: date)
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
        beenDaysTextBox.text = String(describing: abs(been.day!))
        beenMonthsTextBox.text = String(describing: abs(been.month!))
        beenYearsTextBox.text = String(describing: abs(been.year!))
        
        let sinceDays = calendar.dateComponents([.day], from: date1, to: date2)
        daysSinceNowTextBox.text = String(describing: abs(sinceDays.day!))
        
        let sinceMonths = calendar.dateComponents([.month], from: date1, to: date2)
        monthsSinceNowTextBox.text = String(describing: abs(sinceMonths.month!))
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
    
    private func countJulianDayOfTheWeek(date: Date) -> Int {
        //https://blog.artofmemory.com/how-to-calculate-the-day-of-the-week-4203.html
        let calendar = Calendar.current
        let been = calendar.dateComponents([.day, .month, .year], from: date)
        
        let yyyyString = String(describing: been.year!)
        let yy = yyyyString.substring(from:yyyyString.index(yyyyString.endIndex, offsetBy: -2))
        let yearCode = ((Int(yy)! / 4) + Int(yy)!) % 7
        
        let monthCode = monthsCodes[been.month! - 1]
        var y1 = ""
        if(been.year! >= 1000){
            y1 = String(yyyyString.characters.prefix(2))
        }
        else {
            y1 = String(yyyyString.characters.prefix(1))
        }
        let centuryCode = (18 - Int(y1)!) % 7
        var leapCode = 0
        if(Int(yyyyString)! % 4 == 0 ){
            if(been.month! == 1 || been.month! == 2){
                leapCode = 1
            }
        }
        let dayCode = (yearCode + monthCode + centuryCode + been.day! - leapCode) % 7
        return dayCode
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

