//
//  ViewController.swift
//  EnrichWheel
//
//  Modified on 20/08/2018.

//

import UIKit
import PKHUD
struct CustomerDetails {
    var customerName : String?
    var customerId: Int?
    var invoiceNo : String?
    var amount : Double?
    var noOfSpins : Int?
    var invoiceType : String?
    //    var customerSpinDetails: [CustomerSpin?]
    var remainingSpins : Int = 0
    var remaining_invoice_amount : Double?
    
    var remaining_trials : Int = 0
    var trial_display_name : String?
    var no_of_trials: Int?
    var trial_reward_points : Int = 0
}

class EN_VC_CutomerOTPVerification : UIViewController,UITextFieldDelegate {
    
    let _acceptableCharacters = "0123456789."
    
    @IBOutlet weak var btnPlace: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtFieldOTP: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnResentOTP: UIButton!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgbackground: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!

    var customerDetails = CustomerDetails()
    
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    
    var userEnterMobileNumber:String?
    var userEnterInvoiceNumber:String?
    
    var isTrial = true

    
    var pageNo = 1
    var totalRecords:Int64 = 0
    var records = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var originalRecords = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var selectedIndexFromRecordsArray = 0
    var accessTOKEN: String = ""
    var totalEligibleSpinCountsAgainstAllInvoices = 0

    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()

        // Do any additional setup after loading the view, typically from a nib.
        self.initialSetUp()
        if isTrial {
            callCustomerInfo()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        txtFieldOTP.resignFirstResponder()
    }
    // MARK :- Initial SetUp Before View Load
    func initialSetUp()
    {
//        self.updateImage(imageView: self.imgbackground, imageData: self.campaignDetails.backgroundImage ?? Data(), defaultImageName: "appBackground.png")
//        self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "")
        
        if let logoDetails = self.campaignDetails.campaign_background_image, let urlObj = logoDetails.url {
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imgbackground.image = image
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


        txtFieldOTP.setLeftPaddingPoints(10)
        self.btnPlace.setTitle(storeDetails.storeName ?? "", for: .normal)
        
        self.txtFieldOTP.delegate = self
        self.setLayerToTextField(txtFieldOTP)
//        self.setArrowToTextField(txtFieldOTP)
        
        let textContent = "Please Enter OTP That We Sent On \n Your Registered Mobile Number " + self.userEnterMobileNumber!
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: FontName.FuturaPTBook, size:25)
            ])
        textString.setColorForText(textForAttribute: self.userEnterMobileNumber!, withColor: UIColor.black, withFont: UIFont(name: FontName.FuturaPTDemi, size:25)!)
        self.lblDescription.textColor = UIColor.darkGray
        self.lblDescription.attributedText  = textString
    }
    
    // MARK :- Set Layer to Text Field
    func setLayerToTextField(_ textField:UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
    }
    
