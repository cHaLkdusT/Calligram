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
    
    if let uuid = UserDefaults.standard.string(forKey: "UUID") {
      let predicate = NSPredicate(format: "uuid != %@", uuid)
      cards = realm.objects(Card.self).filter(predicate).map{ $0 }
      tableView.reloadData()
    }
    
    self.tableView.rowHeight = 90
    self.tableView.tableFooterView = UIView()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  // MARK: - Table view data source
  
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
    if let imageData = card.imageData {
      cell.imgPhoto.image = UIImage(data: imageData)
    }
    cell.setRoundedProfile()
    
    return cell
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
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
