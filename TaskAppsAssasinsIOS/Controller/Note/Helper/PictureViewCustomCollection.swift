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
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pictureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for:indexPath) as! PictureCollectionViewCell

        pictureCell.thumbnail.image = pictures[indexPath.row]
        return pictureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension NoteDetailViewController {
    func setUpDoubleTap() {
      doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
      doubleTapGesture.numberOfTapsRequired = 2
      pictureCollectionView.addGestureRecognizer(doubleTapGesture)
      doubleTapGesture.delaysTouchesBegan = true
    }
    
    @objc func didDoubleTapCollectionView() {
           let pointInCollectionView = doubleTapGesture.location(in: pictureCollectionView)
           if let selectedIndexPath = pictureCollectionView.indexPathForItem(at: pointInCollectionView) {
               _ = pictureCollectionView.cellForItem(at: selectedIndexPath)
               
               let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
               alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
               alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                   
                   deleteImage(pictureEntity: pictureEntities[selectedIndexPath.row])
                   pictures.remove(at: selectedIndexPath.row)
                   self.pictureCollectionView.reloadData()

               }))
               self.present(alertController, animated: true, completion: nil)
 
           }
       }
}
