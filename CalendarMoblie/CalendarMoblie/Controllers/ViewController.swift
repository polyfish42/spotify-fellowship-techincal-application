//
//  ViewController.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/20/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Model
    var calEvent = CalendarEvent(title: "", startDate: Date(), endDate: Date(), description: "")
    
    //MARK: Properties
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    func setDisplayTime(button: UIButton!, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        
        button.setTitle(dateFormatter.string(from: date), for: .normal)
    }
    
    func startingDisplayTime() -> Date {
        let cal = Calendar.current
        let now = Date()
        
        let hour = cal.component(.hour, from: now)
        return cal.date(bySettingHour: hour, minute: 0, second: 0, of: now)!
    }
    
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitle.delegate = self
        setDisplayTime(button: startDate, date: startingDisplayTime())
        setDisplayTime(button: endDate, date: startingDisplayTime() + 60 * 60)
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
    }
    
    //MARK: Actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func titleDidEndEditing(_ sender: UITextField) {
        calEvent.title = sender.text!
    }
    
    @IBAction func descriptionDidEndEditing(_ sender: UITextField) {
        calEvent.description = sender.text!
    }
    
    @IBAction func tapStartDate(_ sender: UIButton) {
        if startDatePicker.isHidden {
            startDatePicker.isHidden = false
            endDatePicker.isHidden = true
        } else {
            startDatePicker.isHidden = true
        }
    }
    
    @IBAction func tapEndDate(_ sender: UIButton) {
        if endDatePicker.isHidden {
            endDatePicker.isHidden = false
            startDatePicker.isHidden = true
        } else {
            endDatePicker.isHidden = true
        }
    }
    
    @IBAction func startDatePicked(_ sender: UIDatePicker) {
        calEvent.startDate = startDatePicker.date
        setDisplayTime(button: startDate, date: startDatePicker.date)
    }
    
    @IBAction func endDatePicked(_ sender: UIDatePicker) {
        calEvent.endDate = endDatePicker.date
        setDisplayTime(button: endDate, date: endDatePicker.date)
    }
    
    @IBAction func submitEvent(_ sender: UIButton) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let uploadData = try? encoder.encode(calEvent) else {
            return
        }
        
        let url = URL(string: "http://localhost:3000/api/events")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print("server error")
                    return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print("got data: \(dataString)")
            }
            
        }
        
        task.resume()
    }
    
}


