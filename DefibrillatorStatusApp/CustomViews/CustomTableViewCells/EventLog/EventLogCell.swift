//
//  EventLogCell.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 06/04/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class EventLogCell: UITableViewCell {

    
    @IBOutlet weak var markerDescription: UILabel!
    @IBOutlet weak var markerTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
