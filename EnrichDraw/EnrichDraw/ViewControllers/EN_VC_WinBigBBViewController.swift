//
//  EN_VC_WinBigBBViewController.swift
//  PaytmiOSSDK
//
//  Created by Suraj Singh on 23/09/21.
//

import UIKit

class EN_VC_WinBigBBViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet private weak var imgEnrichLogo: UIImageView!

    var customerDetails = CustomerDetails()
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    var records = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var accessTOKEN: String = ""
    var selectedIndexFromRecordsArray = 0
    var totalEligibleSpinCountsAgainstAllInvoices = 0
    var isScratchCard:SelectedGame = .spinWheel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()
        self.imageView.isUserInteractionEnabled = true
        self.imgEnrichLogo.isUserInteractionEnabled = true

                let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(self.tapImage))
                self.imageView.addGestureRecognizer(tapGestureImage)
       
        let tapGestureLogo = UITapGestureRecognizer(target: self, action: #selector(self.tapLogo))
        self.imgEnrichLogo.addGestureRecognizer(tapGestureLogo)

    }
    
   
    
    @objc func tapImage(){
            openRewardSpinScreen()
        }
    @objc func tapLogo(){
        self.navigationController?.popViewController(animated: true)
        }
    func openRewardSpinScreen() {
        let spinWheelController = EN_VC_RewardSpin.instantiate(fromAppStoryboard: .Main)
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.isScratchCard = .spinWheel
        spinWheelController.campaignDetails = self.campaignDetails
        spinWheelController.records = self.records
        spinWheelController.accessToken = self.accessTOKEN
        spinWheelController.selectedIndexFromRecordsArray = self.selectedIndexFromRecordsArray
        spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices

        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }

}

