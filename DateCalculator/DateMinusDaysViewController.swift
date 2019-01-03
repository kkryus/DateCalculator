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
    
    var dateFormat: String = "dd.MM.yyyy"
    var country: String = "Poland"
    var calendarType: String = "Gregorian"
 
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
    
    @IBAction func startButton_OnClick(_ sender: Any) {
        setCountry()
        setDateFormat()
        determineCalendar()
        calculateWorkingDays()
    }
    
    private func calculateWorkingDays() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard var date = dateFormatter.date(from: dateInputTextBox.text!) else {
            return false
        }
        let numberOfWorkingDays = Int(workingDaysInputTextBox.text!)
        if(numberOfWorkingDays != nil){
            if(calendarType == "Gregorian"){
                for i in 1...numberOfWorkingDays! + 1 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
            }
            else {
                
            }
        }
        else {
            return false
        }
        
        finalDateInputTextBox.text = String(describing: date)
        //let nextDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)
        return true
    }
    
    private func addDays(date: inout Date, extraDays : Int) {
        let calendar = Calendar.current
        let been = calendar.dateComponents([.year], from: date)
        
        var year = been.year
        var easter = countEasterDate(year: year!);
        var counter = 0;
        for i in 0...extraDays {
            let calendar = Calendar.current
            let been = calendar.dateComponents([.year], from: date)
            if (year != been.year) {
                year = been.year
                easter = countEasterDate(year: year!)
            }
            if (isHoliday(date: date, easterDate: easter)) {
                counter+=1
            }
             date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        //Dodaje dni wolne
        if (counter > 0) {
            addDays(date: &date, extraDays: counter);
        }
        //Gdy kończy się na dniu wolnym
        while (isHoliday(date: date, easterDate: easter)) {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            if (year != been.year) {
                year = been.year
                easter = countEasterDate(year: year!)
            }
        }
    }

    private func isHoliday(date : Date, easterDate : Date) -> Bool {
        let day = countGregorianDayOfTheWeek(date: date)
        if (day == 0 || day == 6) {
            return true;
        }
        let calendar = Calendar.current
        let been = calendar.dateComponents([.day, .month], from: date)
        var dayInMonth = been.day!
        var month = been.month!
        var holidays: [String]
        if(country == "Poland"){
            holidays = ["1/0", "6/0", "1/4", "3/4", "15/7", "1/10", "11/10", "25/11", "26/11"];
        }
        
        if (holidays.index(of: String(describing: dayInMonth) + "/" + String(describing: month)) != nil) {
            return true;
        }
        let easterBeen = calendar.dateComponents([.day, .month], from: easterDate)
        var dayInMonthEaster = easterBeen.day!
        var monthEaster = easterBeen.month!
        //Poniedziałek Wielkanocny
        if (String(describing: dayInMonth) + "/" + String(describing: month) == (String(describing: (dayInMonthEaster + 1)) + "/" + String(describing: monthEaster))) {
            return true;
        }
        //Boże Ciało
        var feastOfCorpusChristiDate = easterDate
        feastOfCorpusChristiDate = Calendar.current.date(byAdding: .day, value: 1, to: feastOfCorpusChristiDate)!
        let feastBeen = calendar.dateComponents([.day, .month], from: feastOfCorpusChristiDate)
        var dayInMonthFeast = feastBeen.day!
        var monthFeast = feastBeen.month!
        if (String(describing: dayInMonth) + "/" + String(describing: month) == ((String(describing: dayInMonthFeast)) + "/" + String(describing: monthFeast))) {
            return true;
        }
        return false;
}
    
    private func countGregorianDayOfTheWeek(date : Date) -> Int{
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        return weekDay
    }

private func countEasterDate(year : Int) -> Date{
    if(calendarType == "Gregorian"){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: dateInputTextBox.text!) else {
            return
        }
        return date
        let components = countGregorianEasterDate(date: date)
        easterDateTextBox.text = String(describing: Calendar.current.date(from: components)!)//""
    }
    else {
        /*let calendar = Calendar.current
        
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
        easterDateTextBox.text = String(describing:easterDate!)
        return true*/
    }
    //return true
}
    
    @IBAction func julianCalendarSwitch_OnClick(_ sender: Any) {
        countryLabel.isEnabled = julianCalendarSwitch.isOn
        countryInputTextBox.isEnabled = julianCalendarSwitch.isOn
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
    }
    
    private func setCalendarAsGregorian(){
        calendarType = "Gregorian"
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
        if(julianCalendarSwitch.isOn){
            country = "Poland"
            countryInputTextBox.text = "Poland"
        }
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
}
