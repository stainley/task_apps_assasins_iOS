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
    var categoryCell: CategoryCell!
    
    
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
        searchController.automaticallyShowsScopeBar = false
        
        present(searchController, animated: true, completion: nil)
    }
        
    /// show alert when the name of the folder is taken
    private func showAlert() {
        let alert = UIAlertController(title: "Name Taken", message: "Please choose another name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self

        
        
        categoriesEntity  = self.fetchAllCategory();
        filteredCategories = categoriesEntity
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        var config = UIBackgroundConfiguration.listPlainCell()
        config.backgroundColor = .clear
        
        cell.backgroundConfiguration = config
        categoryCell = cell
        //collectionView.backgroundColor = nil
        cell.categoryLabel.text = filteredCategories[indexPath.row].name
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
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"),handler: {_ in
            self.deleteCategory(category: self.filteredCategories[indexPath.row])
            self.saveCategory()
            self.categoriesEntity.remove(at: indexPath.row)
            self.filteredCategories = self.categoriesEntity
            self.categoryCollectionView.reloadData()
        })
        
        let editAction = UIAction(title: "Update", image: UIImage(systemName: "pencil"),handler: {_ in
            let alert = UIAlertController(title: "Edit name", message: "Please give a new name", preferredStyle: .alert)
            var textField = UITextField()

            let addAction = UIAlertAction(title: "Update", style: .default) { (action) in
                let categoryNames = self.categoriesEntity.map {$0.name?.lowercased()}
                
                guard !categoryNames.contains(textField.text?.lowercased()) else {
                    self.showAlert()
                    return
                }
                
                let oldCategory = self.categoriesEntity[indexPath.row]
                oldCategory.name = textField.text!
                oldCategory.updatedDate = Date()
                
                self.categoriesEntity[indexPath.row].name = oldCategory.name
                self.updateCategory(category: oldCategory)
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
            
            self.present(alert, animated: true, completion: nil)
            
        })
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider:  { _ -> UIMenu? in
            
            let menu = UIMenu(title: "Delete Category", image: UIImage(systemName: "trash") ,children: [editAction, deleteAction])
            return menu
        })
        return config
    }
}
