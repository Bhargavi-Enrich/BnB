//
//  RecycleItemCell.swift
//  EnrichDraw
//
//  Created by Harshal on 18/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RecycleItemCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(title: String, value: String, isHeader: Bool) {
        if isHeader {
            lblTitle.font = UIFont(name: "Delius-Regular", size: 20)
            lblValue.font = UIFont(name: "Delius-Regular", size: 20)
        }
        else {
            lblTitle.font = UIFont(name: "Montserrat-Regular", size: 14)
            lblValue.font = UIFont(name: "Montserrat-Regular", size: 14)
        }
        lblTitle.text = title
        lblValue.text = value
    }
    
}
