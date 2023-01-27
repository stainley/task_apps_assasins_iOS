//
//  ViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-11.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // create a context to work with core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoriesEntity: [CategoryEntity] = [CategoryEntity]()
    var filteredCategories: [CategoryEntity] = [CategoryEntity]()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    static var categorySelected: IndexPath?
    // TODO: Aswin - Change toggle delete button icon
    var categoryCell: CategoryCell!
    
    
    // MARK: Create new category
    @IBAction func createNewCategoryButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        print("Create a new category")
        let alert = UIAlertController(title: "New Category", message: "Please give a new category", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let categoryNames = self.categoriesEntity.map {$0.name?.lowercased()}
            
            guard !categoryNames.contains(textField.text?.lowercased()) else {
                self.showAlert()
                return
            }
            
            let newCategory = CategoryEntity(context: self.context)
            newCategory.name = textField.text!
            newCategory.updatedDate = Date()
            self.categoriesEntity.append(newCategory)
            self.filteredCategories = self.categoriesEntity
            self.saveCategory()
            
            self.categoryCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // change the color of the cancel button action
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Category Name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchCategoryButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
        
    /// show alert when the name of the folder is taken
    private func showAlert() {
        let alert = UIAlertController(title: "Name Taken", message: "Please choose another name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
        
    @IBAction func deleteCategory(_ sender: UIButton) {
        
        let index: Int = sender.layer.value(forKey: "index") as! Int
        deleteCategory(category: filteredCategories[index])
        saveCategory()
        categoriesEntity.remove(at: index)

        filteredCategories = categoriesEntity
        categoryCollectionView.reloadData()
        sender.isHidden = true
        sender.isEnabled = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
 
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture: )))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        self.categoryCollectionView.addGestureRecognizer(longPress)
        
        categoriesEntity  = self.fetchAllCategory();
        filteredCategories = categoriesEntity
    }
  
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        categoryCell = cell
        cell.deleteCategoryButton.isHidden = true
        cell.deleteCategoryButton.isEnabled = false
        cell.categoryLabel.text = filteredCategories[indexPath.row].name
        cell.deleteCategoryButton.layer.setValue(indexPath.row, forKey: "index")

        return cell
    }
  
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let noteTaskTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "NoteTaskTabBarController") as? NoteTaskTabBarController {

            noteTaskTabBarController.categorySelected = filteredCategories[indexPath.row]
            noteTaskTabBarController.delegateCategory = self
            self.navigationController?.pushViewController(noteTaskTabBarController, animated: true)
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        
        let point = gesture.location(in: self.categoryCollectionView)
        if let indexPath = self.categoryCollectionView.indexPathForItem(at: point) {
 
            let cell = self.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
            toggleDeleteButton(cell)
        } else {
            print("Couldn't find index path")
        }
    }
    
    //TODO: ASWIN RESET VALUE
    fileprivate func toggleDeleteButton(_ cell: CategoryCell) {
        // SHOW DELETE ICON
        cell.deleteCategoryButton.isEnabled.toggle()
        cell.deleteCategoryButton.isHidden.toggle()
    }
}

protocol DeleteButtonDelegate {
    func onDeleteButton(for button: CategoryCell)
}
