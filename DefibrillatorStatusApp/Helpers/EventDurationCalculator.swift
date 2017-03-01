//
//  EventDurationCalculator.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 23/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation

class EventDurationCalculator {
    
    static func getEventDuration() -> String {
        
        if let eventDurationSeconds = CurrentEventProvider.duration {
            let minutes = (eventDurationSeconds % 3600) / 60
            let seconds = (eventDurationSeconds % 3600) % 60
            
            if minutes < 1 {
                return String(format:"%02i", seconds) + " secs"
            } else {
                return String(format:"%02i mins %02i secs", minutes, seconds)
            }
            
        }
        
        return ""
    }
    
}
