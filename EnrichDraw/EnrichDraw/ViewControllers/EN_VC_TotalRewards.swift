//
//  EN_VC_TotalRewards.swift
//  EnrichDraw
//
//  Created by Mugdha on 05/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreMedia
import PKHUD

struct CustomerSpin
{
    var id : String = ""
    var amountWon : String = ""
    var createdDate : String = ""
    var invoiceId : String = ""
}

struct TotalRewards
{
    var customerSpin : [CustomerSpin]?
    var totalRewards : String = ""
}

struct RecycleRewards {
    var rewardName : String = ""
    var rewardValue : String = ""
}

enum TrophyColors : String{
    case clrRoyalBlue = "RoyalBlueTrophyImg"
    case clrYellow = "YellowTrophyImg"
    case clrGreen = "GreenTrophyImg"
    case clrViolet = "VioletTrophyImg"
    case clrOrange = "OrangeTrophyImg"
    case clrAqua = "AquaTrophyImg"
    case clrRed = "RedTrophyImg"
    case clrSkyBlue = "SkyblueTrophyImg"
    case clrPink = "PinkTrophyImg"
    case clrWhite = ""
}

class EN_VC_TotalRewards: UIViewController {
    
    private let urlIpad = Bundle.main.url(forResource: "enrichmov1", withExtension: "m4v")
    private var playerLayer = AVPlayerLayer()
    private var player = AVPlayer()
    
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var btnBack: UIButton!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblAmount: UILabel!
    @IBOutlet private weak var collectionTotalRewards: UICollectionView!
    @IBOutlet private weak var lblTwoMore: UILabel!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgLeftbackground: UIImageView!
    @IBOutlet private weak var imgRightbackground: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    
    @IBOutlet weak var recycleTableView: UITableView!
    
    
    @IBOutlet weak var recycleView: UIView!
    
    private var totalRewardsCount : Double = 0.0
    private var totalData = TotalRewards()
    
    var recycleRewards = [RecycleRewards]()
    
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    
    var customerDetails = CustomerDetails()
    var dictRewardsArray = [Int : SpinDetails]()
    
    var isTrial = true
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblCopyRight.text = self.getCopyRight()
        hideRecycleView(status: true)
        getTotalRewards()
        //getRecycleRewards()
        self.btnBack.setTitle(storeDetails.storeName ?? "", for: .normal)
        
        recycleTableView.register(UINib(nibName: "RecycleItemCell", bundle: nil), forCellReuseIdentifier: "RecycleItemCell")
        recycleTableView.separatorColor = .clear
        
