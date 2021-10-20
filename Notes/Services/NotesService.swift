//
//  NotesService.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-20.
//

import Foundation

class NotesService {
    
    private init() {}
    
    static func getNotes(completion: @escaping ([Note]) -> Void) {
        CKService.shared.query(recordType: Note.recordType) { (records) in
            var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else { continue }
                notes.append(note)
            }
            completion(notes)
        }
    }
    
}
