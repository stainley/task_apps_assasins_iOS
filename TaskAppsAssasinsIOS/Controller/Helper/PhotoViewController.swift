//
//  PhotoViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-22.
//

import UIKit

extension NoteDetailViewController {
    
    func takePhotoOrUpload() {
                
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
        })
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        present(photoSourceRequestController, animated: true)
        
    }
    
    func convertImageToData(myImagesArray: [UIImage]) -> [Data] {
      var myImagesDataArray = [Data]()
      myImagesArray.forEach({ (image) in
          myImagesDataArray.append(image.jpegData(compressionQuality: 1)!)
      })
      return myImagesDataArray
    }
}

extension TaskDetailViewController {
    func takePhotoOrUpload() {
                
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
        })
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        present(photoSourceRequestController, animated: true)
    }
    
    func convertImageToData(myImagesArray: [UIImage]) -> [Data] {
      var myImagesDataArray = [Data]()
      myImagesArray.forEach({ (image) in
          myImagesDataArray.append(image.jpegData(compressionQuality: 1)!)
      })
      return myImagesDataArray
    }
}

extension NoteDetailViewController: UINavigationControllerDelegate {
    
}

extension NoteDetailViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pictures.append(selectedImage)
            newPictures.append(selectedImage)
            imageSectionLabel.isHidden = false
            pictureCollectionView.superview?.isHidden = false
            pictureCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)

    }
}

extension TaskDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            pictures.append(selectedImage)
            newPictures.append(selectedImage)
            imageSectionLabel.isHidden = false
            pictureCollectionView.superview?.isHidden = false
            pictureCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)

    }
}
