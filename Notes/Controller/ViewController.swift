//
//  ViewController.swift
//  Notes
//
//  Created by Iurie Guzun on 2021-10-07.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CKService.shared.subscribe()
        getNotes()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleFetch(_:)),
                                               name: NSNotification.Name("internalNotification.fetchedRecord"),
                                               object: nil)

    }
    @IBAction func onComposeTapped() {
        AlertService.composeNote(in: self) { (note) in
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
            print("Note has been inserted!")
        }
    }
    func insert(note: Note) {
        notes.insert(note, at: 0)
         let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func getNotes() {
        NotesService.getNotes { (notes) in
            self.notes = notes
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    @objc
    func handleFetch(_ sender: Notification) {
        guard let record = sender.object as? CKRecord,
            let note = Note(record: record)
            else { return }
        insert(note: note)
    }

}
