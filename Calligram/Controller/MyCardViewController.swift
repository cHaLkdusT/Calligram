//
//  CalliCardViewController.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/15/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class MyCardViewController: FormViewController {
  
  var card: Card!
  let realm = try! Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let uuid = UserDefaults.standard.string(forKey: "UUID") {
      // Fetch from Realm then assign to self.card
      card = realm.object(ofType: Card.self, forPrimaryKey: uuid)
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
              
              let resizedImage = imageData.resizeImage(targetSize: CGSize(width: 200, height: 200))
              self.card.imageData = resizedImage.pngData()
              self.card.firstName = firstNameRow.value!
              self.card.lastName = lastNameRow.value!
              self.card.company = companyRow.value
              self.card.email = emailRow.value!
              self.card.phoneNumber = phoneNumberRow.value!
              self.card.website = websiteRow.value?.absoluteString
              
              self.realm.add(self.card)
              
              UserDefaults.standard.set(self.card.uuid, forKey: "UUID")
            }
          }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
