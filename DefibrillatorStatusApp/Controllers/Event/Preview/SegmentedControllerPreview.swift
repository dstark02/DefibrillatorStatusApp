//
//  ChartPreview.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 21/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

extension SavedEventsController : UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = eventListTable.indexPathForRow(at: location),
            let cell = eventListTable.cellForRow(at: indexPath) else {
                return nil
        }
        
        // Make sure you set the current event that was selected
        CurrentEventProvider.currentEvent = events[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Event", bundle: nil)
        let segmentedController = storyboard.instantiateViewController(withIdentifier: "SegmentedController") as! SegmentedController
    
        segmentedController.preferredContentSize = CGSize(width: 0.0, height: 600)
        previewingContext.sourceRect = cell.frame
        
        return segmentedController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
