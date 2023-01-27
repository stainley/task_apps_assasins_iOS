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
               let selectedCell = pictureCollectionView.cellForItem(at: selectedIndexPath)
               
               let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
               alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
               alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                   
                   //self.deleteImage(data: self.pictures[selectedIndexPath.row].pngData()!)
                   let data = pictures[selectedIndexPath.row].pngData()
                   
                   print(pictureEntities.count)
                   
                   deleteImage(pictureEntity: pictureEntities[selectedIndexPath.row])
                   print(selectedIndexPath.row)
                   pictures.remove(at: selectedIndexPath.row)
                   self.pictureCollectionView.reloadData()

               }))
               self.present(alertController, animated: true, completion: nil)
 
           }
       }
}
