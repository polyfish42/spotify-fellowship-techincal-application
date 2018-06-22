//
//  ViewController.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/20/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    struct CalendarEvent: Encodable {
        var title: String
        var startDate: Date
        var endDate: Date
        var description: String
        
        enum CodingKeys: String, CodingKey {
            case event
        }
        
        enum Event: String, CodingKey {
            case title
            case startDate = "start_date"
            case endDate = "end_date"
            case description
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var event = container.nestedContainer(keyedBy: Event.self, forKey: .event)
            try event.encode(title, forKey: .title)
            try event.encode(startDate, forKey: .startDate)
            try event.encode(endDate, forKey: .endDate)
            try event.encode(description, forKey: .description)
        }
    }
    
    var calEvent = CalendarEvent(title: "", startDate: Date.init(), endDate: Date.init(), description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitle.delegate = self
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
    }
    
    //MARK: UITextFieldDelegate
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
    
    //MARK: Actions
    
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
        let date = startDatePicker.date
        print(date)
    }
    
    @IBAction func submitEvent(_ sender: UIButton) {
        guard let uploadData = try? JSONEncoder().encode(calEvent) else {
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


