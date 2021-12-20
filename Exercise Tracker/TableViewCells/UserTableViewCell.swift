//
//  UserTableViewCell.swift
//  Exercise Tracker
//
//  Created by Juvraj on 11/30/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
