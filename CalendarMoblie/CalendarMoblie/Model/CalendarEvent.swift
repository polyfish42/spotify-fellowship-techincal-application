//
//  CalendarEvent.swift
//  CalendarMoblie
//
//  Created by Jacob Brady on 6/22/18.
//  Copyright © 2018 Jacob Brady. All rights reserved.
//

import Foundation   

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
