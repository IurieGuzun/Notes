//
//  AlertService.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-09.
//

import UIKit

class AlertService {
    
    private init() {}
    static func composeNote(in vc: UIViewController, completion: @escaping (Note) -> Void) {
        let alert = UIAlertController(title: "New Note", message: "What's on your mind?", preferredStyle: .alert)
        alert.addTextField { (titleTF) in
            titleTF.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else {return}
            let note = Note(title: title)
            completion(note)
        }
        alert.addAction(post)
        vc.present(alert, animated: true)
    }
    
}
