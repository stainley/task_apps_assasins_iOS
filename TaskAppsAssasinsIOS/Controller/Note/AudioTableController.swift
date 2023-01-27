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
    
        let scrubble = audioPlayerCell.scrubber
        let play = audioPlayerCell.audioPlayButton
     
        play!.tag = indexPath.row
        // pass the index clicked through the tag of the button
        play!.addTarget(self, action: #selector(playAudio(_ : )), for: .touchDown)
        scrubber = scrubble
        return audioPlayerCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete audio by swipping
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let audio = AudioEntity(context: self.context)
            audio.audioPath = self.audioPath[indexPath.row]
            self.deleteAudio(audioEntity: audio)
            self.audioTableView.reloadData()
       }
    
        return UISwipeActionsConfiguration(actions: [action])
    }
}
