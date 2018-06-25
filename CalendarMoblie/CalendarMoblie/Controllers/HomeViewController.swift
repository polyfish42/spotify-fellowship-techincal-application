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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let day = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as! CalendarViewDay
        
        day.dayNumberLabel.text = days[indexPath.item]
        
        return day
    }
}
