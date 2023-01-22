//
//  CategorySearchController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-21.
//

import Foundation
import UIKit

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategories = []

        if searchText == "" {
            filteredCategories = categoriesEntity
        } else {
            for category in categoriesEntity {
               
                let cateroyName = ( category.name ?? "")
                if cateroyName.lowercased().contains(searchText.lowercased()) {
                    
                    filteredCategories.append(category)
                    view.isUserInteractionEnabled = false
                   
                }
            }
        }
        self.categoryCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        view.isUserInteractionEnabled = true
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
                
        activityIndicator.stopAnimating()

    }
}
