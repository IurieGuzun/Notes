//
//  UNService.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-22.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no un auth error")
            guard granted else { return }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }

}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("un did receive")
        CKService.shared.handleNotification(with: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("un will present")
        print(notification.request.content.userInfo)
        CKService.shared.handleNotification(with: notification.request.content.userInfo)
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
        
    }
}
