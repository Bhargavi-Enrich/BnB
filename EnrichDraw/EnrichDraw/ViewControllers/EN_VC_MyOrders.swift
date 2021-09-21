//
//  EN_VC_MyOrders.swift
//  EnrichDraw
//
//  Created by Harshal on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import PKHUD

class EN_VC_MyOrders: UIViewController {
        
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCopyRights: UILabel!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet weak var imgAppBackground: UIImageView!
    
    var campaignDetails = ModelRunningCampaignListData()
    var accessToken = ""
    
    var pageNo = 1
    var totalRecords:Int64 = 0
    
    var customerDetails = CustomerDetails()
    var storeDetails = StoreDetails()
    
    var records = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        orderTableView.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "MyOrderCell")
        orderTableView.separatorColor = .clear
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageNo = 1
        totalRecords = 0
        getOrdersData(pageNo: pageNo)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Shall we redirect to home page?", message: "Please confirm", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { (action) in
            self.appDelegate.appLaunch()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            // Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUI() {
        
        if let campaignRunningSelected:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData {
            
            self.campaignDetails = campaignRunningSelected
            
            if let logoDetails = self.campaignDetails.campaign_background_image, let urlObj = logoDetails.url {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imgAppBackground.image = image
                            }
                        }
                    }
                }
            }
            
            if let logoDetails = self.campaignDetails.campaign_logo, let urlObj = logoDetails.url {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imgViewBBLogo.image = image
                            }
                        }
                    }
                }
            }
        }
        
        self.lblPlace.text = ""
        
        if let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile {
            self.lblPlace.text = userDetailsObj.base_salon_name ?? "My Salon"
        }
    }
    
    func getOrdersData(pageNo: Int) {
        
        guard let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let storeIdObj = userDetailsObj.salon_id, !storeIdObj.isEmpty else {
            return
        }
        
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        
        let params : [String: Any] = [
            "limit" : 5,
            "is_bnb" : true,
            "salon_id" : storeIdObj,
            "page" : pageNo,
            "is_custom" : true
        ]
        
        EN_Service_Customer.sharedInstance.getMyOrders(params, accessToken: accessToken) { (errorCode, errorMsg, dictData) in
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    HUD.hide()
                    self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                }
            }
            else
            {
                HUD.hide()
                if let status = (dictData?["status"] as? Bool),
                    status == false,
                    let message = dictData?["message"] as? String
                {
                    self.showAlert(alertTitle: "Alert!", alertMessage: message)
                    return
                }
                            
                if let jsonData = dictData?["data"] as? [String:Any] {
                    do {
                        let object = try DictionaryDecoder().decode(MyProductOrdersModuleModel.GetMyOrders.MyOrdersData.self, from: jsonData)
                        self.configureData(model: object)
                        
                    } catch let e {
                        print("ERROR: \(e)")
                    }
                }
            }
        }
    }
    
    func configureData(model: MyProductOrdersModuleModel.GetMyOrders.MyOrdersData) {
        if pageNo == 1 {
            records.removeAll()
        }
        totalRecords = model.total_number ?? 0
        records.append(contentsOf: model.orders ?? [])
        self.orderTableView.reloadData()
    }
    
    func configureCustomerData(customerData: MyProductOrdersModuleModel.GetMyOrders.SpinDetails) {
        
        if let id = customerData.customer_id,
            let customerId = id.description.toInt() {
            self.customerDetails = CustomerDetails.init(
            customerName: customerData.customer_name ?? "",
            customerId: customerId,
            invoiceNo: customerData.invoice_number ?? "",
            amount: customerData.amount,
            noOfSpins: customerData.no_of_spins,
            invoiceType: "",
            remainingSpins: customerData.remaining_spins ?? 0,
            remaining_invoice_amount: customerData.remaining_invoice_amount ?? 0,
            remaining_trials: customerData.remaining_trials ?? 0,
            trial_display_name: customerData.trial_display_name ?? "Trial",
            no_of_trials: customerData.no_of_trials ?? 0,
            trial_reward_points: customerData.trial_reward_points ?? 0)
            
            openRewardSpinScreen()
            
        }
        else {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Customer id is missing")
        }
        
    }
    
    func openRewardSpinScreen() {
        let spinWheelController = EN_VC_RewardSpin.instantiate(fromAppStoryboard: .Main)
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.isScratchCard = .spinWheel
        spinWheelController.campaignDetails = self.campaignDetails
        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }
    
}

extension EN_VC_MyOrders : MyOrderDelegate {
    
    func actionPlaySpinGame(indexPath: IndexPath) {
        let model = records[indexPath.row]
        
        let selectedCampaign = model.greenrich?.applicable_campaigns?.first {
            $0.entity_id == campaignDetails.entity_id
        }
        
        if selectedCampaign != nil,
            let spinDetails = model.greenrich?.spin_details,
            !spinDetails.isEmpty,
            let customerData = spinDetails.first {
            print("Done")
            self.configureCustomerData(customerData: customerData)
        }else {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Selected campaign is not applicable for current invoice. Please selected another campaign")
            return
        }
    }
}

extension EN_VC_MyOrders : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as? MyOrderCell else {
            return UITableViewCell()
        }
        let model = records[indexPath.row]
        cell.delegate = self
        cell.configureCell(model: model, indexPaths: indexPath, selectedCampaign: self.campaignDetails)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (records.count - 1) && records.count < totalRecords {
            pageNo += 1
            getOrdersData(pageNo: pageNo)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

class DictionaryDecoder {
    
    private let decoder = JSONDecoder()
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }
    
    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }
    
    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }
    
    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}
