//
//  NoteNibTableViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/16/23.
//

import UIKit

class NoteNibTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
