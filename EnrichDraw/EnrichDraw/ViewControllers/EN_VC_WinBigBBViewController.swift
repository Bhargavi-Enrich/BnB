//
//  EN_VC_WinBigBBViewController.swift
//  PaytmiOSSDK
//
//  Created by Suraj Singh on 23/09/21.
//

import UIKit

class EN_VC_WinBigBBViewController: UIViewController {

    @IBOutlet weak var imgBackgroundImageView: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet private weak var imgEnrichLogo: UIImageView!

    var customerDetails = CustomerDetails()
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    var records = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var originalRecords = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var accessTOKEN: String = ""
    var selectedIndexFromRecordsArray = 0
    var totalEligibleSpinCountsAgainstAllInvoices = 0
    var isScratchCard:SelectedGame = .spinWheel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()
        self.imgBackgroundImageView.isUserInteractionEnabled = true
        self.imgEnrichLogo.isUserInteractionEnabled = true

        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(self.tapImage))
        self.imgBackgroundImageView.addGestureRecognizer(tapGestureImage)
       
        let tapGestureLogo = UITapGestureRecognizer(target: self, action: #selector(self.tapLogo))
        self.imgEnrichLogo.addGestureRecognizer(tapGestureLogo)

        self.setBackgroundImage()
        
    }
    
    func setBackgroundImage(){
        if let logoDetails = self.campaignDetails.campaign_win_bnb_big_image, let urlObj = logoDetails.url {
            self.downloadImage(from: URL(string: urlObj)!)
        }
    }
    
    func downloadImage(from url: URL) {
        self.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imgBackgroundImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
        spinWheelController.originalRecords = self.originalRecords
        spinWheelController.accessToken = self.accessTOKEN
        spinWheelController.selectedIndexFromRecordsArray = self.selectedIndexFromRecordsArray
        spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices

        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }

}

