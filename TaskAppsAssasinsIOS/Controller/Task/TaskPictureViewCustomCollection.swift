//
//  TaskPictureViewCustomCollection.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/27/23.
//

import Foundation
import UIKit


extension TaskDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
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

extension TaskDetailViewController {
//    func setUpDoubleTap() {
//      doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView))
//      doubleTapGesture.numberOfTapsRequired = 2
//      pictureCollectionView.addGestureRecognizer(doubleTapGesture)
//      doubleTapGesture.delaysTouchesBegan = true
//    }
//    
//    @objc func didDoubleTapCollectionView() {
//           let pointInCollectionView = doubleTapGesture.location(in: pictureCollectionView)
//           if let selectedIndexPath = pictureCollectionView.indexPathForItem(at: pointInCollectionView) {
//               let selectedCell = pictureCollectionView.cellForItem(at: selectedIndexPath)
//               
//               let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
//               alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//               alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
//                   
//                   //self.deleteImage(data: self.pictures[selectedIndexPath.row].pngData()!)
//                   
//                   self.pictureCollectionView.reloadData()
//
//               }))
//               self.present(alertController, animated: true, completion: nil)
// 
//           }
//       }
}

