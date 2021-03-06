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
    
    /// Filter the event data received from defibrillator
    /// Parses the data to plot on the chart
    /// - Parameter event: Event object
    /// - Returns: UInt16 array of ECG samples to plot and an array of markers, to place on chart
    static func filter(event: Event) -> ([UInt16], [Marker]) {
        
        var ecgData = [UInt16]()
        var markerData = [Marker]()
        var isNewPage = true
        var isECGData = true
        var dataIndex = 0
        var pageChecker = 0
        
        // while index is less than the amount of data packets
        while dataIndex < event.ecgs.count {
            
            var markerByte = UInt16(0)
            var pageByte = UInt16(0)
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&markerByte, range: NSMakeRange(3, 1))
            (event.ecgs[dataIndex].ecg as NSData).getBytes(&pageByte, range: NSMakeRange(0, 1))
            
            if markerByte == UInt16(128) && pageByte == 0 {
                
                // Parse Marker Data
                
                var byteIndex = 4
                
                // Marker Page = 256 Bytes
                let markerPage = (event.ecgs[dataIndex].ecg + event.ecgs[dataIndex + 1].ecg
                    + event.ecgs[dataIndex + 2].ecg + event.ecgs[dataIndex + 3].ecg)
                
                while byteIndex < markerPage.count {
                    
                    if byteIndex + 10 > markerPage.count {
                        break
                    }
                    // Marker = 10 bytes
                    
                    // 2 Bytes
                    var markerCode = UInt16(0)
                    (markerPage as NSData).getBytes(&markerCode, range: NSMakeRange(byteIndex, 2))
                    // Value must be converted to Big-Endian
                    let biMarkerCode = CFSwapInt16HostToBig(markerCode)
                    print(biMarkerCode)
                    byteIndex += 2
                    
                    // 4 Bytes
                    var markerValue = UInt32(0)
                    (markerPage as NSData).getBytes(&markerValue, range: NSMakeRange(byteIndex, 4))
                    // Value must be converted to Big-Endian
                    let biMarkerValue = CFSwapInt32HostToBig(markerValue)
                    byteIndex += 4
                    
                    // 4 Bytes
                    var markerSample = UInt32(0)
                    (markerPage as NSData).getBytes(&markerSample, range: NSMakeRange(byteIndex, 4))
                    // Value must be converted to Big-Endian
                    let biMarkerSample = CFSwapInt32HostToBig(markerSample)
                    byteIndex += 4
                    
                    // If Marker exists in marker dictionary, add it to the array of markers
                    if Marker.markerDictionary.index(forKey: biMarkerCode) != nil {
                        markerData.append(Marker(markerCode: biMarkerCode, markerValue: biMarkerValue, markerSample: biMarkerSample))
                    }
                }
                // Move onto next page of data
                dataIndex += 4
                
            } else {
                
                // Parse ECG Data
                
                if pageChecker % 4 == 0 {
                    isNewPage = true
                    pageChecker += 1
                } else {
                    isNewPage = false
                    pageChecker += 1
                }
                
                // Iterate through packet of data
                for j in (0..<event.ecgs[dataIndex].ecg.count) where j % 2 == 0 {
                    
                    var value = UInt16(0)
                    
                    (event.ecgs[dataIndex].ecg as NSData).getBytes(&value, range: NSMakeRange(j, 2))
                    // Convert value to Big-Endian
                    let biValue = CFSwapInt16HostToBig(value)
                    
                    // Skip first 4 bytes if packet is a new page
                    if isNewPage && j <= 2 {}
                    else {
                        if isECGData {
                            if biValue != 65535 && biValue != 0 {
                                ecgData.append(biValue)
                            }
                            isECGData = false
                        } else {
                            isECGData = true
                        }
                    }
                }
                // Increment to next packet
                dataIndex += 1
            }
            
        }
        return (ecgData, markerData)
    }
    
    
    
    
}