//    //MARK :- Set Arrow Image in Textfield
//    func setArrowToTextField(_ textField:UITextField) {
//        textField.rightViewMode = UITextField.ViewMode.always
//        let imageView = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//        imageView.addTarget(self, action: #selector(pushToNavigate), for: UIControl.Event.touchUpInside)
//        let image = UIImage(named: "greenArrow")
//        imageView.setImage(image, for: UIControl.State.normal)
//        textField.rightView = imageView
//        textField.rightView?.frame = CGRect(x: 0, y: 0, width: 50 , height:50)
//
//    }
    
    @IBAction func clickToConfirm(_ sender: Any) {
        pushToNavigate()
    }
    // MARK: All Click Action
     func pushToNavigate() {
        self.txtFieldOTP.resignFirstResponder()
        guard let otpNumber = txtFieldOTP.text else { return }
        if !otpNumber.isEmpty  {
            // Server Call Code
            if(otpNumber.count < 4)
            {
                self.showAlert(alertTitle: "Error", alertMessage: "Please enter valid OTP.")
            }
            else
            {
//                self.openOptionAlert()
                self.authenticateCustomer()
            }
        } else {
            self.showAlert(alertTitle: "Error", alertMessage: "OTP is mandatory.")
        }
    }

    @IBAction func actionBtnBack(_ sender: Any) {
        self.appDelegate.appLaunch()
    }
    @IBAction func actionResendOTP(_ sender: Any) {
        
            self.btnResentOTP.isEnabled = false
            self.btnResentOTP.setTitleColor(UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0), for: .normal)
        
            Timer.scheduledTimer(withTimeInterval: 20, repeats: false) {
                [weak self]timer in
                self?.btnResentOTP.isEnabled = true
                self?.btnResentOTP.setTitleColor(UIColor(red: 250/255, green: 24/255, blue: 100/255, alpha: 1.0), for: .normal)
            }

        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        // Server Call Code
        let params : [String: Any] = [
            
            // Old Request
//            "invoiceNo":userEnterInvoiceNumber ?? "00",
//            "mobileNo":userEnterMobileNumber ?? "45115119989511",
//            "storeId":self.storeDetails.storeId,
//            "campaignId" : self.campaignDetails.id!,
//            "isResendOTP":true
           
            // New Request
            "mobileNo" : userEnterMobileNumber ?? "45115119989511",
           // "invoiceNo" : userEnterInvoiceNumber ?? "",
           // "campaignId" : campaignDetails.entity_id ?? "",
            "is_custom" : true
        ]
        EN_Service_Customer.sharedInstance.authenticateCustomerWithInvoiceAndMobile(params) { (errorCode, errorMsg, dictData) in
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                }
            }
            else
            {
                // HANDLE SUCCESS
//                if let statusCode:Int = (dictData!["code"] as? Int), statusCode == 412
//                {
//                    HUD.hide()
//                    self.showAlert(alertTitle: "Alert!", alertMessage: dictData!["message"] as! String)
//
//                    return
//                }
                
                if let status = (dictData?["status"] as? Bool),
                    status == false,
                    let message = dictData?["message"] as? String
                {
                    HUD.hide()
                    self.showAlert(alertTitle: "Alert!", alertMessage: message)
                    return
                }
               
            }
            HUD.hide()
        }
    }
    
@IBAction func actionBtnPlace(_ sender: Any) {
       // popupAction()
    }
   
    //MARK: - KeyBoard Handling Methods
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -200, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -200, up: false)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.isEmpty) {
            return true
        }
        
        if (textField == self.txtFieldOTP) {
            let cs = NSCharacterSet.init(charactersIn:self._acceptableCharacters)
            let filtered = string.components(separatedBy: cs as CharacterSet).filter {  !$0.isEmpty }
            let str = filtered.joined(separator: "")
            return (string != str)
        }
        
        return true
    }
}

extension EN_VC_CutomerOTPVerification : UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func popupAction() {
        let ac = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            APICallsManagerClass.shared.appLogOut()
            self.appDelegate.appLaunch()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            // Do nothing
        }))
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: ((UIApplication.shared.keyWindow?.bounds.width)! - 100), y: 33, width: 64, height: 25)
        present(ac, animated: true)
    }
}

