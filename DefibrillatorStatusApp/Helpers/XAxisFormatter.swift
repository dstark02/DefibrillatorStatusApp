//
//  XAxisFormatter.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 15/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Charts

class XAxisFormatter: NSObject, IAxisValueFormatter {
    
    /// Called when a value from x axis is formatted before being drawn.
    ///
    /// - Parameters:
    ///   - value: x axis value
    ///   - axis: x
    /// - Returns: correct time as a string to display
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        
        return String(value/ChartConstants.ECGSampleRate)
    }
    
    
}
