//
//  SubTaskTableViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import UIKit


class SubTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var subTaskTitleLabel: UILabel!
    @IBOutlet weak var datePickerButton: UIButton!
    
    var subtask: SubTaskEntity?
    
    //var delegate: SubTaskTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func datePickerButtonTapped(_ sender: Any) {
        //guard let subtask = subtask else { return }
        //delegate?.selectDate(subTaskEntity: subtask)
    }
}


protocol SubTaskTableViewCellDelegate {
    func selectDate(subTaskEntity: SubTaskEntity)
}
