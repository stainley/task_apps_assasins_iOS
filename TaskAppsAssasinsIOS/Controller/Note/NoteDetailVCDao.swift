//
//  NoteDetailVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Aswin Sasikanth Kanduri on 2023-01-26.
//

import Foundation
import CoreData

extension NoteDetailViewController {
    
    func deleteAudio(audioEntity: AudioEntity) {
        print(audioEntity.audioPath!)
        context.delete(audioEntity)
    }
}
