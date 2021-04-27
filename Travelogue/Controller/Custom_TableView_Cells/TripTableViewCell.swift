//
//  TripsTableViewCell.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet var tripLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
