//
//  EN_VC_AdminAuthentication.swift
//  EnrichWheel
//
//  Modified on 20/08/2018.

//

import UIKit
import PKHUD
class EN_VC_AdminAuthentication: UIViewController,UITextFieldDelegate {
    
    let k_key_UniqueDeviceId = "get_uuid"
    
    @IBOutlet weak var imgViewGif: UIImageView!
    
   
    @IBOutlet weak var txtFieldStoreID: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var lblCopyRight: UILabel!
    
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()

    var reposStoreSalonServiceCategory: LocalJSONStore<ModelRunningCampaignList> = LocalJSONStore.init(storageType: .cache)

    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()

        reposStoreSalonServiceCategory = LocalJSONStore(storageType: .cache, filename:CacheFileNameKeys.k_file_name_Campaign.rawValue, folderName: CacheFolderNameKeys.k_folder_name_Campaign.rawValue)

        self.initialSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        txtFieldStoreID.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
    }
    
    
    // MARK :- Initial SetUp Before View Load
    func initialSetUp()
    {
        self.setLayerToTextField(txtFieldStoreID)
        self.setLayerToTextField(txtFieldPassword)
        //self.setArrowToTextField(txtFieldPassword)
        
        txtFieldStoreID.setLeftPaddingPoints(10)
        txtFieldPassword.setLeftPaddingPoints(10)

    }
    
    // MARK :- resetView
    func resetView()
    {
        self.txtFieldStoreID.text = ""
        self.txtFieldPassword.text = ""
        self.txtFieldStoreID.resignFirstResponder()
        self.txtFieldPassword.resignFirstResponder()
        
    }
    
    // MARK :- Set Layer to Text Field
    func setLayerToTextField(_ textField:UITextField) {
    textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor// UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
    textField.layer.cornerRadius = 15//textField.frame.size.height / 2
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
//
//    }
//
    
    @IBAction func clickToSignIn(_ sender: Any) {
        pushToNavigate()
    }
    
    // MARK: All Click Action
    func pushToNavigate() {
        guard let memberNumber = txtFieldStoreID.text, let password = txtFieldPassword.text else { return }
        if !memberNumber.isEmpty && !password.isEmpty {
//            if EmailValidation.sharedInstance.isValidEmail(testStr: memberNumber) {
               self.authenticateUser()
//            } else {
//                showAlert(alertTitle: "Error", alertMessage: "Email id not valid.")
//            }
           
            
        } else {
            showAlert(alertTitle: "Error", alertMessage: "StoreId and Password is mandatory.")
        }
    }
    
   
    
      // MARK: dummyData
    func dummyData()
    {
        if let path = Bundle.main.path(forResource: "UserAccessToken", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if  let dataOutput = GlobalFunctions.shared.jsonToNSData(json: jsonResult as AnyObject)
                {
                    let userDetails : [String: Any] = [
                        "username":self.txtFieldStoreID.text!,
                        "password":self.txtFieldPassword.text!
                    ]
                    
                    UserDefaults.standard.set(userDetails, forKey:  UserDefaultKeys.modelAdminUserIdAndPassword.rawValue)
                    UserDefaults.standard.synchronize()
                    
                    // Save to User Default Admin ServerData
                    UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: dataOutput, strKey: UserDefaultKeys.modelAdminProfile)
                    
                    
                    let spinWheelController = EN_VC_LandingScreen.instantiate(fromAppStoryboard: .Main)
                    spinWheelController.storeDetails = self.storeDetails
                    self.navigationController?.pushViewController(spinWheelController, animated: true)
                }
            } catch {
                // handle error
            }
        }
    }
    
    //MARK: - AuthenticateUser
    func getDeviceUUID() -> String {
        let uniqueDeviceId: String? = KeychainWrapper.standard.string(forKey: k_key_UniqueDeviceId)

        guard uniqueDeviceId != nil else {
            let uuid = generateUuid()
            let saveSuccessful: Bool = KeychainWrapper.standard.set(uuid, forKey: k_key_UniqueDeviceId)
            if saveSuccessful {
                return uuid
            }
            else {
                fatalError("Unable to save uuid")
            }
        }
        return uniqueDeviceId!
    }

    private func generateUuid() -> String {

        let uuidRef: CFUUID = CFUUIDCreate(nil)
        let uuidStringRef: CFString = CFUUIDCreateString(nil, uuidRef)
        return uuidStringRef as String
    }
    

    func authenticateUser() {
        
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        self.txtFieldStoreID.resignFirstResponder()
        self.txtFieldPassword.resignFirstResponder()
        let device_id = self.getDeviceUUID()

        // Server Call Code
        let params : [String: Any] = [
//            "username":txtFieldStoreID.text!,
//            "password": txtFieldPassword.text!,
//            "client_id": "client",
//            "client_secret": "enrich@2018",
//            "grant_type":"password"
            
            "username":txtFieldStoreID.text!,
            "password": txtFieldPassword.text!,
            "is_custom": true,
            "device_id": device_id,
            "accept_terms":true
        ]
        
        EN_Service_AdminLogin.sharedInstance.authenticateAdmin(params) { (errorCode, errorMsg, dictData) in
            HUD.hide()

            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                }
                else{
                    self.showAlert(alertTitle: "Alert!", alertMessage: "Invalid user name and password.")
                }
            }else
            {
                // HANDLE SUCCESS
                if let statusCode:Int = (dictData!["code"] as? Int), statusCode == 412
                {
                    self.showAlert(alertTitle: "Alert!", alertMessage: dictData!["message"] as! String)
                    return
                }
                
                    let userDetails : [String: Any] = [
                        "username":self.txtFieldStoreID.text!,
                        "password":self.txtFieldPassword.text!
                    ]
                    UserDefaults.standard.set(userDetails, forKey:  UserDefaultKeys.modelAdminUserIdAndPassword.rawValue)
                    UserDefaults.standard.synchronize()
                    
                    // Save to User Default Admin ServerData
                    if let dictObj = dictData, let dataObj = dictObj["data"] as? [String : Any] {
                        //UserDefaults.standard.set(dataObj, forKey: UserDefaultKeys.modelAdminProfile.rawValue)
                        //UserDefaults.standard.synchronize()
                        if  let data = GlobalFunctions.shared.jsonToNSData(json: dataObj as AnyObject)
                        {
                            UserDefaultUtility.shared.saveModelObjectToSharedPreferenceCallback(data: data, strKey: UserDefaultKeys.modelAdminProfile, { (isSuccess) in
                                self.getListOfRunningCampaign()

                            })
                        }
                    }
                
                

                    // Retrive From  User Default
//                    let people = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile)
//                    dump("Model values \(people)")
                    
            }
        }
    }

    
    //MARK: - getListOfRunningCampaign
    func getListOfRunningCampaign() {
        
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        EN_Service_CampaignList.sharedInstance.getCampaignList(callback: { (errorCode, errorMsg, dictData) in
            if errorCode != 0 {
                // HANDLE ERROR
                if let msg = errorMsg {
                    print(msg)
                    self.showAlert(alertTitle: "Error", alertMessage: "\(msg)")
                }
            }else {
                // HANDLE SUCCESS
                if let statusCode:Int = (dictData!["code"] as? Int), statusCode == 412 {
                    if let msgOf = dictData!["message"] as? String, msgOf ==  "Store does not have any active campaign." {
                        return
                    }
                }
                
                if let dataObj = dictData, let dataAnObj1 = dataObj["data"] as? [String : Any], let data = GlobalFunctions.shared.jsonToNSData(json: dataAnObj1 as AnyObject) {
                    do{
                        let responseObject = try JSONDecoder().decode(ModelRunningCampaignList.self, from: data)
//                        if let dataObj = responseObject.data {
                            self.reposStoreSalonServiceCategory.save(responseObject)
//                        }
                    }catch
                    {
                        print(error)
                    }
                }
                if (self.getCampaignDataFromCache()){}
            }
            HUD.hide()
        })
    }

    //MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -200, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -200, up: false)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EN_VC_AdminAuthentication
{
    func getCampaignDataFromCache()->Bool
    {
        var havingCachedData:Bool = false
        
        if let repos = reposStoreSalonServiceCategory.storedValue {
            havingCachedData = true
            DispatchQueue.main.async {
                let obj : ModelRunningCampaignList = repos
                
                if ((obj.listOfCampaign ?? []).count > 0) {
                    self.campaignDetails = ((obj.listOfCampaign ?? []).first)!
                    let encodedData = try? JSONEncoder().encode(self.campaignDetails)
                    UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: encodedData!, strKey: UserDefaultKeys.modelRunningCampaingSelected)

                    let spinWheelController = EN_VC_LandingScreen.instantiate(fromAppStoryboard: .Main)
                  spinWheelController.objModelRunningCampaignList = repos
                    spinWheelController.storeDetails = self.storeDetails
                    spinWheelController.campaignDetails = self.campaignDetails
                    self.navigationController?.pushViewController(spinWheelController, animated: false)
                    
                }else{
                    self.showAlert(alertTitle: "Alert!", alertMessage: "Campaign list is empty.")
                }
            }
        }
        return havingCachedData
}
 }
