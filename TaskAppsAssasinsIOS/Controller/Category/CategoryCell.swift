//
//  CategoryCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/12/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.font = UIFont.preferredFont(forTextStyle: .body)
            categoryLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    @IBOutlet weak var folderImageView: UIImageView! {
        didSet {
      
        }
    }
    
    override class func awakeFromNib() {
       
    }   
   
}
