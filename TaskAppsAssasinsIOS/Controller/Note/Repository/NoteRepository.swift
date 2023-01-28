//
//  NoteVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-22.
//

import UIKit
import CoreData

extension NoteViewController {
    
    func saveNote() {
        do {
            try context.save()
            // reload collection of views
            
            print("Note had been saved")
            noteTableView.reloadData()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
    
    // Delete category from Database
    func deleteNote(noteEntity: NoteEntity) {
        print(noteEntity.title!)
        context.delete(noteEntity)
    }
    
    func loadImagesByNote(predicate: NSPredicate? = nil) -> [PictureEntity] {
        let request: NSFetchRequest<PictureEntity> = PictureEntity.fetchRequest()
       // let notePredicate = NSPredicate(format: "note_parent.title=%@", selectedCategory!.name!)

        request.predicate = predicate
        do {
            picturesEntity = try context.fetch(request)
            print("Search by pictures \(picturesEntity.count)")
        } catch {
            print("An error had ocurred: \(error.localizedDescription)")
        }
        return picturesEntity
    }
    
    // TODO: Elvin
    func loadAudiosByNote(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<AudioEntity> = AudioEntity.fetchRequest()

        request.predicate = predicate
        do {
            audiosEntity = try context.fetch(request)
        } catch {
            print("An error had ocurred: \(error.localizedDescription)")
        }
    }
    
    func loadNotesByCategory(predicate: NSPredicate? = nil) -> Array<NoteEntity> {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let categoryPredicate = NSPredicate(format: "category_parent.name=%@", selectedCategory!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        return Array<NoteEntity>()
    }
    
    func changeNoteCategory(noteEntity: NoteEntity, for categoryEntity: CategoryEntity) {
        
        noteEntity.category_parent = categoryEntity
        saveNote()
        filteredNotes = loadNotesByCategory()
        noteTableView.reloadData()
    }

    func saveNote(note: Note, oldNoteEntity: NoteEntity? = nil, newPictures: [UIImage], newAudioPath: [String]) {
        // Title must be required.
        if note.title == "" || note.title.isEmpty || (oldNoteEntity != nil && oldNoteEntity?.title == nil) {
            return
        }
        
        if let oldNoteEntity = oldNoteEntity {
            
            // UPDATE NOT SAVE
            updateNote(updatedNote: note, oldNote: oldNoteEntity, newPictures: newPictures, newAudioPath: newAudioPath)
            return
        }
        
        let newNote = NoteEntity(context: context)
        newNote.title = note.title
        newNote.noteDescription = note.noteDescription!
        newNote.creationDate = Date()
        
        // Save image to the Database
        for picture in note.pictures {
            let pictureEntity = PictureEntity(context: context)
            pictureEntity.pictureId = UUID.init().uuidString
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
    
    func updateNote(updatedNote: Note, oldNote: NoteEntity, newPictures: [UIImage], newAudioPath: [String]) {
        oldNote.title = updatedNote.title
        oldNote.noteDescription = updatedNote.noteDescription

        // Save image to the Database
        for picture in newPictures {
            let pictureEntity = PictureEntity(context: context)

            pictureEntity.picture = picture.pngData()!
            pictureEntity.note_parent = oldNote
            oldNote.addToPictures(pictureEntity)
        }
        
        // Save audio into the Database
        for audio in newAudioPath {
            let audioEntity = AudioEntity(context: context)
            audioEntity.audioPath = audio
            audioEntity.note_parent = oldNote
            oldNote.addToAudios(audioEntity)
        }
        
        saveNote()
        notes = loadNotesByCategory()
        filteredNotes = notes
        noteTableView.reloadData()
    }
    
    func fetchAllCategory() -> Array<CategoryEntity> {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error.localizedDescription)")
        }
        
        return Array<CategoryEntity>()
    }
}