        if let campaignRunningSelected:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData {
            self.campaignDetails = campaignRunningSelected
            
            if let logoDetails = self.campaignDetails.campaign_left_background_image, let urlObj = logoDetails.url {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imgLeftbackground.image = image
                            }
                        }
                    }
                }
            }
            
            if let logoDetails = self.campaignDetails.campaign_right_background_image, let urlObj = logoDetails.url {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imgRightbackground.image = image
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
            
            //            self.updateImage(imageView: self.imgbackground, imageData: self.campaignDetails.campaign_left_background_image ?? Data(), defaultImageName: "appBackground.png")
            //            self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // playTheIRSoftTrailer(urlIpad!)
        NotificationCenter.default.addObserver(self, selector: #selector(EN_VC_TotalRewards.dismissVideoScreen), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
    
    //MARK:- Setup screen
    func setUpScreenUI()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        let textContent = "kl_WonMsg1".localized + "kl_WonMsgTotal".localized + "\(String(format:"%.0f",self.totalRewardsCount))" + "kl_RedeemMsg".localized
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14)!
        ])
        textString.setColorForText(textForAttribute:textContent , withColor: UIColor.black , withFont: UIFont(name: "Montserrat-Regular", size: 14)!)
        textString.setColorForText(textForAttribute:String(format:"%.0f",self.totalRewardsCount) , withColor: UIColor.black , withFont: UIFont(name: "Montserrat-Regular", size: 24)!)
        self.lblDescription.attributedText  = textString
        
        self.lblTwoMore.attributedText = returnAttributedString(textContext: self.lblTwoMore.text ?? "")
        
        self.collectionTotalRewards.reloadData()
    }
    
    func returnAttributedString(textContext:String)-> NSMutableAttributedString
    {
        let textString = NSMutableAttributedString(string: textContext, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 18)!])
        textString.setColorForText(textForAttribute:String(format: "two" ) , withColor: UIColor(red:239/255, green:41/255, blue:118/255, alpha:1), withFont: UIFont(name: "Montserrat-Regular", size: 18)!)
        
        return textString
    }
    
    
    
    //MARK: Video
    func playTheIRSoftTrailer(_ movieURL : URL) {
        
        let playerItem = AVPlayerItem(url: movieURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        self.view.layer.addSublayer(playerLayer)
        
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        //allows other apps to keep playing audio files
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        player.play()
    }
    
    @objc func dismissVideoScreen() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        }) { (isTrue) in
            // Fade in
            self.view.alpha = 0.5
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.alpha = 1
                DispatchQueue.main.async {
                    self.setUpScreenUI()
                    self.view.alpha = 1
                    self.playerLayer.removeFromSuperlayer()
                    NotificationCenter.default.removeObserver(self)
                }
            }, completion: nil)
        }
    }
    
    // MARK:- IBActions
    
    @IBAction func actionBtnKnowMore(_ sender: Any)
    {
        //        let knowMore = EN_VC_KnowMore.instantiate(fromAppStoryboard: .Main)
        //        knowMore.storeDetails = self.storeDetails
        //        knowMore.campaignDetails = self.campaignDetails
        //        knowMore.totalRewards = String(format:"%.0f",self.totalRewardsCount)
        //        self.navigationController?.pushViewController(knowMore, animated: true)
        self.navigationController?.popToVC(ofKind: EN_VC_LandingScreen.self)
        
    }
    
    @IBAction func actionBtnBack(_ sender: Any) {
        //popupAction()
    }
}

extension EN_VC_TotalRewards : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictRewardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TotalRewardsCollectionViewCell
        
        let spinData = dictRewardsArray[indexPath.row]
        
        let cell : TotalRewardsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TotalRewardsCollectionViewCell", for: indexPath) as! TotalRewardsCollectionViewCell
        cell.layer.cornerRadius = 7
        cell.lblSpinName.text = self.description(int: indexPath.row)
        if((spinData?.amountSelected.isNumber)!)// Amount Won is Integer
        {
            let textContent = String(format:"%@ Points",spinData?.amountSelected ?? "")
            let textString = NSMutableAttributedString(string: textContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!
            ])
            textString.setColorForText(textForAttribute:String(format:"%@",spinData?.amountSelected ?? "") , withColor: UIColor.darkGray , withFont: UIFont(name: "Montserrat-Regular", size: 18)!)
            cell.lblSpinAmount.attributedText = textString
        }
        else
        {
            let textContent = String(format:"%@",spinData?.amountSelected ?? "")
            let textString = NSMutableAttributedString(string: textContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 16)!
            ])
            textString.setColorForText(textForAttribute:String(format:"%@",spinData?.amountSelected ?? "") , withColor: UIColor.darkGray , withFont: UIFont(name: "Montserrat-Regular", size: 18)!)
            cell.lblSpinAmount.attributedText = textString
        }
        
        
        
        cell.imgRewardColor.image = UIImage(named: "plantWithBackgound")// self.nameOfColor(strName: spinData?.clrSelected ?? ""))
        return cell
    }
    
    // Animation of UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromTop, .showHideTransitionViews]
        
        UIView.transition(with:cell , duration: 1.0, options: transitionOptions, animations: {
            cell.isHidden = true
        })
        
        UIView.transition(with: cell, duration: 1.0, options: transitionOptions, animations: {
            cell.isHidden = false
        })
    }
}

