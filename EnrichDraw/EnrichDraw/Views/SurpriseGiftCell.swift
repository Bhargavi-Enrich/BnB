//
//  SurpriseGiftCell.swift
//  EnrichDraw
//
//  Created by Bhargavi on 03/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class SurpriseGiftCell: UICollectionViewCell {
    
    @IBOutlet weak var lblGiftTitle: UILabel!
    @IBOutlet weak var lblGiftDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {}
    
    func configureCell(gift_details: assured_gift_details) {
        self.lblGiftTitle.text = gift_details.name ?? ""
        self.lblGiftDescription.text = gift_details.description ?? ""
        
        self.lblGiftTitle.isHidden = self.lblGiftTitle.text!.isEmpty ? true : false
        self.lblGiftDescription.isHidden = self.lblGiftDescription.text!.isEmpty ? true : false
    }
}
