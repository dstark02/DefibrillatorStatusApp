//
//  DOBCell.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class DOBCell: UITableViewCell {

    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dobValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
