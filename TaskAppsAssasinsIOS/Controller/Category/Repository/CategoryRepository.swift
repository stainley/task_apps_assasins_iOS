//
//  CategoryDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-21.
//

import Foundation
import CoreData

extension CategoryViewController {
    
    // Save category into Database
    func saveCategory() {
        do {
            try context.save()
            // reload collection of views
            categoryCollectionView.reloadData()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
    
    // Delete category from Database
    func deleteCategory(category: CategoryEntity) {
        print(category.name!)
        context.delete(category)
    }
    
    // Fetch all categoy from Database
    func fetchAllCategory() -> Array<CategoryEntity> {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error.localizedDescription)")
        }
        
        return Array<CategoryEntity>()
    }
    
    // Update category
    func updateCategory(category: CategoryEntity) {
        saveCategory()
        categoriesEntity = fetchAllCategory()
        categoryCollectionView.reloadData()
    }
    
}
