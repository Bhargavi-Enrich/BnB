//
//  EN_VC_WinBBPopupCollectionViewCell.swift
//  PaytmiOSSDK
//
//  Created by Suraj Singh on 23/09/21.
//

import UIKit

class EN_VC_WinBBPopupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    var imageArray = ["Layer 1_offer", "Layer 2_offer", "Layer 3_offer", "Layer-4_offer", "Layer 5_offer", "Layer 6_offer"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(_ indexPath : IndexPath){
        self.imageView.image = UIImage(named: self.imageArray[indexPath.row])
    }
    
}
