//
//  NoteTaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/12/23.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [NoteEntity]()
    var filteredNotes = [NoteEntity]()
    var noteReferenceCell: NoteNibTableViewCell!
    
    var passingData: String?
    var categorySelected: CategoryEntity? {
        didSet {
            fetchAllNote()
        }
    }
    
    @IBAction func noteFilterButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "NoteNibTableViewCell", bundle: Bundle.main)
        noteTableView.register(cellNib, forCellReuseIdentifier: "NoteNibTableViewCell")
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIBarButtonItem) {
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            noteDetailViewController.categorySelected = categorySelected
            noteDetailViewController.delegate = self
            self.navigationController?.pushViewController(noteDetailViewController, animated: true)
        }
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: "NoteNibTableViewCell", for: indexPath) as? NoteNibTableViewCell

        cell?.titleLabel?.text = filteredNotes[indexPath.row].title
        cell?.descriptionLabel?.text = filteredNotes[indexPath.row].noteDescription
        cell?.creationDateLabel?.text = filteredNotes[indexPath.row].creationDate?.toString(dateFormat: "MM/DD/YYY")
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let noteToRemove: NoteEntity?
            noteToRemove = self.filteredNotes[indexPath.row]
            
            self.deleteNote(note: noteToRemove!)

            do {
                try self.context.save()
            } catch  {
                
            }
            
            self.fetchAllNote()
            //self.filteredNotes = fetchAllNote();
            //self.noteTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.filteredNotes[indexPath.row]
        
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            noteDetailViewController.note = note
            noteDetailViewController.delegate = self
            self.navigationController?.pushViewController(noteDetailViewController, animated: true)
        }
    }
}

extension NoteViewController: NoteDetailViewControllerDelegate {
    func reloadTableview() {
        fetchAllNote()
        //self.filteredNotes = self.fetchAllNote();
        //self.noteTableView.reloadData()
    }
}