extension EN_VC_TotalRewards : UIPopoverPresentationControllerDelegate
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

extension EN_VC_TotalRewards
{
    func description( int : Int) -> String
    {
        return "You Won"
        
        switch int {
        case 0 :
            return "First spin"
        case 1 :
            return "Second spin"
        case 2 :
            return "Third spin"
        case 3 :
            return "Fourth spin"
        case 4 :
            return "Fifth spin"
        case 5 :
            return "Sixth spin"
        case 6 :
            return "Seventh spin"
        case 7 :
            return "Eighth spin"
        case 8 :
            return "Nineth spin"
        default:
            break
        }
        return ""
    }
    
    func nameOfColor(strName : String) -> String
    {
        switch strName {
            
        case SpinColors.clrRoyalBlue.rawValue:
            return TrophyColors.clrRoyalBlue.rawValue
            
        case SpinColors.clrYellow.rawValue:
            return TrophyColors.clrYellow.rawValue
            
        case SpinColors.clrGreen.rawValue:
            return TrophyColors.clrGreen.rawValue
            
        case SpinColors.clrViolet.rawValue:
            return TrophyColors.clrViolet.rawValue
            
        case SpinColors.clrOrange.rawValue:
            return TrophyColors.clrOrange.rawValue
            
        //white color remaining
        case SpinColors.clrAqua.rawValue:
            return TrophyColors.clrAqua.rawValue
            
        case SpinColors.clrRed.rawValue:
            return TrophyColors.clrRed.rawValue
            
        case SpinColors.clrSkyBlue.rawValue:
            return TrophyColors.clrSkyBlue.rawValue
            
        case SpinColors.clrPink.rawValue:
            return TrophyColors.clrPink.rawValue
        default:
            return TrophyColors.clrWhite.rawValue
        }
    }
    
    func setRecycleRewardData(dict : Dictionary<String, Any>?) {
        recycleRewards.removeAll()
        
        // Customer spin data
        if let dictData = dict, let dataDataObj = dictData["data"] as? [String : Any] {
            if let rewardDetails = dataDataObj["recycle_products"] as? [Dictionary<String,Any>]
            {
                rewardDetails.forEach {
                    if let reward = $0["product_name"] as? String, let value = $0["reward_points"] as? String
                    {
                        self.recycleRewards.append(RecycleRewards(rewardName: reward, rewardValue: value))
                    }
                }
            }
            hideRecycleView(status: recycleRewards.isEmpty)
            recycleTableView.reloadData()
        }
    }
    
    func setData(dict : Dictionary<String, Any>?)
    {
        var arrCustomer = [CustomerSpin]()
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
        }
    }
    
    func getTotalRewards()
    {
        let params : [String: Any] = [
            "invoiceNo" : customerDetails.invoiceNo ?? "",
            "customerId" : customerDetails.customerId ?? "",
            "campaignId": campaignDetails.entity_id ?? "",
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
                    self.setRecycleRewardData(dict: dictData)
                    print(dictData ?? "Data available")
                }
                HUD.hide()
        })
    }
    
    func getRecycleRewards()
    {
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        EN_Service_TotalRewards.sharedInstance.getRecycleRewards(customerId: "\(customerDetails.customerId ?? 0)", callback: { (errorCode, errorMsg, dictData) in
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
                self.setRecycleRewardData(dict: dictData)
                print(dictData ?? "Data available")
            }
            HUD.hide()
        })
    }
    
    func hideRecycleView(status: Bool) {
        recycleTableView.isHidden = status
        recycleView.isHidden = status
    }
    
}


extension EN_VC_TotalRewards: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recycleRewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecycleItemCell") as? RecycleItemCell else {
            return UITableViewCell()
        }
        let data = recycleRewards[indexPath.row]
        cell.configureCell(title: data.rewardName, value: data.rewardValue, isHeader: false)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecycleItemCell") as? RecycleItemCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: "You bring", value: "You earn", isHeader: true)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}
