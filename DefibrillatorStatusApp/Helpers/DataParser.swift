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
    
    static func filterECG(event: Event) -> [UInt16] {
        var isNewPage = true
        var isECGData = true
        var ecgData = [UInt16]()
        
        for i in 0 ..< event.ecgs.count {
            
            if i % 4 == 0 {
                isNewPage = true
            } else {
                isNewPage = false
            }
            
            for j in (0..<event.ecgs[i].ecg.count) where j % 2 == 0 {
                
                var value = UInt16(0)
                (event.ecgs[i].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
                
                if isNewPage && j <= 2 {}
                else {
                    if isECGData {
                        if value == 65535 { break }
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
    
//    static func filter(event: Event) -> [UInt16] {
//        
//        var isNewPage = true
//        var isECGData = true
//        var ecgData = [UInt16]()
//        var dataIndex = 0
//        var pageValue = 0
//        
//        
//        while dataIndex < event.ecgs.count {
//            
//            var valueAtFirstRead = UInt32(0)
//            (event.ecgs[dataIndex].ecg as NSData).getBytes(&valueAtFirstRead, range: NSMakeRange(0, 4))
//            
//            
//            if valueAtFirstRead == UInt32(pageValue) {
//                isNewPage = true
//                print(pageValue)
//                pageValue += 1
//            } else {
//                isNewPage = false
//            }
//            
//            for j in (0..<event.ecgs[dataIndex].ecg.count) where j % 2 == 0 {
//                
//                var value = UInt16(0)
//                (event.ecgs[dataIndex].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
//                
//                if isNewPage && j <= 2 {}
//                else {
//                    if isECGData {
//                        if value != 65535 {
//                            ecgData.append(value)
//                            isECGData = false
//                        }
//                    } else {
//                        isECGData = true
//                    }
//                }
//            }
//            dataIndex += 1
//        }
//        return ecgData
//    }
    
    
    
    
}
