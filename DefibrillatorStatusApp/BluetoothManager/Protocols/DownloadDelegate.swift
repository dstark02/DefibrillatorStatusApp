//
//  DownloadDelegate.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation

protocol DownloadDelegate {
    
    func progressHasUpdated(value: Float)
    func downloadComplete()
}
