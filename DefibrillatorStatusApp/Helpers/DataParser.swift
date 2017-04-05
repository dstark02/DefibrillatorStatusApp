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
    
    static func filter(event: Event) -> ([UInt16], [Marker]) {
        
        var isNewPage = true
        var isECGData = true
        var ecgData = [UInt16]()
        var dataIndex = 0
        var pageValue: UInt16 = 0
        var indexChecker = 0
        var markers = [Marker]()
        
        print(event.ecgs.count / 4)
        
        
        
        while dataIndex < event.ecgs.count {
            
            var valueAtFirstRead = UInt16(0)
            var firstVal = UInt16(0)
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&valueAtFirstRead, range: NSMakeRange(3, 1))
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&firstVal, range: NSMakeRange(0, 1))
            
            
            
            if valueAtFirstRead == UInt16(128) && firstVal == 0 {
                
                print("MarkerData")
                var byteIndex = 0
                
                let markerData = event.ecgs[dataIndex].ecg + event.ecgs[dataIndex + 1].ecg + event.ecgs[dataIndex + 2].ecg + event.ecgs[dataIndex + 3].ecg
            


                    
                    
                while byteIndex < markerData.count {
                    
                    
                    if byteIndex == 0 {
                        byteIndex += 4
                    }
                    
                    if byteIndex + 10 > markerData.count {
                        break
                    }
                    var markerCode = UInt16(0)
                    (markerData as NSData).getBytes(&markerCode, range: NSMakeRange(byteIndex, 2))
                    let biMarkerCode = CFSwapInt16HostToBig(markerCode)
                    byteIndex += 2
                    var markerValue = UInt32(0)
                    (markerData as NSData).getBytes(&markerValue, range: NSMakeRange(byteIndex, 4))
                    let biMarkerValue = CFSwapInt32HostToBig(markerValue)
                    byteIndex += 4
                    var markerSample = UInt32(0)
                    (markerData as NSData).getBytes(&markerSample, range: NSMakeRange(byteIndex, 4))
                    let biMarkerSample = CFSwapInt32HostToBig(markerSample)
                    byteIndex += 4
                    
                    if Marker.markerDictionary.index(forKey: biMarkerCode) != nil {
                        markers.append(Marker(markerCode: biMarkerCode, markerValue: biMarkerValue, markerSample: biMarkerSample))
                        
                    }
                    
                    
            
                }
                dataIndex += 4
                
                
            } else {
                
                if indexChecker % 4 == 0 {
                    isNewPage = true
                    //print(pageValue)
                    pageValue += 1
                    indexChecker += 1
                } else {
                    isNewPage = false
                    indexChecker += 1
                }
                
                for j in (0..<event.ecgs[dataIndex].ecg.count) where j % 2 == 0 {
                    
                    var value = UInt16(0)
                    (event.ecgs[dataIndex].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
                    
                    
                    
                    
                    
                    
                    if isNewPage && j <= 2 {}
                    else {
                        if isECGData {
                            if value != 65535 && value != 0 {
                                //print(value)
                                ecgData.append(CFSwapInt16HostToBig(value))
                            }
                            isECGData = false
                        } else {
                            isECGData = true
                        }
                    }
                }
                dataIndex += 1
            }
            
        }
        return (ecgData, markers)
    }
    
    
    
    
}
