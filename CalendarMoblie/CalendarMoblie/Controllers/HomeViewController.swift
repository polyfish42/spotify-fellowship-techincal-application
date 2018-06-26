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
    let days = ["1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16",
                "17",
                "18",
                "19",
                "20",
                "21",
                "22",
                "23",
                "24",
                "25",
                "26",
                "27",
                "28",
                "29",
                "30"]
    
    //MARK: Properties
    
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEvents()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let day = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as! CalendarViewDay
        
        day.dayNumberLabel.text = days[indexPath.item]
        
        return day
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
            }
        }
        
        task.resume()
    }
}
