//
//  NoteTaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/12/23.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var sortNameButton: UIButton!
    @IBOutlet weak var sortDateButton: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [NoteEntity]()
    
    var picturesEntity = [PictureEntity]()
    var audiosEntity = [AudioEntity]()
    var filteredNotes = [NoteEntity]()
    
    var noteReferenceCell: NoteNibTableViewCell!
    
    var pictures: [UIImage]?
    var iconName: String = ""
    
    var selectedCategory: CategoryEntity? {
        didSet {
            notes = loadNotesByCategory()
        }
    }
    
    var isNameAsc: Bool = true
    var isCreateDate: Bool = true
    
    @IBAction func addNewNoteButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func unwindToNote(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        saveNote()
    }
    
    @IBAction func noteFilterButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func sortNameButton(_ sender: UIButton){
        isNameAsc.toggle()
        if isNameAsc {
            sortByNameAsc()
            iconName = "arrow.down"
        }else {
            sortByNameDesc()
            iconName = "arrow.up"
        }
        if let sortImage = UIImage(systemName:iconName) {
            sortNameButton.setImage(sortImage, for: .normal)
        }
    }
    @IBAction func sortDateButton(_ sender: UIButton){
        isCreateDate.toggle()
        if isCreateDate {
            sortByCreateDateAsc()
            iconName = "arrow.down"
        }else {
            sortByCreateDateDesc()
            iconName = "arrow.up"
        }
        if let sortImage = UIImage(systemName:iconName) {
            sortDateButton.setImage(sortImage, for: .normal)
        }
    }
    //Sorting Name and Date functions
    func sortByNameAsc(){
        let assortNameAsc = filteredNotes.sorted{ $0.title! < $1.title! }
        filteredNotes = []
        filteredNotes = assortNameAsc
        noteTableView.reloadData()
    }
    func sortByNameDesc(){
        let assortNameAsc = filteredNotes.sorted{ $0.title! > $1.title! }
        filteredNotes = []
        filteredNotes = assortNameAsc
        noteTableView.reloadData()
    }
    func sortByCreateDateAsc(){
        let assortDateAsc = filteredNotes.sorted{ $0.creationDate! < $1.creationDate! }
        filteredNotes = []
        filteredNotes = assortDateAsc
        noteTableView.reloadData()
    }
    func sortByCreateDateDesc(){
        let assortDateDesc = filteredNotes.sorted{ $0.creationDate! > $1.creationDate! }
        filteredNotes = []
        filteredNotes = assortDateDesc
        noteTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? NoteDetailViewController {
            destination.delegate = self
          
            loadImagesByNote()
            loadAudiosByNote()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.title
        let cellNib = UINib(nibName: "NoteNibTableViewCell", bundle: Bundle.main)
        noteTableView.register(cellNib, forCellReuseIdentifier: "NoteNibTableViewCell")
        filteredNotes = notes
        picturesEntity = loadImagesByNote()
        sortNameButton.layer.cornerRadius = 4
        sortDateButton.layer.cornerRadius = 4
    }
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: "NoteNibTableViewCell", for: indexPath) as! NoteNibTableViewCell

        cell.titleLabel?.text = filteredNotes[indexPath.row].title
        cell.descriptionLabel?.text = filteredNotes[indexPath.row].noteDescription
        
        
        if let creation = filteredNotes[indexPath.row].creationDate {
            cell.creationDateLabel?.text = "Created: \(creation.toString(dateFormat: "MMMM dd, yyyy 'on' h:mm:ss a"))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
            let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)


            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                tableView.beginUpdates()

                self.deleteNote(noteEntity: self.filteredNotes[indexPath.row])
                self.saveNote()

                self.filteredNotes.remove(at: indexPath.row)
                self.notes.remove(at: indexPath.row)

                self.noteTableView.deleteRows(at: [indexPath], with: .fade)
                self.noteTableView.endUpdates()

                self.notes = self.loadNotesByCategory()
                self.filteredNotes = self.notes
                self.noteTableView.reloadData()
            }))
            self.present(alertController, animated: true)
            completionHandler(true)
        })

        deleteAction.image = UIImage(systemName: "trash")

        let edit = UIContextualAction(style: .normal, title: "Edit", handler: {(action, view, completionHandler) in
            // TODO: Implement Change Category
            let switchCategoryVC = ChangeCategoryView()
            
            self.present(switchCategoryVC, animated: false)
            
            completionHandler(true)
        })
        edit.backgroundColor = UIColor.systemBlue
        edit.image = UIImage(systemName: "square.and.pencil")

        let  preventSwipe = UISwipeActionsConfiguration(actions: [deleteAction, edit])
        preventSwipe.performsFirstActionWithFullSwipe = false
        return preventSwipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.filteredNotes[indexPath.row]
        
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            //noteDetailViewController.pictureEntities = picturesEntity
            noteDetailViewController.note = note
            noteDetailViewController.delegate = self
            
            guard let noteTitle = note.title else {
                return
            }
            let byParent  =  NSPredicate(format: "note_parent.title == %@", noteTitle)
            noteDetailViewController.pictureEntities = loadImagesByNote(predicate: byParent)
            loadAudiosByNote(predicate: byParent)
            
            print(picturesEntity.count)
       
            
            for pic in picturesEntity {
                noteDetailViewController.pictures.append(UIImage(data: pic.picture!)!)
            }
            
            for audio in audiosEntity {
                noteDetailViewController.audioPath.append(audio.audioPath!)
            }
            
            self.navigationController?.pushViewController(noteDetailViewController, animated: true)
        }
    }
}

extension NSDate {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}


