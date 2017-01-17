//
//  DataParser.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 17/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation
import RealmSwift

class DataParser {
    
    static func filterECG(data: Results<ECG>) -> [UInt16] {
        var isNewPage = true
        var isECGData = true
        var ecgData = [UInt16]()
        
        for i in 0 ..< data.count {
            
            if i % 4 == 0 {
                isNewPage = true
            } else {
                isNewPage = false
            }
            
            for j in (0..<data[i].ecg.count) where j % 2 == 0 {
                
                var value = UInt16(0)
                (data[i].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
                
                if isNewPage && j <= 2 {}
                else {
                    if isECGData {
                        print(value)
                        ecgData.append(value)
                        isECGData = false
                    } else {
                        //icgData.append(value)
                        isECGData = true
                    }
                }
            }
        }
        return ecgData
    }
}
