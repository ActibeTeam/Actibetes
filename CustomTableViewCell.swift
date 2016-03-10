//
//  CustomTableViewCell.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 06/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBloodGlucoseLabel: UILabel!
    @IBOutlet weak var cellCarbsLabel: UILabel!
    @IBOutlet weak var cellExerciseLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
