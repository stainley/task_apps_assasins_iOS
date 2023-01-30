//
//  TaskDetailRepository.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/29/23.
//

import CoreData
import UIKit

extension TaskDetailViewController {
    
    func deleteAudio(audioPath: String) {
        var audiosEntity = [AudioEntity]()
        
        do {
            let request = AudioEntity.fetchRequest() as NSFetchRequest<AudioEntity>
            
            let predicate = NSPredicate(format: "audioPath CONTAINS %@", audioPath)
            request.predicate = predicate
            
            audiosEntity = try context.fetch(request)
            if audiosEntity.count > 0 {
                context.delete(audiosEntity[0])
            }
        }
        catch {
            
        }
    }
    
    func deleteImage(pictureEntity: PictureEntity) {
        context.delete(pictureEntity)
    }
}

