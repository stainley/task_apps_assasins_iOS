//
//  PictureViewCustomCollection.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import Foundation
import UIKit


extension NoteDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(pictures.count)
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pictureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for:indexPath) as! PictureCollectionViewCell

        pictureCell.thumbnail.image = pictures[indexPath.row]
        return pictureCell
    }
    
    // TODO: Remove picture (Aswin)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
