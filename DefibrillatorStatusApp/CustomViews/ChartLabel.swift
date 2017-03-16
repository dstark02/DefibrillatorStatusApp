//
//  ChartLabel.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 14/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class ChartLabel: UIView {

    
    @IBOutlet var view: UIView!
    @IBOutlet weak var shockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ChartLabel", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        view.frame = bounds
        addSubview(view)
    }
    
    
}
