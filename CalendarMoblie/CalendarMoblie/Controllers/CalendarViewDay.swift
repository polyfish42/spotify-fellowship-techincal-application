//
//  CalendarViewDay.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/25/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

class IdentifiedButton: UIButton {
    var buttonIdentifier: Date!
}

class CalendarViewDay: UICollectionViewCell {
    var hasEvents: Bool = false
    
    @IBOutlet weak var dayNumberLabel: IdentifiedButton!
}
