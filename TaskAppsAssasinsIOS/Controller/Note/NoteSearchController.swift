//
//  NoteSearchController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-22.
//

import Foundation
import UIKit

extension NoteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = []
        
        if searchText.contains(" ") {
            filteredNotes = notes
        } else if searchText.isEmpty {
            filteredNotes = notes
        } else {
            for note in notes {
               
                if ((note.title?.lowercased().contains(searchText.lowercased())) != nil) {
                    filteredNotes.append(note)
                    view.isUserInteractionEnabled = false
                }
            }
        }
        noteTableView.reloadData()
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

        filteredNotes = notes
        noteTableView.reloadData()
    }
}
