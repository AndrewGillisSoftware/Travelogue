//
//  LogTableViewCell.swift
//  Travelogue
//
//  Created by Andrew on 4/27/21.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet var logImage: UIImageView!
    
    @IBOutlet var logNameLabel: UILabel!
    
    @IBOutlet var logDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
