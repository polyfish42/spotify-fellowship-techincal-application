//
//  CalendarViewDay.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/25/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import UIKit

protocol dayDelegate: class {
    func tapped(day: Date)
}

class DatedLabel: UILabel {
    var date: Date!
}

class CalendarViewDay: UICollectionViewCell {
    @IBOutlet weak var dayNumberLabel: DatedLabel!
    weak var delegate: dayDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalendarViewDay.tapFunction))
        dayNumberLabel.isUserInteractionEnabled = true
        dayNumberLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        delegate?.tapped(day: dayNumberLabel.date)
    }
}
