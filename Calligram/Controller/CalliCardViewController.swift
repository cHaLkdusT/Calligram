//
//  CalliCardViewController.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/15/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
import Eureka

class CalliCardViewController: FormViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    form
      +++ Section("Personal Info")
      <<< ImageRow() {
        $0.title = "Photo"
      }
      <<< NameRow() {
        $0.title =  "First Name"
        $0.placeholder = "Juan"
      }
      <<< NameRow() {
        $0.title =  "Last Name"
        $0.placeholder = "Dela Cruiser"
      }
      <<< NameRow() {
        $0.title =  "Company"
        $0.placeholder = "15th Team"
      }
      +++ Section("Contact Details")
      <<< EmailRow() {
        $0.title = "Email"
        $0.placeholder = "a@b.com"
      }
      <<< PhoneRow() {
        $0.title = "Phone"
        $0.placeholder = "+(63) 9291234567"
      }
      <<< URLRow() {
        $0.title = "Website"
        $0.placeholder = "https://devcon.ph"
      }
      +++ Section()
      <<< ButtonRow() { (row: ButtonRow) -> Void in
        row.title = "Save"
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
