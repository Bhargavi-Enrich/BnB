//
//  ViewController.swift
//  EnrichWheel
//
//  Modified on 20/08/2018.

//

import UIKit
import PKHUD
class EN_VC_CutomerAuthenticate: UIViewController,UITextFieldDelegate {
    
    let _acceptableCharacters = "0123456789."

    @IBOutlet weak var txtFieldInvoiceNumber: UITextField!
    @IBOutlet weak var txtFieldMobileNumber: UITextField!
    @IBOutlet weak var btnPlace: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgbackground: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    
    @IBOutlet weak var lblInfoMessage: UILabel!
    

    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    
    var isTrial = false

    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()

        // Do any additional setup after loading the view, typically from a nib.
        
        self.initialSetUp()
        
        txtFieldMobileNumber.attributedPlaceholder = NSAttributedString(string: "MOBILE NUMBER",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.4)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        txtFieldInvoiceNumber.resignFirstResponder()
        txtFieldMobileNumber.resignFirstResponder()
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
                            //self?.imgbackground.image = image
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
        
      //  if isTrial {
            lblInfoMessage.text = "SIGN-IN USING MOBILE NUMBER"
            txtFieldInvoiceNumber.isHidden = true
//        }
//        else {
//            lblInfoMessage.text = "Please enter invoice number and your registered mobile number"
//            txtFieldInvoiceNumber.isHidden = false
//        }


        txtFieldInvoiceNumber.setLeftPaddingPoints(10)
        txtFieldMobileNumber.setLeftPaddingPoints(10)
        self.btnPlace.setTitle(storeDetails.storeName ?? "", for: .normal)
        
        self.setLayerToTextField(txtFieldInvoiceNumber)
        self.setLayerToTextField(txtFieldMobileNumber)
        //self.setArrowToTextField(txtFieldMobileNumber)
    }
    
    // MARK :- Set Layer to Text Field
    func setLayerToTextField(_ textField:UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
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
//    //MARK :- Set Arrow Image in Textfield
//    func setArrowToTextField(_ textField:UITextField) {
//        textField.rightViewMode = UITextField.ViewMode.always
//        let imageView = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//        imageView.addTarget(self, action: #selector(pushToNavigate), for: UIControl.Event.touchUpInside)
//        let image = UIImage(named: "greenArrow")
//        imageView.setImage(image, for: UIControl.State.normal)
//        textField.rightView = imageView
//        textField.rightView?.frame = CGRect(x: 0, y: 0, width: 50 , height:50)
//    }
    
    @IBAction func clickToNext(_ sender: Any) {
        pushToNavigate()
    }
    
    // MARK: All Click Action
     func pushToNavigate() {
        self.txtFieldInvoiceNumber.resignFirstResponder()
        self.txtFieldMobileNumber.resignFirstResponder()
        guard let mobileNumber = txtFieldMobileNumber.text else { return }
        
//        if !isTrial {
//            if !invoiceNumber.isEmpty && !mobileNumber.isEmpty {
//
//                    if(mobileNumber.count < 10){
//                        self.showAlert(alertTitle: "Error", alertMessage: "Please enter valid mobile number.")
//                    }
//                    else{
//                        self.authenticateUser()
//                    }
//                }
//                else {
//                    self.showAlert(alertTitle: "Error", alertMessage: "Invoice and Mobile Number is mandatory.")
//                }
//        }
//        else {
            if !mobileNumber.isEmpty {
                if(mobileNumber.count < 10){
                    self.showAlert(alertTitle: "Error", alertMessage: "Please enter valid mobile number.")
                }
                else{
                    self.authenticateUser()
                }
            }
            else {
                self.showAlert(alertTitle: "Error", alertMessage: "Mobile Number is mandatory.")
            }
      //  }
        
    }
    
    //MARK: - AuthenticateUser
    func authenticateUser()
    {
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        // Server Call Code
        let params : [String: Any] = [
            "mobileNo" : txtFieldMobileNumber.text ?? "45115119989511",
            //"invoiceNo" : txtFieldInvoiceNumber.text ?? "",
            //"campaignId" : campaignDetails.entity_id ?? "",
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
                }else{
                    self.showAlert(alertTitle: "ServerError", alertMessage: "Server error. Please contact admin team.")
                }
            }
            else
            {
                // HANDLE SUCCESS
//                if let statusCode:Int = (dictData!["code"] as? Int), statusCode == 412
//                {
//                    HUD.hide()
//                    self.showAlert(alertTitle: "Alert!", alertMessage: dictData!["message"] as! String)
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
                
                let spinWheelController = EN_VC_CutomerOTPVerification.instantiate(fromAppStoryboard: .Main)
                spinWheelController.storeDetails = self.storeDetails
                spinWheelController.campaignDetails = self.campaignDetails
                spinWheelController.userEnterMobileNumber = self.txtFieldMobileNumber.text
                spinWheelController.userEnterInvoiceNumber = self.txtFieldInvoiceNumber.text
                spinWheelController.isTrial = self.isTrial
                self.navigationController?.pushViewController(spinWheelController, animated: true)
            }
            HUD.hide()
        }
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
        
        if (textField == self.txtFieldMobileNumber) {
            let cs = NSCharacterSet.init(charactersIn:self._acceptableCharacters)
            let filtered = string.components(separatedBy: cs as CharacterSet).filter {  !$0.isEmpty }
            let str = filtered.joined(separator: "")
            return (string != str)
        }
        return true
    }
    
    @IBAction func actionBtnPlace(_ sender: Any) {
        // popupAction()
    }
    @IBAction func actionBtnBack(_ sender: Any) {
        self.appDelegate.appLaunch()
    }
    
}

extension EN_VC_CutomerAuthenticate : UIPopoverPresentationControllerDelegate
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

