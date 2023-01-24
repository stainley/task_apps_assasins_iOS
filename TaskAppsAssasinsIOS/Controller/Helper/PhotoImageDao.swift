//
//  PhotoImageDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-23.
//

import CoreData
import UIKit


extension NoteDetailViewController {
    
    func saveImage() {
        
        do {
            try context.save()
        } catch {
            print("Saving image to the DATABASE \(error.localizedDescription)")
        }
    }
    
    
    // Fetch all categoy from Database
    func fetchAllNotes() -> Array<NoteEntity> {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error.localizedDescription)")
        }
        
        return Array<NoteEntity>()
    }
    
    func fetchImagesFromDB() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "images")
        do {
          var result =  try context.fetch(fetchRequest)
          for data in result as! [NSManagedObject] {
              //pictures?.append(data.value(forKey: "storedImage") as! Data)
          }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }

        //fetch image using decoding
        /*
        imageDataArray.forEach { (imageData) in
          var dataArray = [Data]()
          do {
            dataArray = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: imageData) as! [Data]
            myImagesdataArray.append(dataArray)
          } catch {
            print("could not unarchive array: \(error)")
          }
        } */
    }
    
    func saveImagesToDB(images: [UIImage]) {
        let entityName =  NSEntityDescription.entity(forEntityName: "pictures", in: context)!
        let image = NSManagedObject(entity: entityName, insertInto: context)

        //to store array of images using encoding
        var images: Data?
        
        do {
            images = try NSKeyedArchiver.archivedData(withRootObject: images!, requiringSecureCoding: true)
        } catch {
            print("error")
        }
        image.setValue(images, forKeyPath: "images")

        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
