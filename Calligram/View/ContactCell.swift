//
//  ContactCell.swift
//  Calligram
//
//  Created by Chalk Lundang on 7/17/19.
//  Copyright © 2019 CHLKDST. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
  
  @IBOutlet weak var imgPhoto: UIImageView!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblCompany: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setRoundedProfile() {
    imgPhoto.layer.cornerRadius = (imgPhoto.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
    imgPhoto.layer.masksToBounds = true
  }
}
