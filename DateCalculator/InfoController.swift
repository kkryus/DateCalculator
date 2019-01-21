//
//  InfoController.swift
//  DateCalculator
//
//  Created by WTF on 21/01/2019.
//  Copyright © 2019 RMS2018. All rights reserved.
//
import UIKit
import Foundation

class InfoController: UIViewController {
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var calculatorButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func infoOnClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainID") as! UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func calculatorOnClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DateMinusDays", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "dateMinusDaysViewControllerID") as! UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
