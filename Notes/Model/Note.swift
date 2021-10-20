//
//  Note.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-09.
//

import Foundation
import CloudKit

struct Note {
    
    static let recordType = "Note"
    let title: String
    
//    init(title: String) {
//        self.title = title
//    }
//    
//    init?(record: CKRecord) {
//        guard let title = record.value(forKey: "title") as? String else { return nil }
//        self.title = title
//    }
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
    
}
