//
//  CategoryCollectionViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var deleteCategoryButton: UIButton! {
        didSet {
            self.deleteCategoryButton.isHidden = true
            self.deleteCategoryButton.isEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
