//
//  EventDurationCalculator.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 23/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation

class TimeCalculator {
    
    static func getEventDuration() -> String {
        guard let eventDurationSeconds = CurrentEventProvider.duration else { return "" }
        let minutes = (eventDurationSeconds % 3600) / 60
        let seconds = eventDurationSeconds % 60
            
        if minutes < 1 {
            return String(format:"%02i", seconds) + " secs"
        } else {
            return String(format:"%02i mins %02i secs", minutes, seconds)
        }
    }
    
    static func calculateTime(sample: UInt32) -> String {
        let timeInSeconds = sample/UInt32(ChartConstants.ECGSampleRate)
        let minutes = (timeInSeconds % 3600) / 60
        let seconds = timeInSeconds % 60
        
        if minutes < 1 {
            return String(format:"%02i", seconds) + " secs"
        } else {
            return String(format:"%02i mins %02i secs", minutes, seconds)
        }
        
    }
    
}
