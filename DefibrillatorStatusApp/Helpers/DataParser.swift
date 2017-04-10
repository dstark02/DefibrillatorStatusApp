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
    
    static func filter(event: Event) -> ([UInt16], [Marker]) {
        
        var ecgData = [UInt16]()
        var markerData = [Marker]()
        var isNewPage = true
        var isECGData = true
        var dataIndex = 0
        var pageChecker = 0
        
        while dataIndex < event.ecgs.count {
            
            var markerByte = UInt16(0)
            var pageByte = UInt16(0)
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&markerByte, range: NSMakeRange(3, 1))
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&pageByte, range: NSMakeRange(0, 1))
            
            if markerByte == UInt16(128) && pageByte == 0 {
                
                print("MarkerData")
                var byteIndex = 4
                
                let markerPage = (event.ecgs[dataIndex].ecg + event.ecgs[dataIndex + 1].ecg
                    + event.ecgs[dataIndex + 2].ecg + event.ecgs[dataIndex + 3].ecg)
                
                while byteIndex < markerPage.count {
                    
                    if byteIndex + 10 > markerPage.count {
                        break
                    }
                    var markerCode = UInt16(0)
                    (markerPage as NSData).getBytes(&markerCode, range: NSMakeRange(byteIndex, 2))
                    let biMarkerCode = CFSwapInt16HostToBig(markerCode)
                    print(biMarkerCode)
                    byteIndex += 2
                    var markerValue = UInt32(0)
                    (markerPage as NSData).getBytes(&markerValue, range: NSMakeRange(byteIndex, 4))
                    let biMarkerValue = CFSwapInt32HostToBig(markerValue)
                    byteIndex += 4
                    var markerSample = UInt32(0)
                    (markerPage as NSData).getBytes(&markerSample, range: NSMakeRange(byteIndex, 4))
                    let biMarkerSample = CFSwapInt32HostToBig(markerSample)
                    byteIndex += 4
                    
                    if Marker.markerDictionary.index(forKey: biMarkerCode) != nil {
                        markerData.append(Marker(markerCode: biMarkerCode, markerValue: biMarkerValue, markerSample: biMarkerSample))
                    }
                }
                
                dataIndex += 4
                
            } else {
                
                if pageChecker % 4 == 0 {
                    isNewPage = true
                    pageChecker += 1
                } else {
                    isNewPage = false
                    pageChecker += 1
                }
                
                for j in (0..<event.ecgs[dataIndex].ecg.count) where j % 2 == 0 {
                    
                    var value = UInt16(0)
                    (event.ecgs[dataIndex].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
                    let biValue = CFSwapInt16HostToBig(value)
                    
                    if isNewPage && j <= 2 {}
                    else {
                        if isECGData {
                            if biValue != 65535 && biValue != 0 {
                                //print(value)
                                ecgData.append(biValue)
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
        return (ecgData, markerData)
    }
    
    
    
    
}
