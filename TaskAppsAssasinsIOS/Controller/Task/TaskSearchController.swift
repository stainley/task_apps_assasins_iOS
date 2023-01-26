//
//  TaskSearchController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/22/23.
//

import UIKit

extension TaskViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTasks = []
        
        if searchText.contains(" ") {
            filteredTasks = tasks
        } else if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            for task in tasks {
               
                if ((task.title?.lowercased().contains(searchText.lowercased())) != nil) {
                    filteredTasks.append(task)
                    view.isUserInteractionEnabled = false
                }
            }
        }
        taskTableView.reloadData()
        
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        searchBar.showsCancelButton = false

        filteredTasks = tasks
        taskTableView.reloadData()
    }
}
