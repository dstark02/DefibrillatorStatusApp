//
//  EventDurationCalculator.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 23/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation

class TimeCalculator {
    
    /// Gets the duration of the current event
    /// that is being viewed
    /// - Returns: A string of the time in minutes and seconds
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
    
    
    /// Calculates the time for a given ECG sample
    ///
    /// - Parameter sample: the index of the ECG
    /// - Returns: A string of the time in minutes and seconds
    static func calculateTime(sampleIndex: UInt32) -> String {
        let timeInSeconds = sampleIndex/UInt32(ChartConstants.ECGSampleRate)
        let minutes = (timeInSeconds % 3600) / 60
        let seconds = timeInSeconds % 60
        
        if minutes < 1 {
            return String(format:"%02i", seconds) + " secs"
        } else {
            return String(format:"%02i mins %02i secs", minutes, seconds)
        }
        
    }
    
}
