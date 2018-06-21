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
        struct CalendarEvent: Encodable {
            var title: String
            var description: String
            
            enum CodingKeys: String, CodingKey {
                case event
            }
            
            enum Event: String, CodingKey {
                case title
                case description
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var event = container.nestedContainer(keyedBy: Event.self, forKey: .event)
                try event.encode(title, forKey: .title)
                try event.encode(description, forKey: .description)
            }
        }
        
        let calEvent = CalendarEvent(title: "Developer Week NYC", description: "Free drinks!")
        
        
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


