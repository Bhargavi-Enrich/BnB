//
//  EN_VC_RewardWinnings.swift
//  EnrichDraw
//
//  Created by Suraj Singh on 22/09/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Foundation
import PKHUD

protocol EN_VC_RewardWinningsDelegate:AnyObject {
    func actionCloseClick()
    func actionSpinAgain()

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
    var customerDetails = CustomerDetails()
    var campaignDetails = ModelRunningCampaignListData()

    weak var delegate: EN_VC_RewardWinningsDelegate?
    
    var totalRewardsPoints = 0
    var totalSpinLeftString = 0
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.yourTotalWinningsLabel.text = "Your Total Winnings"
            
            let normalText = "You have won a total of "
            let boldText = "\(self.totalRewardsPoints)"
            let normalTextEnd = " Reward Points that can be redeemed against beauty services and products"
            let attributedString = NSMutableAttributedString(string:normalText)
            let attributedStringEnd = NSMutableAttributedString(string:normalTextEnd)
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
            attributedString.append(boldString)
            attributedString.append(attributedStringEnd)
            self.totalWinningsRewardLabel.attributedText = attributedString
            
            self.dropShadowView.backgroundColor = UIColor(rgb: 0x707070).withAlphaComponent(0.50)
            self.spinAgainButton.setBackgroundImage(UIImage(named: "enableButton"), for: .normal)
            if(self.totalSpinLeftString > 0){
                self.numberOfLeftSpinLabel.text = "You have \(self.totalSpinLeftString) more spins left"
                
                self.spinAgainButton.setTitle("SPIN AGAIN  >", for: .normal)
            }else{
                self.numberOfLeftSpinLabel.text = "All your Reward Points have been added to your Enrich Wallet"
                
                self.spinAgainButton.setTitle("CLOSE  >", for: .normal)
            }
            
            
            self.collectionView.register(UINib(nibName: "EN_VC_CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EN_VC_CollectionViewCell")
            self.crossButton.addTarget(self, action: #selector(self.dismissPopupScreenCrossClick), for: .touchUpInside)
            self.spinAgainButton.addTarget(self, action: #selector(self.dismissPopupScreenSpinAgainOrClose), for: .touchUpInside)
            
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTotalRewards()
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
    
    @objc func dismissPopupScreenCrossClick() {
        self.dismiss(animated: false) {
            self.delegate?.actionCloseClick()
        }
    }
    
    @objc func dismissPopupScreenSpinAgainOrClose() {
        self.dismiss(animated: false) {
            self.delegate?.actionSpinAgain()
        }
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

extension EN_VC_RewardWinnings {
    
    func getTotalRewards()
    {
        let params : [String: Any] = [
//            "invoiceNo" : customerDetails.invoiceNo ?? "",
            "customerId" : customerDetails.customerId ?? "",
            "campaignId": campaignDetails.entity_id ?? "",
            "campaign_start_date" : "\(campaignDetails.start_date ?? "00:00:00")",
            "is_custom" : true]
        
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        
        EN_Service_TotalRewards.sharedInstance.getTotalRewards(
            userData: params, callback: { (errorCode, errorMsg, dictData) in
                if errorCode != 0
                {
                    // HANDLE ERROR
                    if let msg = errorMsg
                    {
                        print(msg)
                        self.showAlert(alertTitle: "Error", alertMessage: "\(msg)")
                    }
                }else
                {
                    self.setData(dict: dictData)
                    print(dictData ?? "Data available")
                }
                HUD.hide()
        })
    }
    
    func setData(dict : Dictionary<String, Any>?)
    {
        /*var arrCustomer = [CustomerSpin]()
        self.totalRewardsCount = 0.0
        // Total Rewards
        if let value:String = dict?["totalRewards"] as? String
        {
            self.totalRewardsCount = Double(value)!
        }
        
        // Customer spin data
        if let dictData = dict, let dataDataObj = dictData["data"] as? [String : Any] {
            if let dictionary = dataDataObj["customerSpinDetails"] as? [Dictionary<String,Any>]
            {
                if let arrCustomerSpinDetails = dictionary as? Array<[String : Any]>{
                    for (index,dictObj) in arrCustomerSpinDetails.enumerated()
                    {
                        if let value:String = dictObj["amountWon"] as? String
                        {
                            if(value.isNumber)
                            {
                                self.totalRewardsCount = self.totalRewardsCount + Double(value)! //Old code
                            }
                        }
                        
                        arrCustomer.append(CustomerSpin.init(id: dictObj["customer_id"] as? String ?? "", amountWon: String(dictObj["amount_won"] as? String ?? "") , createdDate: dictObj["created_at"] as? String ?? "", invoiceId: (dictObj["invoiceId"] as? String) ?? ""))
                        
                        if(dictRewardsArray[index] != nil)
                        {
                            let spinData = dictRewardsArray[index]
                            self.dictRewardsArray[index] = SpinDetails.init(clrSelected: (spinData?.clrSelected)! , amountSelected: String(dictObj["amountWon"] as? String ?? ""), spinNo: index, invoiceNo:(dictObj["invoiceId"] as? String) ?? "" )
                        }else{
                            self.dictRewardsArray[index] = SpinDetails.init(clrSelected: GlobalFunctions.shared.getRandonColor() , amountSelected: String(dictObj["amountWon"] as? String ?? ""), spinNo: index, invoiceNo:(dictObj["invoiceId"] as? String) ?? "" )
                        }
                        
                    }
                }
            }
        }
        
        
        
        totalData = TotalRewards.init(customerSpin: arrCustomer, totalRewards: String(format:"%.0f",self.totalRewardsCount))
        
        // Show on UI
        DispatchQueue.main.async {
            
            self.setUpScreenUI()
            
            let textContent = String(format:"%.0f",self.totalRewardsCount)
            let textString = NSMutableAttributedString(string: textContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!
            ])
            textString.setColorForText(textForAttribute:String(format:"%.0f",self.totalRewardsCount) , withColor: UIColor.white , withFont: UIFont(name: "Montserrat-Semibold", size: 34)!)
            self.lblAmount.attributedText = textString
            
            self.collectionTotalRewards.reloadData()
            self.collectionTotalRewards.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                self.totalRewardsCount = 0.0
                for (_,model)in self.dictRewardsArray.enumerated()
                {
                    if(model.value.amountSelected.isNumber)
                    {
                        self.totalRewardsCount = self.totalRewardsCount + Double(model.value.amountSelected)!
                    }
                    
                    print("self.totalRewardsCount : ",self.totalRewardsCount)
                    
                    self.setUpScreenUI()
                    
                    
                }
                let textContent = String(format:"%.0f",self.totalRewardsCount)
                let textString = NSMutableAttributedString(string: textContent, attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!
                ])
                textString.setColorForText(textForAttribute:String(format:"%.0f",self.totalRewardsCount) , withColor: UIColor.white , withFont: UIFont(name: "Montserrat-Semibold", size: 34)!)
                self.lblAmount.attributedText = textString
            })
        }*/
    }
}
