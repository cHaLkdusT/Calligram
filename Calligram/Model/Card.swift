//
//  Card.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/17/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import Foundation
import UIKit

import RealmSwift

class Card: Object, Codable {
  @objc dynamic var uuid = ""
  @objc dynamic var imageData: Data?
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var company: String?
  @objc dynamic var email = ""
  @objc dynamic var phoneNumber = ""
  @objc dynamic var website: String?
  @objc dynamic var accepted = false
  
  override static func primaryKey() -> String? {
    return "uuid"
  }
}
