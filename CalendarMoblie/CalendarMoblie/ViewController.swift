//
//  ViewController.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/20/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var eventTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitle.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTitle.resignFirstResponder()
        return true
    }

    //MARK: Actions
    @IBAction func submitEvent(_ sender: UIButton) {
        if let title = eventTitle.text {
            print("\(title)")
        }else {
            print("None")
        }
    }
    
}


