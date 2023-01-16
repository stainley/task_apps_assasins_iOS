//
//  CategoryCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/12/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var deleteCategoryButton: UIButton! {
        didSet {
            self.deleteCategoryButton.isHidden = true
            self.deleteCategoryButton.isEnabled = false
        }
    }
    
    override class func awakeFromNib() {
       
    }
    
    
    func showDeleteCategoryButton() {
       
    }
}
