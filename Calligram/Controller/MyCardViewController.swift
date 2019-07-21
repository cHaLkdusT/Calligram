//
//  CalliCardViewController.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/15/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
// Step 2. Browsing for a service
// 2.1 Import MultipeerConnectivy framework
import Eureka
import RealmSwift

class MyCardViewController: FormViewController {
  
  let realm = try! Realm()
  var card: Card!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    if let myCard = appDelegate?.myCard {
      // Fetch from Realm then assign to self.card
      card = myCard
    } else {
      card = Card()
      card?.uuid = UUID().uuidString
    }
    
    // Do any additional setup after loading the view.
    NameRow.defaultCellUpdate = { cell, row in
      if !row.isValid {
        cell.titleLabel?.textColor = .red
      }
    }
    
    form
      +++ Section("Personal Info")
      <<< ImageRow() {
        $0.title = "Photo"
        $0.value = card.imageData != nil ? UIImage(data: card.imageData!) : nil
        $0.tag = "imageData"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
        }
        .cellUpdate { cell, row in
          if row.value == nil {
            cell.textLabel?.textColor = .red
          }
      }
      <<< NameRow() {
        $0.title =  "First Name"
        $0.placeholder = "Juan"
        $0.value = card.firstName
        $0.tag = "firstName"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
      }
      <<< NameRow() {
        $0.title =  "Last Name"
        $0.placeholder = "Dela Cruiser"
        $0.value = card.lastName
        $0.tag = "lastName"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
      }
      <<< NameRow() {
        $0.title =  "Company"
        $0.placeholder = "DevCon PH"
        $0.value = card.company
        $0.tag = "company"
      }
      +++ Section("Contact Details")
      <<< EmailRow() {
        $0.title = "Email"
        $0.placeholder = "a@b.com"
        $0.value = card.email
        $0.tag = "email"
        $0.add(rule: RuleRequired())
        $0.add(rule: RuleEmail())
        $0.validationOptions = .validatesOnChangeAfterBlurred
        }
        .cellUpdate { cell, row in
          if !row.isValid {
            cell.titleLabel?.textColor = .red
          }
      }
      <<< PhoneRow() {
        $0.title = "Phone"
        $0.placeholder = "+(63) 9291234567"
        $0.value = card.phoneNumber
        $0.tag = "phoneNumber"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
        }
        .cellUpdate { cell, row in
          if !row.isValid {
            cell.titleLabel?.textColor = .red
          }
      }
      <<< URLRow() {
        $0.title = "Website"
        $0.placeholder = "https://devcon.ph"
        $0.value = URL(string: card.website ?? "")
        $0.tag = "website"
      }
      +++ Section()
      <<< ButtonRow() { (row: ButtonRow) -> Void in
        row.title = UserDefaults.standard.string(forKey: "UUID") == nil ? "Save" : "Update"
        row.tag = "btnSave"
        }
        .onCellSelection { cell, row in
          guard let errors = row.section?.form?.validate(), errors.isEmpty else {
            return
          }
          
          // Add to the Realm inside a transaction
          try! self.realm.write {
            if let photoImageRow = self.form.rowBy(tag: "imageData") as? ImageRow,
              let imageData = photoImageRow.value,
              let firstNameRow = self.form.rowBy(tag: "firstName") as? NameRow,
              let lastNameRow = self.form.rowBy(tag: "lastName") as? NameRow,
              let companyRow = self.form.rowBy(tag: "company") as? NameRow,
              let emailRow = self.form.rowBy(tag: "email") as? EmailRow,
              let phoneNumberRow = self.form.rowBy(tag: "phoneNumber") as? PhoneRow,
              let websiteRow = self.form.rowBy(tag: "website") as? URLRow {
              
              let resizedImage = imageData.resizeImage(targetSize: CGSize(width: 500, height: 500))
              self.card.imageData = resizedImage.pngData()
              self.card.firstName = firstNameRow.value!
              self.card.lastName = lastNameRow.value!
              self.card.company = companyRow.value
              self.card.email = emailRow.value!
              self.card.phoneNumber = phoneNumberRow.value!
              self.card.website = websiteRow.value?.absoluteString
              
              self.realm.add(self.card)
              
              UserDefaults.standard.set(self.card.uuid, forKey: "UUID")
              row.title = "Update"
              row.updateCell()
            }
          }
    }
  }

  @IBAction func addCardPressed(_ sender: UIBarButtonItem) {
    let saveButton = form.rowBy(tag: "btnSave")!
    let isFormValid = form.validate().isEmpty
    if saveButton.title == "Save" || !isFormValid {
      let alertController = UIAlertController(title: "",
                                              message: "Please set up your Callicard first",
                                              preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default)
      alertController.addAction(action)
      self.present(alertController, animated: true)
    } else {
      // 2.3 Create an instance oF MCBrowserViewController. Set its delegate
      // and present it to the user. This is a built-in view controller that
      // will let the user select nearby devices
    }
  }
  
  // 4.2 Declare sendCard() function. Call appDelegate.sendCardToPeer()
  // to distribute the user's card to any connected peers. Then call show(message:).
  // In browserViewControllerDidFinish(_:), make sure to call sendCard() before dismissing
  
  func show(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel)
    alertController.addAction(action)
    self.present(alertController, animated: true)
  }
}

// 2.2 Extend MCBrowserViewControllerDelegate protocol

