//
//  ContactDetailsViewController.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/20/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class ContactDetailsViewController: FormViewController {
  
  @IBOutlet weak var btnDeleteDiscard: UIBarButtonItem!
  @IBOutlet weak var btnDoneSave: UIBarButtonItem!
  
  weak var contactListVC: ContactsTableViewController?
  var card: Card!
  var realm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    btnDeleteDiscard.title = card.accepted ? "Delete" : "Discard"
    btnDoneSave.title = card.accepted ? "Done" : "Save"
    
    form
      +++ Section() {
        var header = HeaderFooterView<ProfilePhotoView>(.nibFile(name: "ProfilePhoto", bundle: nil))
        header.onSetupView = { (view, section) -> () in
          view.imageView.image = UIImage(data: self.card.imageData!)
          view.imageView.alpha = 0;
          UIView.animate(withDuration: 2.0, animations: { [weak view] in
            view?.imageView.alpha = 1
          })
          view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
          UIView.animate(withDuration: 1.0, animations: { [weak view] in
            view?.layer.transform = CATransform3DIdentity
          })
        }
        $0.header = header
    }
      +++ Section("Personal Info")
      <<< NameRow() {
        $0.title = "First Name"
        $0.value = card.firstName
        $0.disabled = true
    }
      <<< NameRow() {
        $0.title = "Last Name"
        $0.value = card.lastName
        $0.disabled = true
    }
      <<< NameRow() {
        $0.title = "Company"
        $0.value = card.company ?? "N/A"
        $0.disabled = true
    }
      +++ Section("Contact Details")
      <<< NameRow() {
        $0.title = "Email"
        $0.value = card.email
        $0.disabled = true
    }
      <<< PhoneRow() {
        $0.title = "Phone"
        $0.value = card.phoneNumber
        $0.disabled = true
    }
      <<< URLRow() {
        $0.title = "Website"
        $0.value = URL(string: card.website ?? "")
        $0.placeholder = "N/A"
        $0.disabled = true
    }
  }
  
  
  // MARK: - IBActions
  
  @IBAction func deleteCard(_ sender: UIBarButtonItem) {
    try! realm.write {
      realm.delete(card)
    }
    dismiss(animated: true) {
      self.contactListVC?.loadContacts()
    }
  }
  
  @IBAction func saveCard(_ sender: UIBarButtonItem) {
    if !card.accepted {
      try! realm.write {
        self.card.accepted = true
        realm.add(card, update: .modified)
      }
    }
    
    dismiss(animated: true) {
      self.contactListVC?.loadContacts()
    }
  }
}
