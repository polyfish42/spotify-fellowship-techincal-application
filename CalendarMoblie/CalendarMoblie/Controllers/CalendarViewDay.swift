//
//  CalendarViewDay.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/25/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

class CalendarViewDay: UICollectionViewCell {
    var date: Date! = Date()
    var hasEvents: Bool = false
    
    @IBOutlet weak var dayNumberLabel: UILabel!
}
