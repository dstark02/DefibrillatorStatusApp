//
//  XAxisFormatter.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 15/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Charts

class XAxisFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        
        return String(round(value/ChartConstants.ECGSampleRate))
    }
    
    
}