extension EN_VC_CutomerOTPVerification
{
    func callCustomerInfo()
    {
//        if let campaignConfig:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelCampaignDetails) as? ModelRunningCampaignList
            
          if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
        {
            // Server Call Code
            
            HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
            
            let params : [String: Any] = [
                // Old Request
//                "invoiceNo":self.userEnterInvoiceNumber, //"123145",
//                "threshold":  String(format:"%d",(campaignConfig.campaignDetails?.campaignThreshold)!)
                
                // New Request
                "invoiceNo" : self.userEnterInvoiceNumber ?? "",
                "mobileNo" : userEnterMobileNumber ?? "45115119989511",
                "threshold" : campaignConfig.threshold ?? "",
                "campaignId": campaignConfig.entity_id ?? "",
                "is_custom" : true
            ]
            
            EN_Service_InvoiceDetails.sharedInstance.getInvoiceDetails(params) { (errorCode, errorMsg, dictData) in
                
                HUD.hide()
                if errorCode != 0
                {
                    // HANDLE ERROR
                    if let msg = errorMsg
                    {
                        print("ErrorMessage: \(msg)")
                        
                        self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                    }
                }else
                {
                    // Old Parsing
//                    self.customerDetails = CustomerDetails.init(customerName: dictData?["customerName"] as? String, invoiceNo: dictData?["invoiceNo"] as? String, amount: dictData?["amount"] as? Double, noOfSpins: dictData?["noOfSpins"] as? Int, invoiceType:dictData?["invoiceType"] as? String, remainingSpins: (dictData?["remainingSpins"] as? Int) ?? 0)
                    
                    // new Parsing
                    if let status = (dictData?["status"] as? Bool),
                        status == false,
                        let message = dictData?["message"] as? String
                    {
                        HUD.hide()
                        self.showAlert(alertTitle: "Alert!", alertMessage: message)
                        return
                    }
                    
                    if let jsonData = dictData?["data"] as? [String:Any] {
                        self.customerDetails = CustomerDetails.init(
                            customerName: jsonData["customer_name"] as? String,
                            customerId: jsonData["customer_id"] as? Int,
                            invoiceNo: jsonData["invoice_number"] as? String,
                            amount: jsonData["amount"] as? Double,
                            noOfSpins: jsonData["no_of_spins"] as? Int,
                            invoiceType: jsonData["invoiceType"] as? String,
                            remainingSpins: (jsonData["remaining_spins"] as? Int) ?? 0,
                            remaining_invoice_amount: jsonData["remaining_invoice_amount"] as? Double,
                            remaining_trials: (jsonData["remaining_trials"] as? Int) ?? 0,
                            trial_display_name: jsonData["trial_display_name"] as? String,
                            no_of_trials: (jsonData["no_of_trials"] as? Int) ?? 0,
                            trial_reward_points: (jsonData["trial_reward_points"] as? Int) ?? 0)
                    }
                    
                    // HANDLE SUCCESS
                    if  let data = GlobalFunctions.shared.jsonToNSData(json: dictData as AnyObject)
                    {
                        // Save to User Default Admin ServerData
                        UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: data, strKey: UserDefaultKeys.modeInvoiceDetails)
                    }
                }
            }
        }
        
        
        
    }
    
    func gotoMyorderScreen(accessToken: String) {
       /* let vc = EN_VC_MyOrders.instantiate(fromAppStoryboard: .Main)
        vc.accessToken = accessToken
        vc.campaignDetails = self.campaignDetails
        vc.storeDetails = self.storeDetails
        self.navigationController?.pushViewController(vc, animated: true)*/
        pageNo = 1
        totalRecords = 0
        accessTOKEN = accessToken
        getOrdersData(pageNo: pageNo, accessToken: accessToken)
    
    }
    
    //MARK: - authenticateCustomer

    func authenticateCustomer()
    {
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        // Server Call Code
        let params : [String: Any] = [
            //"invoiceNo":userEnterInvoiceNumber ?? "",
            "otpValue":self.txtFieldOTP.text ?? "12345",
            "mobileNo": userEnterMobileNumber ?? "",
            "device_notification_token":"",
            "device_type" : "iOS",
            "is_custom" : true
        ]
        
        EN_Service_Customer.sharedInstance.validateOtp(params) { (errorCode, errorMsg, dictData) in
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                }
            }
            else
            {
                // HANDLE SUCCESS
                if let statusCode : Bool = dictData!["status"] as? Bool, statusCode == false
                {
                    HUD.hide()
                    self.showAlert(alertTitle: "Alert!", alertMessage: dictData!["message"] as! String)
                    return
                }
                
                if self.isTrial {
                    if( self.customerDetails.remaining_trials > 0){
                        self.openTrialSpin()
                    }
                    else
                    {
                        self.showAlert(alertTitle: "Alert!", alertMessage: "kl_ErrorNoTrials".localized)
                    }
                }else {
                    if let data = dictData!["data"] as? [String: Any], let accessToken = data["access_token"] as? String {
                        self.gotoMyorderScreen(accessToken: accessToken)
                        return
                    }
                    else {
                        HUD.hide()
                        self.showAlert(alertTitle: "Alert!", alertMessage: dictData!["message"] as! String)
                        return
                    }
                }
            }
            HUD.hide()
        }
    }
    
    func openTrialSpin() {
        let spinWheelController = EN_VC_TrialSpin.instantiate(fromAppStoryboard: .Main)
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.isScratchCard = .spinWheel
        spinWheelController.campaignDetails = self.campaignDetails
        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }

    func openRewardsSpin() {
        
        let scratchDetails = GlobalFunctions.shared.getCardTypeScratchOrSpin()
        if scratchDetails.isCampainAvail{
            
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
            
        }else{

            let spinWheelController = EN_VC_RewardSpin.instantiate(fromAppStoryboard: .Main)
            spinWheelController.customerDetails = self.customerDetails
            spinWheelController.storeDetails = self.storeDetails
//            spinWheelController.isScratchCard = selectedGame
            spinWheelController.campaignDetails = self.campaignDetails
            spinWheelController.records = self.records
            spinWheelController.originalRecords = self.originalRecords
            spinWheelController.accessToken = self.accessTOKEN
            spinWheelController.selectedIndexFromRecordsArray = self.selectedIndexFromRecordsArray
            spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices

            self.navigationController?.pushViewController(spinWheelController, animated: true)

//            if let objPopUp = CustomPopUpUserData.loadFromNibNamed(nibNamed: "CustomPopUpUserData") as? CustomPopUpUserData {
//                objPopUp.frame = self.view.frame
//                objPopUp.delegate = self
//                self.appDelegate.window?.rootViewController!.view.addSubview(objPopUp)
//            }
        }
    }
}

