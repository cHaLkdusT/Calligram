//
//  ContactsTableViewController.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/17/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class ContactsTableViewController: UITableViewController {
  
  let realm = try! Realm()
  var cards = [Card]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadContacts()
    
    // Step 5. Receiving card data from the peer
    // 5.1 Subscribe to .CalliDataReceivedNotification
    NotificationCenter
      .default
      .addObserver(self,
                   selector: #selector(ContactsTableViewController.dataReceived(notification:)),
                   name: .CalliDataReceivedNotification,
                   object: nil)
    
    tableView.rowHeight = 90
    tableView.tableFooterView = UIView()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showContactDetails" {
      let navVC = segue.destination as? UINavigationController
      let cdVC = navVC?.viewControllers.first as? ContactDetailsViewController
      cdVC?.card = sender as? Card
      cdVC?.contactListVC = self
    }
  }
  
  func loadContacts() {
    if let uuid = UserDefaults.standard.string(forKey: "UUID") {
      let predicate = NSPredicate(format: "uuid != %@", uuid)
      cards = realm.objects(Card.self).filter(predicate).map{ $0 }
      tableView.reloadData()
      
      let pendingPredicate = NSPredicate(format: "uuid != %@ AND accepted == %@", uuid, NSNumber(booleanLiteral: false))
      let pendingCards = realm.objects(Card.self).filter(pendingPredicate).map{ $0 }
      if !pendingCards.isEmpty {
        navigationController?.tabBarItem.badgeValue = "\(pendingCards.count)"
      } else {
        navigationController?.tabBarItem.badgeValue = nil
      }
    }
  }
  
  // 5.3 Add dataReceived(notification:), which is called when the
  // notification is received. Inside it, we refresh the contact list by
  // calling loadContacts()
  @objc func dataReceived(notification: Notification) {
    loadContacts()
  }
  
  // 5.2 To unregister from observing the notification, override `deinit`
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - Table view data source
extension ContactsTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cards.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
    
    // Configure the cell...
    let card = cards[indexPath.item]
    cell.lblName.text = "\(card.firstName) \(card.lastName)"
    cell.lblCompany.text = card.company
    if let imageData = card.imageData, card.accepted {
      cell.imgPhoto.image = UIImage(data: imageData)
    } else {
      cell.imgPhoto.image = UIImage(named: "twotone_priority_high_black_36pt")
    }
    cell.setRoundedProfile()
    
    return cell
  }
}

extension ContactsTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let card = cards[indexPath.row]
    self.performSegue(withIdentifier: "showContactDetails", sender: card)
  }
}

extension ContactsTableViewController: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "No contacts to show"
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 18.0),
      .foregroundColor: UIColor.darkGray
    ]
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return UIImage(named: "twotone_perm_contact_calendar_black_48pt")!
  }
}
