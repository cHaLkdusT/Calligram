//
//  Notification+Name.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/20/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import Foundation

// Step 3. Sending Data
// 3.1 Create Notification.Name for us subscribe events
// Using Notification.Name, we no longer need to define string constants in a project.
// The solution has become much easier, more elegant, and in line with Swift's API design.
extension Notification.Name {
  static let CalliDataReceivedNotification = Notification.Name("CalliDataReceivedNotification")
}

