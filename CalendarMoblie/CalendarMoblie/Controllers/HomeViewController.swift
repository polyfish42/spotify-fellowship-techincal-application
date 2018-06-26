//
//  HomeViewController.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/25/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UITextFieldDelegate {
    //MARK: Model
    var events: [CalendarEvent] = []
    let today = Date()
    var displayedDate = Date()
    let userCalendar = Calendar.current
    var days: [Int] = []
    
    //MARK: Properties
    @IBOutlet weak var displayedDateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        udpateDisplayMonth()
        fetchEvents()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let day = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as! CalendarViewDay
        
        day.dayNumberLabel.text = dateText(idx: indexPath.item)
        
        return day
    }
    
    func dateText(idx: Int) -> String {
        switch days[idx] {
        case 0:
            return ""
        default:
            return String(days[idx])
        }
    }
    
    func updateDisplayedDateLabel() {
        let monthIdx = userCalendar.component(.month, from: displayedDate) - 1
        let year = userCalendar.component(.year, from: displayedDate)
        let month = userCalendar.monthSymbols[monthIdx]
        
        displayedDateLabel.text = "\(month) \(year)"
    }
    
    func udpateDisplayMonth() {
        updateDisplayedDateLabel()
        days = Array(repeating: 0, count: numberOfEmptyDays())
        let daysInMonth = userCalendar.range(of: .day, in: .month, for: displayedDate)!
        days += Array(daysInMonth.lowerBound..<daysInMonth.upperBound)
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
    
    func numberOfEmptyDays() -> Int {
        let startOfMonth = userCalendar.date(from: userCalendar.dateComponents([.year, .month], from: userCalendar.startOfDay(for: displayedDate)))!
        let weekDay = userCalendar.component(.weekday, from: startOfMonth)
        return weekDay - 1
    }
    
    //MARK: Actions
    
    @IBAction func displayNextMonth(_ sender: UIButton) {
        displayedDate = userCalendar.date(byAdding: .month, value: 1, to: displayedDate)!
        udpateDisplayMonth()
    }
    
    @IBAction func displayPrevMonth(_ sender: UIButton) {
        displayedDate = userCalendar.date(byAdding: .month, value: -2, to: displayedDate)!
        udpateDisplayMonth()
    }
    
    func fetchEvents() {
        let url = URL(string: "http://localhost:3000/api/events")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    
                    let alert = UIAlertController(title: "Cannot Save Event",
                                                  message: "We're sorry, but we're having trouble getting your events. Please try again later.",
                                                  preferredStyle: .alert)
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let events = try! decoder.decode([CalendarEvent].self, from: data)
                print("got data: \(events)")
                self.events = events
                DispatchQueue.main.async {
                 self.collectionView!.reloadData()
                }
            }
        }
        
        task.resume()
    }
}
