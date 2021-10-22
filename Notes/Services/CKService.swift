//
//  CKService.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-20.
//

import Foundation
import CloudKit

class CKService {
    
    private init() {}
    static let shared = CKService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "no ck save error")
            print(record ?? "no ck record saved")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "no ck query error")
            guard let records = records else { return }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    func subscribe() {
        let subsciption = CKQuerySubscription(recordType: Note.recordType,
                                              predicate: NSPredicate(value: true),
                                              options: .firesOnRecordDeletion)
        
        let notificationInfo = CKSubscription.NotificationInfo()  // Modified by Iurie
        notificationInfo.shouldSendContentAvailable = true
        
        notificationInfo.alertBody = ""   // Added by Iurie Plese remove!
        
        subsciption.notificationInfo = notificationInfo
        
        privateDatabase.save(subsciption) { (sub, error) in
            print(error ?? "No ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    func subscribeWithUI() {
        let subsciption = CKQuerySubscription(recordType: Note.recordType,
                                              predicate: NSPredicate(value: true),
                                              options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo() // Modified by Iurie
        notificationInfo.title = "This is Cool"
        notificationInfo.subtitle = "A Whole New iCloud"
        notificationInfo.alertBody = "I bet ya didnt know about the power of the cloud"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subsciption.notificationInfo = notificationInfo
        
        privateDatabase.save(subsciption) { (sub, error) in
            print(error ?? "No ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    func fetchRecord(with recordId: CKRecord.ID) {
        privateDatabase.fetch(withRecordID: recordId) { (record, error) in
            print(error ?? "no ck fetch error")
            guard let record = record else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"),
                                                object: record)
            }
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification?.notificationType {  // Added ? by Iurie
        case .query:
            guard let queryNotification = notification as? CKQueryNotification,
                let recordId = queryNotification.recordID
                else { return }
            fetchRecord(with: recordId)

        default: return

        }
    }
}
