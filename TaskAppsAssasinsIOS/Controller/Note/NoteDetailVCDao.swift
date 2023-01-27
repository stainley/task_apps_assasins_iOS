//
//  NoteDetailVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Aswin Sasikanth Kanduri on 2023-01-26.
//

import Foundation
import CoreData

extension NoteDetailViewController {
    
    func deleteAudio(audioPath: String) {
        var audiosEntity = [AudioEntity]()
        
        do {
            let request = AudioEntity.fetchRequest() as NSFetchRequest<AudioEntity>
            
            let predicate = NSPredicate(format: "audioPath CONTAINS %@", audioPath)
            request.predicate = predicate
            
            audiosEntity = try context.fetch(request)
            context.delete(audiosEntity[0])
        }
        catch {
            
        }
    }
}
