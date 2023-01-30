//
//  AudioTableController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-25.
//

import Foundation
import UIKit

extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioPlayerCell = tableView.dequeueReusableCell(withIdentifier: "audioPlayerCell", for: indexPath) as! AudioCustomTableViewCell
    
        // number of audio
        audioPlayerCell.audioIndexLabel.text = "\(indexPath.row + 1)"
        let audioTime = audioPlayerCell.audioLongLabel
        
        let scrubble = audioPlayerCell.scrubber
        scrubble?.value = 0
        let play = audioPlayerCell.audioPlayButton
     
        play!.tag = indexPath.row
        play!.addTarget(self, action: #selector(playAudio(_ : )), for: .touchDown)
        audioPlayButton.append(play!)
        scrubber.append(scrubble!)
        
        audioTimeLabel.append(audioTime!)

        return audioPlayerCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
            let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                tableView.beginUpdates()
                self.deleteAudio(audioPath: self.audioPath[indexPath.row])
                self.audioTableView.deleteRows(at: [indexPath], with: .fade)
                self.audioPath.remove(at: indexPath.row)
                self.audioTableView.endUpdates()
                self.audioTableView.reloadData()
            }))
            self.present(alertController, animated: true)
            completionHandler(true)
        })
        deleteAction.image = UIImage(systemName: "trash")
        let  preventSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
        preventSwipe.performsFirstActionWithFullSwipe = false
        return preventSwipe
    }
}
