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
    
    var picturesEntity = [PictureEntity]()
    var audiosEntity = [AudioEntity]()
    var filteredNotes = [NoteEntity]()
    
    var noteReferenceCell: NoteNibTableViewCell!
    
    var pictures: [UIImage]?
    
    var selectedCategory: CategoryEntity? {
        didSet {
            notes = loadNotesByCategory()
        }
    }
    
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
    
    /**
     * Save note into the database
     * @param: note Note
     */
    func saveNote(note: Note) {
        let newNote = NoteEntity(context: context)
        newNote.title = note.title
        newNote.noteDescription = note.noteDescription!
        newNote.creationDate = Date()
        
        // Save image to the Database
        for picture in note.pictures {
            let pictureEntity = PictureEntity(context: context)

            pictureEntity.picture = picture
            pictureEntity.note_parent = newNote
            newNote.addToPictures(pictureEntity)
        }
        
        // Save audio into the Database
        for audio in note.audios {
            let audioEntity = AudioEntity(context: context)
            audioEntity.audioPath = audio
            audioEntity.note_parent = newNote
            newNote.addToAudios(audioEntity)
        }
        
        
        // Save coordinate to the database
        if let latitude = note.latitude, let longitude = note.longitude {
            newNote.longitude = latitude
            newNote.longitude = longitude
        }
        
        newNote.category_parent = selectedCategory
        saveNote()
        notes = loadNotesByCategory()
        filteredNotes = notes
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        filteredNotes = notes
       
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
            cell.creationDateLabel?.text = "\(creation)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete note by swipping
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteNote(noteEntity: self.filteredNotes[indexPath.row])
            self.saveNote()

            //self.loadNotesByCategory()
            self.noteTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.filteredNotes[indexPath.row]
        
        if let noteDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController {
            noteDetailViewController.note = note
            
            guard let noteTitle = note.title else {
                return
            }
            let byParent  =  NSPredicate(format: "note_parent.title == %@", noteTitle)
            loadImagesByNote(predicate: byParent)
            loadAudiosByNote(predicate: byParent)
            
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
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}

