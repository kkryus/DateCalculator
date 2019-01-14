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
    var monthsCodes: [Int] = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5]

    @IBOutlet weak var dateInputTextBox: UITextField!
    @IBOutlet weak var workingDaysInputTextBox: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finalDateInputTextBox: UITextField!
    
    @IBOutlet weak var tab: UIButton!
    @IBOutlet weak var tmp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButton_OnClick(_ sender: Any) {
        setDateFormat()
        calculateWorkingDays()
    }
    
    @IBAction func tabOnClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainID") as! UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func calculateWorkingDays() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard var date = dateFormatter.date(from: dateInputTextBox.text!) else {
            return false
        }
        let numberOfWorkingDays = Int(workingDaysInputTextBox.text!)
        if(numberOfWorkingDays != nil){
            addDays(date: &date, extraDays: numberOfWorkingDays!)
        }
        else {
            return false
        }
        
        finalDateInputTextBox.text = String(describing: date)
        return true
    }
    
    private func addDays(date: inout Date, extraDays : Int) {
        let calendar = Calendar.current
        let been = calendar.dateComponents([.year], from: date)
    
        var year = been.year
        var easter = countEasterDate(date: date)
        var counter = 0;
        for i in 1...extraDays {
            let calendar = Calendar.current
            let been = calendar.dateComponents([.year], from: date)
            if (year != been.year) {
                year = been.year
                easter = countEasterDate(date: date)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            if (isHoliday(date: date, easterDate: easter)) {
                counter+=1
            }
            
        }
        //tmp.text = tmp.text! + "|" +  String(describing: counter) + "|"
        //Dodaje dni wolne
        if (counter > 0) {
            //tmp.text = tmp.text! + String(describing: counter) + "|";
            addDays(date: &date, extraDays: counter);
        }
        //Gdy kończy się na dniu wolnym
        while (isHoliday(date: date, easterDate: easter)) {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            //tmp.text = tmp.text! + "t"
            if (year != been.year) {
                year = been.year
                easter = countEasterDate(date: date)
            }
        }
    }

    private func isHoliday(date : Date, easterDate : Date) -> Bool {
        let day = countGregorianDayOfTheWeek(date: date)
        if (day == 1 || day == 7) {
            //tmp.text = tmp.text! + "t"
            return true;
        }
        else {
            //tmp.text = tmp.text! + "f"
        }
        let calendar = Calendar.current
        let been = calendar.dateComponents([.day, .month], from: date)
        var dayInMonth = been.day!
        
        var month = been.month!
        var holidays: [String]
        holidays = ["1/1", "6/1", "1/5", "3/5", "15/8", "1/11", "11/11", "25/12", "26/12"];
        
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

    private func countEasterDate(date: Date) -> Date{
            let calendar = Calendar.current
            let been = calendar.dateComponents([.year], from: date)
            let components = countGregorianEasterDate(year: been.year!)
            return Calendar.current.date(from: components)!
            //easterDateTextBox.text = String(describing: Calendar.current.date(from: components)!)//""
    }
    
    private func countGregorianEasterDate(year: Int) -> DateComponents{
        let a = year % 19
        let b = Int(floor(Double(year) / 100))
        let c = year % 100
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
        components.year = year
        components.month = Int(floor(Double(h + L - 7*m + 114) / 31))
        components.day = ((h + L - 7*m + 114) % 31) + 1
        return components
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
