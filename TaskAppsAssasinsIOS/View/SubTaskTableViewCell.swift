//
//  SubTaskTableViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import UIKit


class SubTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton! {
        didSet{
            //isCompleteButton.setImage(UIImage(named: "checkmark.square.fill"), for: .normal)
            //isCompleteButton.setImage(UIImage(named: "checkmark.square"), for: .selected)
            
           // isCompleteButton.layer.cornerRadius = isCompleteButton.frame.height / 2
        }
    }
    @IBOutlet weak var subTaskTitleLabel: UILabel!
    @IBOutlet weak var datePickerButton: UIButton!
    
    @IBAction func checkbox(_ sender: UIButton){
        sender.checkboxAnimation {
            print("I'm done")
            //here you can also track the Checked, UnChecked state with sender.isSelected
            print(sender.isSelected)
            if sender.isSelected {
                sender.setImage(UIImage(named: "checkmark.square"), for: .selected)
            } else {
                sender.setImage(UIImage(named: "checkmark.square.fill"), for: .normal)
            }
        }
    }
    
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
