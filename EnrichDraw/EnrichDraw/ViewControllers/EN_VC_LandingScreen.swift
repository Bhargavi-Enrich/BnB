//
//  EN_VC_LandingScreen.swift
//  iPadEnrichApp
//
//  Created by Mugdha Mundhe on 8/28/18.
//  Copyright © 2018 ezest. All rights reserved.
//

import UIKit
import PKHUD
import AVFoundation
import MarqueeLabel

struct StoreDetails {
    var participationCount : Int = 0
    var storeId : Int = 0
    var storeName : String?
    var totalRewardsRolled : Int = 0
    var no_of_spin_availed: Int = 0
}

class EN_VC_LandingScreen: UIViewController
{
    // Private
    @IBOutlet private weak var btnPlace: UIButton!
    @IBOutlet private weak var imgEnrichLogo: UIImageView!
    @IBOutlet private weak var imgbackground: UIImageView!
    @IBOutlet private weak var btnTrialSpin: UIButton!
    @IBOutlet private weak var lblNoOfSpins: UILabel!
    @IBOutlet private weak var lblRewardsRolled: UILabel!
    @IBOutlet private weak var bannerAdvertise: UIImageView!

    @IBOutlet private weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblCopyRight: UILabel!
    @IBOutlet private weak var btnRewardSpin: UIButton!
    
    @IBOutlet private weak var lblPoints1: UILabel!
    @IBOutlet private weak var lblPointCount1: UILabel!
    @IBOutlet private weak var lblPoints2: UILabel!
    @IBOutlet private weak var lblPoints3: UILabel!
    @IBOutlet private weak var lblPoints4: UILabel!
    @IBOutlet private weak var lblPoints5: UILabel!
    @IBOutlet private weak var lblPointCount2: UILabel!
    @IBOutlet private weak var lblPointCount3: UILabel!
    @IBOutlet private weak var lblPointCount4: UILabel!
    @IBOutlet private weak var lblCountPoint5: UILabel!
    @IBOutlet private weak var lblSpinCount: UILabel!
    @IBOutlet private weak var lblSpinCursor: UILabel!
    @IBOutlet private weak var lblTotalRewardsRolled: UILabel!
    
    @IBOutlet weak var lblAnimation: MarqueeLabel!
    @IBOutlet private weak var lblDescriptionSpinCount: UILabel!
    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var view3: UIView!
    @IBOutlet private weak var view4: UIView!
    @IBOutlet private weak var view5: UIView!
    @IBOutlet private weak var viewCount: UIView!
    @IBOutlet private weak var viewTotalRewardsRolled: UIView!
    @IBOutlet private weak var lblMinMaxRange: UILabel!
    
    @IBOutlet private weak var animatedUIView: UIStackView!
    @IBOutlet private weak var viewForAllSpins: UIStackView!
    @IBOutlet private weak var lblVersion : UILabel!

    private var bombSoundEffect: AVAudioPlayer?
    private var arrLastFiveSpinDetails = [CustomerSpin]()
    private var isViewInBackground = false
    private var isViewVisible = false
    
    var isdoneCampaignReq = false
    var isdoneStoreReq = false
    var objModelRunningCampaignList = ModelRunningCampaignList()
    var reposStoreSalonServiceCategory: LocalJSONStore<ModelRunningCampaignList> = LocalJSONStore.init(storageType: .cache)

    
    // Idel Screen Parameters
    var idleTimer: Timer!
    let kMaxIdleTimeSeconds = 30.0
    
    // Public
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    let labelSpace = "      "
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()
        setUpScreenUI()
        reposStoreSalonServiceCategory = LocalJSONStore(storageType: .cache, filename:CacheFileNameKeys.k_file_name_Campaign.rawValue, folderName: CacheFolderNameKeys.k_folder_name_Campaign.rawValue)
        self.appDelegate.downloadImagesVideos()
                
