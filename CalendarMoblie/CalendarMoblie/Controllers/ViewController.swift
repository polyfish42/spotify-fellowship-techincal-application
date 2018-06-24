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
    var calEvent: CalendarEvent!
    
    //MARK: Properties
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    func setDisplayTime(button: UIButton!, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
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
        
        let startTime = startingDisplayTime()
        let endTime = startingDisplayTime() + 60 * 60
        
        calEvent = CalendarEvent(title: "", startDate: startTime, endDate: endTime, description: "")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        submitButton.isEnabled = false
        eventTitle.delegate = self
        eventDescription.delegate = self
        setDisplayTime(button: startDate, date: startTime)
        setDisplayTime(button: endDate, date: endTime)
        startDatePicker.isHidden = true
        startDatePicker.date = startTime
        endDatePicker.date = endTime
        endDatePicker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        eventTitle.resignFirstResponder()
        eventDescription.resignFirstResponder()
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
    }
    
    //MARK: Actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func titleIsTapped(_ sender: Any) {
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
    }
    
    @IBAction func titleIsEditing(_ textField: UITextField) {
        if textField.text! == "" {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
    
    @IBAction func titleDidEndEditing(_ textField: UITextField) {
        calEvent.title = textField.text!
    }
    
    @IBAction func descriptionDidEndEditing(_ textField: UITextField) {
        calEvent.description = textField.text!
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
    
    func warnIfEndBeforeStart() {
        if calEvent.startDate > calEvent.endDate {
            endDate.setTitleColor(.red, for: .normal)
        } else {
            endDate.setTitleColor(self.view.tintColor, for: .normal)
        }
    }
    
    @IBAction func startDatePicked(_ sender: UIDatePicker) {
        calEvent.startDate = startDatePicker.date
        setDisplayTime(button: startDate, date: startDatePicker.date)
        warnIfEndBeforeStart()
    }
    
    @IBAction func endDatePicked(_ sender: UIDatePicker) {
        calEvent.endDate = endDatePicker.date
        setDisplayTime(button: endDate, date: endDatePicker.date)
        warnIfEndBeforeStart()
    }
    
    func alertEndBeforeStart() {
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        let alert = UIAlertController(title: "Cannot Save Event",
                                      message: "The start date must be before the end date.",
                                      preferredStyle: .alert)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    @IBAction func descriptionIsTapped(_ sender: Any) {
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
    }
    
    @IBAction func submitEvent(_ sender: UIButton) {
        if calEvent.startDate > calEvent.endDate {
            alertEndBeforeStart()
            return
        }
        
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


