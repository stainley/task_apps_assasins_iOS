//
//  NoteTaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/12/23.
//

import UIKit

class NoteSearchViewController: UIViewController {

    @IBOutlet weak var noteTableView: UITableView!
    
    var items = [Note]()
    var noteReferenceCell: NoteNibTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TO BE REMOVE - DUMMY DATA
        items.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        items.append(Note(title: "2023W CPS 1001", description: "Co-op Preparation and Success", creationDate: NSDate(), pictures: [], audios: []))
        items.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        items.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        items.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        items.append(Note(title: "2023W MAD 4114", description: "Advanced iOS Application Development", creationDate: NSDate(), pictures: [], audios: []))
        
        //buttonStackView.layer.cornerRadius = 8
        
        let cellNib = UINib(nibName: "NoteNibTableViewCell", bundle: Bundle.main)
        noteTableView.register(cellNib, forCellReuseIdentifier: "NoteNibTableViewCell")
    }
}

extension NoteSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: "NoteNibTableViewCell", for: indexPath) as? NoteNibTableViewCell

        cell?.titleLabel?.text = items[indexPath.row].getTitle()
        cell?.descriptionLabel?.text = items[indexPath.row].getDescription()
        cell?.creationDateLabel?.text = items[indexPath.row].getCreationDate().toString(dateFormat: "MM/DD/YYY")
        
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
        let note = self.items[indexPath.row]
        
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