        self.animatedUIView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewInBackground = false
        isViewVisible  = true
        resetIdleTimer()
        self.hideLandingScreen()
        viewForAllSpins.isHidden = true
        // API CALL
        campaignAndStoreDetails()
        getStoreDetails()
    }
    
    func campaignAndStoreDetails() {
        if let campaignRunningSelected:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData {
            self.campaignDetails = campaignRunningSelected
//            self.updateImage(imageView: self.imgbackground, imageData: self.campaignDetails.backgroundImage ?? Data(), defaultImageName: "appBackground.png")
//            self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "ImgEnrichNewLogo")
            
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
        }
        
        if let logoDetails = self.campaignDetails.campaign_image, let urlObj = logoDetails.url {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.bannerAdvertise.image = image
                        }
                    }
                }
            }
        }
    
        
        lblMinMaxRange.text = "Ride the Virtuous Cycle and get a change to instantly win upto 10 times your spend!"//"Spin the wheel and get a chance to instantly win \(campaignDetails.min_range ?? 0) to \(campaignDetails.max_range ?? 0) service reward points!"
        
        if let dictData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modeStoreData) as? Dictionary<String, Any>, dictData.count > 0 {
            
            let people_participated = dictData["people_participated"] as? Int
            let store_id = dictData["store_id"] as? Int
            let base_salon_name = dictData["base_salon_name"] as? String
            let total_reward = dictData["total_reward"] as? Int
            let no_of_spin_availed = dictData["no_of_spin_availed"] as? Int


            self.storeDetails = StoreDetails.init(participationCount: people_participated ?? 0, storeId: store_id ?? 0, storeName: base_salon_name?.capitalized, totalRewardsRolled: total_reward ?? 0, no_of_spin_availed: no_of_spin_availed ?? 0 )
        }
        if let entityID = self.campaignDetails.entity_id, !entityID.isEmpty {
    
            self.callAPIs(campaignID: Int64(entityID) ?? 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewVisible = false
        if(self.idleTimer != nil) {
            self.idleTimer.invalidate()
            self.idleTimer = nil
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: (#selector(callAPIs)), object: nil)
        DispatchQueue.main.async {
            self.bombSoundEffect?.volume = 0
            self.bombSoundEffect?.stop()
            self.isViewInBackground = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup UI methods
    
    func hideLandingScreen()
    {
        self.view1.isHidden = true
        self.view2.isHidden = true
        self.view3.isHidden = true
        self.view4.isHidden = true
        self.view5.isHidden = true
    }
    
    //MARK:- UI Setup
    func setUpScreenUI()
    {
        self.btnPlace.setTitle("", for:.normal)
       // btnRewardSpin.setTitle("kl_RewardSpin".relatedStrings([]), for: .normal)
        //btnRewardSpin.setTitle("kl_RewardSpin".localized, for: .normal)
        //btnTrialSpin.setTitle("kl_TrialSpin".localized, for: .normal)
        lblDescriptionSpinCount.text = "kl_UserInfo".localized
        lblRewardsRolled.text = "kl_TotalRewardsRolled".localized
        lblNoOfSpins.text = "kl_NoOfSpins".localized
        
        self.viewCount.layer.cornerRadius = 8
        self.viewTotalRewardsRolled.layer.cornerRadius = 8
        self.lblDescriptionSpinCount.layer.cornerRadius = 12
        self.lblDescriptionSpinCount.layer.masksToBounds = true
        self.navigationController?.isNavigationBarHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn, .repeat], animations: {
            self.lblSpinCursor.alpha = 0
        }) { (isTrue) in
            self.lblSpinCursor.alpha = 1
        }
        
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        self.lblVersion.text = "Version: \(versionNumber) (\(buildNumber))"
    }
    
    func getSixDigitData(amountWon : String) -> String
    {
        var strFinal = amountWon
        let intObj = (6 - amountWon.count) > 0 ? (6 - amountWon.count) : 0
        for _ in 0..<intObj
        {
            strFinal = "0" + strFinal
        }
        return strFinal
    }
    
    func changeCampainText()
    {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn, .repeat], animations: {
                self.lblSpinCursor.alpha = 0
            }) { (isTrue) in
                self.lblSpinCursor.alpha = 1
            }
        }
    }
    
    //MARK:- Functionality
    func changeLabelsOnFiveSpin(index : Int)
    {
        DispatchQueue.main.async {
            
            
            // Set by default 0 pts
            var textContent = ""
            var textString = NSMutableAttributedString(string: textContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Delius-Regular", size: 18)!
                ])
            var textSpinCount = ""
            
            if self.arrLastFiveSpinDetails.count > index && index != -1
            {
                let data : CustomerSpin = self.arrLastFiveSpinDetails[index]
                
                // Amount won data:
                if(data.amountWon.isNumber)
                {
                    textContent = String(format:"%@ Points",String(format:"%@",data.amountWon))

                }
                else
                {
                    textContent = String(format:"%@",String(format:"%@",data.amountWon))
                    
                }
                
                textString = NSMutableAttributedString(string: textContent, attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Delius-Regular", size: 18)!
                    ])
                textString.setColorForText(textForAttribute:textContent , withColor: UIColor(red:0, green:0.58, blue:0.3, alpha:1), withFont: UIFont(name: "Delius-Regular", size: 26)!)
                textString.setColorForText(textForAttribute:" Points" , withColor: UIColor(red:0, green:0.58, blue:0.3, alpha:1), withFont: UIFont(name: "Delius-Regular", size: 14)!)
                textSpinCount = self.getSixDigitData(amountWon: data.id)
            }
            
            switch index {
            case 0:
                
                self.lblPoints1.text  = textContent + " " + textSpinCount
                self.lblPointCount1.text = textSpinCount
            case 1:
                
                self.lblPoints2.text  = textContent + " " + textSpinCount //textString
                self.lblPointCount2.text = textSpinCount
            case 2:
                
                self.lblPoints3.text  = textContent + " " + textSpinCount//textString
                self.lblPointCount3.text = textSpinCount
            case 3:
                
                self.lblPoints4.text  = textContent + " " + textSpinCount //textString
                self.lblPointCount4.text = textSpinCount
            case 4:
                
                self.lblPoints5.text  = textContent + " " + textSpinCount // textString
                self.lblCountPoint5.text = textSpinCount
            default: break
            }
            
            if (!self.lblSpinCount.text!.isEmpty || !self.lblPoints1.text!.isEmpty || !self.lblPoints2.text!.isEmpty || !self.lblPoints3.text!.isEmpty || !self.lblPoints4.text!.isEmpty || !self.lblPoints5.text!.isEmpty || !self.lblTotalRewardsRolled.text!.isEmpty){
                
                self.lblAnimation.speed = .duration(10.0)
                                self.lblAnimation.type = .continuous
                                let text1 = self.lblSpinCount.text! + self.labelSpace + self.lblPoints1.text!
                                let text2 = self.labelSpace + self.lblPoints2.text! + self.labelSpace
                                let text3 = self.lblPoints3.text! + self.labelSpace + self.lblPoints4.text! + self.labelSpace
                                let text4 = self.lblPoints5.text! + self.labelSpace + self.lblTotalRewardsRolled.text! + self.labelSpace
                                self.lblAnimation.text = text1 + text2 + text3 + text4
                
                self.viewForAllSpins.isHidden = false
            }
            
        }
    }
    
    func changeLastFiveSpinData()
    {
        UIView.animate(withDuration: 1.0, delay: 0.0, options:UIView.AnimationOptions.curveEaseOut, animations: {
        }) { (isTrue) in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                // ********* Count View **************
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromTop, .showHideTransitionViews]
                    
                    UIView.transition(with:self.viewCount , duration: 1.0, options: transitionOptions, animations: {
                        self.viewCount.isHidden = true
                    })
                    UIView.transition(with:self.viewTotalRewardsRolled , duration: 1.0, options: transitionOptions, animations: {
                        self.viewTotalRewardsRolled.isHidden = true
                        DispatchQueue.main.async {
//                            self.lblSpinCount.text = self.getSixDigitData(amountWon: String(format:"%d",self.storeDetails.participationCount))
                            self.lblSpinCount.text = "kl_NoOfSpins".localized  + self.storeDetails.no_of_spin_availed.withCommas()
                        }
                    })
                    
                    UIView.transition(with: self.viewCount, duration: 1.0, options: transitionOptions, animations: {
                        self.viewCount.isHidden = true
                        self.changeLabelsOnFiveSpin(index: -1)
                    })
                    
                    UIView.transition(with: self.viewTotalRewardsRolled, duration: 1.0, options: transitionOptions, animations: {
                        self.viewTotalRewardsRolled.isHidden = true
                         DispatchQueue.main.async {
                             self.lblTotalRewardsRolled.text = "kl_TotalRewardsRolled".localized + self.storeDetails.totalRewardsRolled.withCommas() 
                        }
                    })
                    
                    self.firstTileAnimation()
                }
            }, completion: nil)
        }
    }
    
    func animationTiles( view : UIView, index : Int)
    {
        let transitionOptions:UIView.AnimationOptions = [.transitionFlipFromTop, .showHideTransitionViews]
        UIView.transition(with:view , duration: 1.0, options: transitionOptions, animations: {
            view.isHidden = true
        })
    
        UIView.transition(with: view, duration: 1.0, options: transitionOptions, animations: {
            view.isHidden = false
            self.playMusicOnFlip()
            self.changeLabelsOnFiveSpin(index: index)
        })
    }
    
    func firstTileAnimation()
    {
        // ********* 1 **************
        if( self.arrLastFiveSpinDetails.count > 0)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.view1.isHidden = false
                self.animationTiles(view: self.view1, index: 0)
                self.secTileAnimation()
            }
        }
    }
    
    func secTileAnimation()
    {
        if( self.arrLastFiveSpinDetails.count > 1)
        {
            // ********* 2 **************
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.animationTiles(view: self.view2, index: 1)
                self.thirdTileAnimation()
            }
        }
    }
    
    func thirdTileAnimation()
    {
        if( self.arrLastFiveSpinDetails.count > 2)
        {
            // ********* 3 **************
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.animationTiles(view: self.view3, index: 2)
                self.fourthTileAnimation()
            }
        }
    }
    
    func fourthTileAnimation()
    {
        if( self.arrLastFiveSpinDetails.count > 4)
        {
            // ********* 4 **************
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.animationTiles(view: self.view4, index: 3)
                self.fifthTileAnimation()
            }
        }
    }
    
    func fifthTileAnimation()
    {
        if( self.arrLastFiveSpinDetails.count == 5)
        {
            // ********* 5 **************
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                self.animationTiles(view: self.view5, index: 4)
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionBtnPlace(_ sender: Any) {
       popupAction()
    }
    
    @IBAction func actionBtnTermsAndConditions(_ sender: Any) {
    }
    
    @IBAction func actionTrialSpin(_ sender: Any) {
        isViewVisible = false
        isViewInBackground = true
        if self.campaignDetails.entity_id != nil && !(self.storeDetails.storeName ?? "").isEmpty {
            let vc = EN_VC_CutomerAuthenticate.instantiate(fromAppStoryboard: .Main)
            vc.storeDetails = self.storeDetails
            vc.campaignDetails = self.campaignDetails
            vc.isTrial = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            campaignAndStoreDetails()
            self.showAlert(alertTitle: "Alert!", alertMessage: "Campaign details are not available. Please try after some time.")
        }
    }
    
    @IBAction func actionRewardSpin(_ sender: Any) {
        isViewVisible = false
        isViewInBackground = true

        // *********** NETWORK CONNECTION
        if !NetworkRechability.isConnectedToNetwork()
        {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Network connection error")
            return
        }
        
        if self.campaignDetails.entity_id != nil && !(self.storeDetails.storeName ?? "").isEmpty {
            let spinWheelController = EN_VC_TermsAndConditions.instantiate(fromAppStoryboard: .Main)
            spinWheelController.storeDetails = self.storeDetails
            spinWheelController.campaignDetails = self.campaignDetails
            self.navigationController?.pushViewController(spinWheelController, animated: true)
        } else {
            campaignAndStoreDetails()
            self.showAlert(alertTitle: "Alert!", alertMessage: "Campaign details are not available. Please try after some time.")
        }
    }
    
    // MARK:- Play Music When Spin Stops
    func playMusicOnFlip(){
        if(self.isViewInBackground == false)
        {
            let path = Bundle.main.path(forResource: "victory.aac", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                self.bombSoundEffect?.prepareToPlay()
                self.bombSoundEffect?.play()
            } catch {
                // couldn't load file :(
            }
        }
    }
    
}

extension EN_VC_LandingScreen : UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func popupAction() {

        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "Logout", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some action here.
            
            let alertView = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                APICallsManagerClass.shared.appLogOut()
                self.appDelegate.appLaunch()
            })
            alertView.addAction(action)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do something here upon cancellation.
            })
            alertView.addAction(cancelAction)

            self.present(alertView, animated: true, completion: nil)

        })
        
        let deleteAction = UIAlertAction(title: "Settings", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some destructive action here.
            // Go on settings
            DispatchQueue.main.async {
                let spinWheelController = EN_VC_Setting.instantiate(fromAppStoryboard: .Main)
                spinWheelController.campaignDetails  = self.campaignDetails
                self.navigationController?.pushViewController(spinWheelController, animated: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        let selectCampaign = UIAlertAction(title: "Select Campaign", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon selectCampaign.
            
            self.alertControllerBackgroundTapped()
            self.openCampaignSeletionView()
            
            
        })
        
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
        alertController.addAction(selectCampaign)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.btnPlace.frame
        }
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    // MARK: -  openCampaignSeletionView
    func openCampaignSeletionView()
    {
        getCampaignDataFromCache()
        DispatchQueue.main.async {
            let spinWheelController = EN_VC_CampaignList.instantiate(fromAppStoryboard: .Main)
            spinWheelController.objModelRunningCampaignList = self.objModelRunningCampaignList
            self.view.alpha = 0.50
            self.appDelegate.window?.rootViewController!.present(spinWheelController, animated: false, completion: nil)
            spinWheelController.onDoneBlock = { result,model in
                self.alertControllerBackgroundTapped()
                // Do something
                if(result) // Incase user has selected Campaign
                {
                    DispatchQueue.main.async {
                        self.campaignDetails = model
                        self.viewWillAppear(true)
                    }
                }
                else // Incase user has not selected Campaign
                {
                    
                }
                self.view.alpha = 1.0
            }
        }

        
    }
    
    // MARK: -  Handling idle timeout
    
    func resetIdleTimer() {
        if(self.isViewVisible  == true && self.isViewInBackground == false) {
            if !(idleTimer != nil) {
                idleTimer = Timer.scheduledTimer(timeInterval: kMaxIdleTimeSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
            } else {
                if fabs(idleTimer.fireDate.timeIntervalSinceNow) < kMaxIdleTimeSeconds - 1.0 {
                    idleTimer.fireDate = Date(timeIntervalSinceNow: kMaxIdleTimeSeconds)
                }
            }
        }
    }
    @objc func idleTimerExceeded() {
        idleTimer = nil
        self.startScreenSaver()
        resetIdleTimer()
    }
    
    func nextResponder() -> UIResponder
    {
        resetIdleTimer()
        return super.next!
    }
    
    func startScreenSaver () {
        if(self.isViewVisible  == true && self.isViewInBackground == false && (self.appDelegate.gListOfImages ?? []).count > 0) {
            let slideShow = EN_VC_SlideShow.instantiate(fromAppStoryboard: .Main)
             slideShow.modalPresentationStyle = .fullScreen
            self.present(slideShow, animated: false)  {
            }
        }
    }
}

extension EN_VC_LandingScreen
{
//    //MARK: - dummyData
//    func dummyData()
//    {
//
//        if let path = Bundle.main.path(forResource: "CampaignDetails", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                if  let dataOutput = GlobalFunctions.shared.jsonToNSData(json: jsonResult as AnyObject)
//                {
//                    UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: dataOutput, strKey: UserDefaultKeys.modelCampaignDetails)
//                }
//            } catch {
//                // handle error
//            }
//        }
//
//    }
    
    //MARK:- Timer Function
    @objc func callAPIs(campaignID:Int64) {
        
        isdoneCampaignReq = false
        isdoneStoreReq = false
        
        requestToGetCampaignDetails(campaignID: campaignID)
    }
    
    //MARK:- fiveMinTimer
    func fiveMinTimer()
    {
        // set up a delayed call…
        perform(#selector(callAPIs), with: nil, afterDelay: (5*5*60))
    }
    
    //MARK:- requestToGetCampaignDetails
    func requestToGetCampaignDetails(campaignID:Int64)
    {
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)

        EN_Service_AdminCampaign.sharedInstance.getCampaignDetails(campaignId: campaignID, callback: { (errorCode, errorMsg, dictData) in
            HUD.hide()

            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    self.isdoneCampaignReq = true
                    self.checkAllReqDone()

                    print(msg)
                    self.showAlert(alertTitle: "Error", alertMessage: "\(msg)")
                }
                
                
            }else
            {

                // HANDLE SUCCESS
                if let statusCode:Int = (dictData!["code"] as? Int), statusCode == 412
                {
                    self.isdoneCampaignReq = true
                    self.checkAllReqDone()

                    if let msgOf = dictData!["message"] as? String, msgOf ==  "Store does not have any active campaign." {
                        self.showAlert(alertTitle: "Error", alertMessage: "\(msgOf)")
                        return
                    }
                }
                
                if let data = dictData, let dataObj = data["data"] as? [String : Any] {
                    if  let data = GlobalFunctions.shared.jsonToNSData(json: dataObj as AnyObject)
                    {
                        UserDefaultUtility.shared.saveModelObjectToSharedPreferenceCallback(data: data, strKey: UserDefaultKeys.modelCampaignDetails, { (isSuccess) in
                             self.isdoneCampaignReq = true
                            self.checkAllReqDone()
                        })
                    }else{
                         self.isdoneCampaignReq = true
                        self.checkAllReqDone()
                    }
                    
                    self.changeCampainText()

                }
                
            }
        })
    }
    
    func checkAllReqDone() {
        if isdoneCampaignReq && isdoneStoreReq {
            HUD.hide()
        }
    }
    
    func getStoreDetails()
    {
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
//        let userDetails : [String: Any] = UserDefaults.standard.value(forKey: UserDefaultKeys.modelAdminUserIdAndPassword.rawValue) as! [String : Any]
//        var storeId = ""
//
        guard let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let storeIdObj = userDetailsObj.salon_id, !storeIdObj.isEmpty else {
            return
        }
        
//        guard let userDetailsObj = UserDefaults.standard.value(forKey: UserDefaultKeys.modelAdminProfile.rawValue) as? [String : Any], let storeIdObj = userDetailsObj["salon_id"] as? String else {
//            return
//        }
        
        let storeId = "0"//storeIdObj
        DispatchQueue.main.async {
            //self.btnPlace.setTitle((userDetailsObj["base_salon_name"] as! String), for:.normal)
            self.btnPlace.setTitle(userDetailsObj.base_salon_name ?? "My Salon", for:.normal)

        }
        
        EN_Service_GetStoreDetails.sharedInstance.getGetStoreDetails(email: storeId, callback: { (errorCode, errorMsg, dictObj) in
            HUD.hide()
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    self.isdoneStoreReq = true
                    self.checkAllReqDone()
                    print(msg)
                    self.showAlert(alertTitle: "Error", alertMessage: "\(msg)")
                }
            }else
            {
                self.arrLastFiveSpinDetails.removeAll()
                
                if let dictData = dictObj, let dataDataObj = dictData["data"] as? [String : Any] {
                    
                    if let data = dataDataObj["customerSpinDetails"] as? [Dictionary<String,Any>]
                    {
                        for value in data
                        {
                            self.arrLastFiveSpinDetails.append(CustomerSpin.init(id: value["entity_id"] as? String ?? "", amountWon: value["amount_won"] as? String ?? "" , createdDate: value["created_at"] as? String ?? "", invoiceId: (value["invoice_number"] as? String) ?? ""))
                        }
                    }
                    
                    print("self.arrLastFiveSpinDetails : \(self.arrLastFiveSpinDetails)")
                    
                    //((dataDataObj["store_id"] as? Int)!)
                    
                    self.storeDetails = StoreDetails.init(
                        participationCount: (dataDataObj["people_participated"] as? Int)!,
                        storeId: Int(userDetailsObj.salon_id ?? "0") ?? 0,
                        storeName: (userDetailsObj.base_salon_name ?? "My Salon"),
                        totalRewardsRolled: (dataDataObj["total_reward"] as? Int)!,
                        no_of_spin_availed: ((dataDataObj["no_of_spin_availed"] as? Int)!) )
                    
                    
                    // HANDLE SUCCESS
                    print(dictData)
                    if  let data = GlobalFunctions.shared.jsonToNSData(json: dictData as AnyObject)
                    {
                        UserDefaultUtility.shared.saveModelObjectToSharedPreferenceCallback(data: data, strKey: UserDefaultKeys.modeStoreData, { (isSuccess) in
                            self.isdoneStoreReq = true
                            self.checkAllReqDone()
                        })
                    }else{
                        self.isdoneStoreReq = true
                        self.checkAllReqDone()
                    }
                    
                    DispatchQueue.main.async {
                        let appd : AppDelegate = UIApplication.shared.delegate as!AppDelegate
                                                appd.arrLastFiveSpinDetails = self.arrLastFiveSpinDetails
                                                appd.no_of_spin_availed = self.storeDetails.no_of_spin_availed
                                                appd.totalRewardsRolled = self.storeDetails.totalRewardsRolled
                        
                        self.changeLastFiveSpinData()
                    }

                }

            }
            self.fiveMinTimer()
        })
    }
    
    func getCampaignDataFromCache()->Bool
        {
            var havingCachedData:Bool = false
            
            if let repos = reposStoreSalonServiceCategory.storedValue {
                havingCachedData = true
                DispatchQueue.main.async {
                    let obj : ModelRunningCampaignList = repos
                    
                    if ((obj.listOfCampaign ?? []).count > 0) {
                        self.objModelRunningCampaignList = repos
                        
                    }else{
                        self.showAlert(alertTitle: "Alert!", alertMessage: "Campaign list is empty.")
                    }
                }
            }
            return havingCachedData
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
// Image View
extension UIImageView {
    
    func animate(images: [UIImage], index: Int = 0, completionHandler: (() -> Void)?) {
        
        UIView.transition(with: self, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.image = images[index]
            
        }, completion: { value in
            let idx = index == images.count-1 ? 0 : index+1
            
            if idx == 0 {
                completionHandler!()
                
            } else {
                self.animate(images: images, index: idx, completionHandler: completionHandler)
            }
            
        })
    }
    
}






