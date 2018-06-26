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
    var days: [CalendarEvent] = []
    let today = Date()
    var displayedDate = Date()
    let userCalendar = Calendar.current
    
    //MARK: Properties
    @IBOutlet weak var displayedDateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplayedDateLabel()
        fetchEvents()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let day = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as! CalendarViewDay
        
        day.dayNumberLabel.text = days[indexPath.item].title
        
        return day
    }
    
    func updateDisplayedDateLabel() {
        let monthIdx = userCalendar.component(.month, from: displayedDate) - 1
        let year = userCalendar.component(.year, from: displayedDate)
        let month = userCalendar.monthSymbols[monthIdx]
        
        displayedDateLabel.text = "\(month) \(year)"
    }
    //MARK: Actions
    
    @IBAction func displayNextMonth(_ sender: UIButton) {
        displayedDate = userCalendar.date(byAdding: .month, value: 1, to: displayedDate)!
        updateDisplayedDateLabel()
    }
    
    @IBAction func displayPrevMonth(_ sender: UIButton) {
        displayedDate = userCalendar.date(byAdding: .month, value: -2, to: displayedDate)!
        updateDisplayedDateLabel()
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
                self.days = events
                DispatchQueue.main.async {
                 self.collectionView!.reloadData()
                }
            }
        }
        
        task.resume()
    }
}