extension EN_VC_CutomerOTPVerification : CustomPopUpUserDataDelegate {
    func selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame) {
        let spinWheelController = EN_VC_RewardSpin.instantiate(fromAppStoryboard: .Main)
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.isScratchCard = selectedGame
        spinWheelController.campaignDetails = self.campaignDetails
        spinWheelController.records = self.records
        spinWheelController.originalRecords = self.originalRecords
        spinWheelController.accessToken = self.accessTOKEN
        spinWheelController.selectedIndexFromRecordsArray = self.selectedIndexFromRecordsArray
        spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices

        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }
}

//MARK : My Orders Function
extension EN_VC_CutomerOTPVerification
{
    
    func getOrdersData(pageNo: Int, accessToken: String) {
        
        self.selectedIndexFromRecordsArray = 0
        guard let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let storeIdObj = userDetailsObj.salon_id, !storeIdObj.isEmpty else {
            return
        }
        
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        
        let params : [String: Any] = [
            "limit" : 50,
            "is_bnb" : true,
            "salon_id" : storeIdObj,
            "page" : pageNo,
            "is_custom" : true,
            "campaign_start_date" : "\(campaignDetails.start_date ?? "00:00:00")" + " 00:00:00",
            "campaign_end_date" : "\(campaignDetails.end_date ?? "00:00:00")" + " 00:00:00"
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
        
        //records.append(contentsOf: model.orders ?? [])
        records.append(contentsOf: finalFilteredRecords(model: model))
        originalRecords.append(contentsOf: finalFilteredRecords(model: model))
        if !records.isEmpty
        {
            actionPlaySpinGame(indexPath:IndexPath.init(row: self.selectedIndexFromRecordsArray, section: 0))
        }
        else
        {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Sorry, you dont have any spins to play. Please do spend more and win more spins.")
            
            
        }
    }
    
    func finalFilteredRecords(model: MyProductOrdersModuleModel.GetMyOrders.MyOrdersData) -> [MyProductOrdersModuleModel.GetMyOrders.Orders]
    {
        var recordsNew = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
        totalEligibleSpinCountsAgainstAllInvoices = 0
        if let orders = model.orders, !orders.isEmpty {
            recordsNew.removeAll()
            for element in orders
            {
               if  let spinDetails =  element.greenrich?.spin_details, !spinDetails.isEmpty, let spinFirst = spinDetails.first, let spinCount = spinFirst.remaining_spins, spinCount > 0 {
                    totalEligibleSpinCountsAgainstAllInvoices = totalEligibleSpinCountsAgainstAllInvoices + spinCount
                    recordsNew.append(element)
            }
            
        }
    
    }
        return recordsNew
    }
    
    
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

            openWinBigScreen()
            
        }
        else {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Customer id is missing")
        }
        
    }
    
    
    func openWinBigScreen() {
        let destination = EN_VC_WinBigBBViewController(nibName: "EN_VC_WinBigBBViewController", bundle: nil)
        destination.customerDetails = self.customerDetails
        destination.storeDetails = self.storeDetails
        destination.isScratchCard = .spinWheel
        destination.campaignDetails = self.campaignDetails
        destination.records = self.records
        destination.originalRecords = self.originalRecords
        destination.accessTOKEN = self.accessTOKEN
        destination.selectedIndexFromRecordsArray = self.selectedIndexFromRecordsArray
        destination.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    
}
