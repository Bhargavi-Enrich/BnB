//
//  EN_VC_RewardWinnings.swift
//  EnrichDraw
//
//  Created by Suraj Singh on 22/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Foundation

protocol EN_VC_RewardWinningsDelegate:AnyObject {
    func myVCDidFinish(_ controller: EN_VC_RewardWinnings, text: String)
}

class EN_VC_RewardWinnings: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var yourTotalWinningsView: UIView!
    @IBOutlet weak var yourTotalWinningsLabel: UILabel!
    @IBOutlet weak var totalWinningsRewardLabel: UILabel!
    @IBOutlet weak var dropShadowView: UIView!
    @IBOutlet weak var numberOfLeftSpinLabel: UILabel!
    @IBOutlet weak var spinAgainButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: EN_VC_RewardWinningsDelegate?
    
    let totalRewardsPoints = "650 Reward Points"
    let totalSpinLeftString = "You have 3 more spins left" //"All your Reward Points have been added to your Enrich Wallet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.yourTotalWinningsLabel.text = "Your Total Winnings"
        
        let normalText = "You have won a total of "
        let boldText = self.totalRewardsPoints
        let normalTextEnd = " that can be redeemed against beauty services and products"
        let attributedString = NSMutableAttributedString(string:normalText)
        let attributedStringEnd = NSMutableAttributedString(string:normalTextEnd)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
        attributedString.append(attributedStringEnd)
        self.totalWinningsRewardLabel.attributedText = attributedString
        
        self.dropShadowView.backgroundColor = UIColor(rgb: 0x707070).withAlphaComponent(0.50)
        self.numberOfLeftSpinLabel.text = self.totalSpinLeftString
        
        self.collectionView.register(UINib(nibName: "EN_VC_CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EN_VC_CollectionViewCell")
        self.crossButton.addTarget(self, action: #selector(self.dismissPopupScreen), for: .touchUpInside)
        self.spinAgainButton.addTarget(self, action: #selector(self.dismissPopupScreen), for: .touchUpInside)
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EN_VC_CollectionViewCell", for: indexPath) as! EN_VC_CollectionViewCell
        
        cell.configureData(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 4 - 15
        return CGSize(width: size, height: size + 15)
    }
    
    @objc func dismissPopupScreen() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
