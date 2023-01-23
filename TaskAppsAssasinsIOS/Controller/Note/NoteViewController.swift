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
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    var noteReferenceCell: NoteNibTableViewCell!
    
    var passingData: String?
    var categorySelected: CategoryEntity?
    
    @IBAction func addNewNoteButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func noteFilterButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
      
        
        super.viewDidLoad()        //TO BE REMOVE - DUMMY DATA
        notes.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        notes.append(Note(title: "2023W CPS 1001", description: "Co-op Preparation and Success", creationDate: NSDate(), pictures: [], audios: []))
        notes.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        notes.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        notes.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        notes.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        
        //buttonStackView.layer.cornerRadius = 8
        
        let cellNib = UINib(nibName: "NoteNibTableViewCell", bundle: Bundle.main)
        noteTableView.register(cellNib, forCellReuseIdentifier: "NoteNibTableViewCell")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        filteredNotes = notes
    }
    
    
    @IBAction func addNoteButtonTapped(_ sender: UIBarButtonItem) {
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            noteDetailViewController.categorySelected = passingData ?? ""
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
        cell?.descriptionLabel?.text = filteredNotes[indexPath.row].getDescription()
        cell?.creationDateLabel?.text = filteredNotes[indexPath.row].getCreationDate().toString(dateFormat: "MM/DD/YYY")
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            print("a")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.filteredNotes[indexPath.row]
        
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            noteDetailViewController.note = note
            self.navigationController?.pushViewController(noteDetailViewController, animated: true)
        }
    }
}

extension NSDate
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }

}

