//
//  ViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-11.
//

import UIKit

class ViewController: UIViewController {
    
    let categories = ["Work", "School", "Grocery", "GYM", "Housework", "College", "Grocery", "GYM", "Work", "School", "Grocery", "GYM"]
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBAction
    func deleteCategory(_ sender: UIButton) {
        print("DELETED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture: )))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        self.categoryCollectionView.addGestureRecognizer(longPress)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell

        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 6.0
        cell.layer.shadowOpacity = 0.50
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 30.0
        cell.layer.masksToBounds = false
        cell.categoryLabel.text = categories[indexPath.row]
        
                
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let noteTaskSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTaskSearchViewController") as? NoteTaskSearchViewController {
            self.navigationController?.pushViewController(noteTaskSearchViewController, animated: true)
        }
    }
    
    
    //MARK: Long Press category card
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        
        let point = gesture.location(in: self.categoryCollectionView)
        if let indexPath = self.categoryCollectionView.indexPathForItem(at: point) {
            // get the cell at indexPath
            let cell = self.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
            
            cell.layer.backgroundColor = UIColor.red.cgColor
            cell.backgroundColor = UIColor.red
            print(categories[indexPath.row])
            // SHOW DELETE ICON
            cell.deleteCategoryButton.isEnabled = true
            cell.deleteCategoryButton.isHidden = false
        } else {
            print("Couldn't find index path")
        }
    }
}
