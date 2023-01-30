//
//  SubTaskTableViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import UIKit

protocol SubTaskTableViewCellDelegate {
    func updateSubTaskStatus(index: Int, status: Bool)
}

class SubTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton! {
        didSet{
            checkmarkImage?.image = UIImage(systemName: "square")
        }
    }
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var subTaskTitleLabel: UILabel!
    @IBOutlet weak var datePickerButton: UIButton!
    
    var delegate: SubTaskTableViewCellDelegate?
    var cellIndex: Int?
    
    @IBAction func checkbox(_ sender: UIButton){
        sender.checkboxAnimation { [self] in
            print(sender.isSelected)
            if sender.isSelected {
                self.checkmarkImage?.image = UIImage(systemName: "checkmark.square")
            } else {
                self.checkmarkImage?.image = UIImage(systemName: "square")
            }
            
            if let cellIndex = self.cellIndex {
                self.delegate?.updateSubTaskStatus(index: cellIndex, status: sender.isSelected)
            }
        }
    }
    
    var subtask: SubTaskEntity?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func datePickerButtonTapped(_ sender: Any) {
        //guard let subtask = subtask else { return }
        //delegate?.selectDate(subTaskEntity: subtask)
    }
}

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
