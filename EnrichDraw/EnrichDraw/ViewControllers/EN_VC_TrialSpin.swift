//
//  EN_VC_TrialSpin.swift
//  EnrichProj
//
//  Created by Mugdha on 29/08/18.
//  Copyright © 2018 Mugdha. All rights reserved.
//

import UIKit
import AVFoundation
import MarqueeLabel
class EN_VC_TrialSpin: UIViewController {
    
    @IBOutlet weak var constraintColorViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var bannerAdvertise: UIImageView!

    @IBOutlet weak var btnPlace: UIButton!
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
   // @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgRightBackground: UIImageView!
    @IBOutlet weak var imgEnrich: UIImageView!
    
    @IBOutlet weak var viewRightPane: UIView!
    @IBOutlet weak var viewSpinWheel: UIView!
    @IBOutlet weak var viewForColorSelection: UIView!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var btnAddColors: UIButton!
    
    var isScratchCard:SelectedGame = .spinWheel
    
    // Color Buttons
    @IBOutlet weak var btnBlue: UIButton!
    @IBOutlet weak var btnViolet: UIButton!
    @IBOutlet weak var btnPurple: UIButton!
    @IBOutlet weak var btnRed: UIButton!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnAqua: UIButton!
    @IBOutlet weak var btnOrange: UIButton!
    @IBOutlet weak var btnIndigo: UIButton!
    
    @IBOutlet private weak var lblSpinCount: UILabel!
    @IBOutlet private weak var lblTotalRewardsRolled: UILabel!
    @IBOutlet private weak var lblPoints1: UILabel!
    @IBOutlet private weak var lblPoints2: UILabel!
    @IBOutlet private weak var lblPoints3: UILabel!
    @IBOutlet private weak var lblPoints4: UILabel!
    @IBOutlet private weak var lblPoints5: UILabel!
    @IBOutlet private weak var lblNumberOfSpinYouHave: UILabel!
    
    private var arrLastFiveSpinDetails = [CustomerSpin]()
    private var isViewInBackground = false
    private var isViewVisible = false
    
    //@IBOutlet weak var lblBillNo: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
   // @IBOutlet weak var lblBillAmount: UILabel!
    @IBOutlet weak var lblNoOfTrials: UILabel!
    @IBOutlet weak var collectionSpin: UICollectionView!
    
    @IBOutlet weak var lblHashTrial: UILabel!
    
    @IBOutlet weak var lblRemainingTrials: UILabel!
    @IBOutlet weak var lblRemainingTrialsCount: UILabel!
    
    @IBOutlet weak var lblRecyclingInfo: UILabel!
    @IBOutlet private weak var animatedUIView: UIStackView!
    var dictRewardsArray = [Int : SpinDetails]()
    var currentSpinNumber:Int = 0
    
    var customerDetails = CustomerDetails()
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    
    var bombSoundEffect: AVAudioPlayer?
    var previousColorIndex = 1
    
    var remainingLocalTrialCount = 0
    var totalCount = 0
    let appd:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var totalEligibleSpinCountsAgainstAllInvoices = 0
    @IBOutlet weak var lblAnimation: MarqueeLabel!
    let labelSpace = "      "

    @IBOutlet weak var btnWinBigThisSeason: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideColorSection()
        self.lblCopyRight.text = self.getCopyRight()
        //self.checkScratchCardOrSpin()
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        lblRecyclingInfo.text = campaignDetails.recycle_message ?? ""
        self.initialialize()
        
        self.arrLastFiveSpinDetails = appd.arrLastFiveSpinDetails
        self.changeLastFiveSpinData()
        
        self.appd.totalEligibleSpinCountsAgainstAllInvoices = self.customerDetails.remaining_trials
        totalEligibleSpinCountsAgainstAllInvoices = self.customerDetails.remaining_trials
        self.updateSpinLeft(leftSpins: totalEligibleSpinCountsAgainstAllInvoices)
        self.animatedUIView.isHidden = true
    }
    
    //MARK:- Functionality
    func changeLabelsOnFiveSpin()
    {
        DispatchQueue.main.async {
            if(self.arrLastFiveSpinDetails.count > 0){
                let textCount = self.getSixDigitData(amountWon: self.arrLastFiveSpinDetails[0].id)
                self.lblPoints1.text = self.arrLastFiveSpinDetails[0].amountWon + " Points " + textCount
            }
            if (self.arrLastFiveSpinDetails.count > 1){
                let textCount = self.getSixDigitData(amountWon: self.arrLastFiveSpinDetails[1].id)
                self.lblPoints2.text = self.arrLastFiveSpinDetails[1].amountWon + " Points " + textCount
            }
            if (self.arrLastFiveSpinDetails.count > 2){
                let textCount = self.getSixDigitData(amountWon: self.arrLastFiveSpinDetails[2].id)
                self.lblPoints3.text = self.arrLastFiveSpinDetails[2].amountWon + " Points " + textCount
            }
            if (self.arrLastFiveSpinDetails.count > 3){
                let textCount = self.getSixDigitData(amountWon: self.arrLastFiveSpinDetails[3].id)
                self.lblPoints4.text = self.arrLastFiveSpinDetails[3].amountWon + " Points " + textCount
            }
            if (self.arrLastFiveSpinDetails.count > 4){
                let textCount = self.getSixDigitData(amountWon: self.arrLastFiveSpinDetails[4].id)
                self.lblPoints5.text = self.arrLastFiveSpinDetails[4].amountWon + " Points " + textCount
            }
            
            
            if (!self.lblSpinCount.text!.isEmpty || !self.lblPoints1.text!.isEmpty || !self.lblPoints2.text!.isEmpty || !self.lblPoints3.text!.isEmpty || !self.lblPoints4.text!.isEmpty || !self.lblPoints5.text!.isEmpty || !self.lblTotalRewardsRolled.text!.isEmpty){
                
                self.lblAnimation.speed = .duration(10.0)
                self.lblAnimation.type = .continuous
                let text1 = self.lblSpinCount.text! + self.labelSpace + self.lblPoints1.text!
                let text2 = self.labelSpace + self.lblPoints2.text! + self.labelSpace
                let text3 = self.lblPoints3.text! + self.labelSpace + self.lblPoints4.text! + self.labelSpace
                let text4 = self.lblPoints5.text! + self.labelSpace + self.lblTotalRewardsRolled.text! + self.labelSpace
                self.lblAnimation.text = text1 + text2 + text3 + text4
            }
            
        }
    }
    
    func changeLastFiveSpinData()
    {
        self.lblSpinCount.text = self.getSixDigitData(amountWon: String(format:"%d",appd.no_of_spin_availed)) + " " + "kl_NoOfSpins".localized
        
        self.lblTotalRewardsRolled.text = appd.totalRewardsRolled + " " + "kl_TotalRewardsRolled".localized
        
        self.changeLabelsOnFiveSpin()
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
    
    func openPopUpForSelection(){
        if let objPopUp = CustomPopUpUserData.loadFromNibNamed(nibNamed: "CustomPopUpUserData") as? CustomPopUpUserData {
            objPopUp.lastSelectedGame = isScratchCard
            objPopUp.frame = self.view.frame
            objPopUp.delegate = self
            self.appDelegate.window?.rootViewController!.view.addSubview(objPopUp)
        }
    }
    
    func checkScratchCardOrSpin(){
        
        //        if self.storeDetails.storeId == 0 || campaignDetails.id == nil {
        //            showErrorPopUpBackToLanding()
        //        }
        //        let scratchDetails = GlobalFunctions.shared.getCardTypeScratchOrSpin()
        //        if scratchDetails.isCampainAvail{
        //            isScratchCard = .spinWheel
        //        }else{
        openPopUpForSelection()
        //        }
    }
    func showErrorPopUpBackToLanding(){
        let alert = UIAlertController(title: "Alert", message: "Please logout and do relogin once. There may be store or campaign details issue.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popToVC(ofKind: EN_VC_LandingScreen.self)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK :- Initial SetUp Before View Load
    func initialialize() {
        
        if let logoDetails = self.campaignDetails.campaign_right_background_image, let urlObj = logoDetails.url {
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imgRightBackground.image = image
                        }
                    }
                }
            }
        }
        
        /*if let logoDetails = self.campaignDetails.campaign_logo, let urlObj = logoDetails.url {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imgEnrich.image = image
                        }
                    }
                }
            }
        }*/
        
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
        
       // self.lblBillNo.text = self.customerDetails.invoiceNo ?? ""
        self.lblCustomerName.text = self.customerDetails.customerName ?? ""
        //self.lblBillAmount.text = "₹ \(String(format: "%2.0f",self.customerDetails.amount ?? 0.0))"
        
        let remaining = self.customerDetails.remaining_trials
        let noOfTrials = self.customerDetails.no_of_trials ?? 0
        self.totalCount = remaining + noOfTrials
        remainingLocalTrialCount = remaining
        
        self.lblNoOfTrials.text = "\(self.totalCount)"
        self.lblRemainingTrials.isHidden = false
        self.lblRemainingTrialsCount.isHidden = false
        let takenCount = self.totalCount - self.remainingLocalTrialCount
        self.lblRemainingTrialsCount.text = "\(takenCount)"
        
        self.btnPlace.setTitle(self.storeDetails.storeName ?? "", for: .normal)
        
        for index in 0..<( self.customerDetails.remaining_trials )
        {
            self.dictRewardsArray[index] = SpinDetails.init(clrSelected: GlobalFunctions.shared.getRandonColor() , amountSelected: "", spinNo: index, invoiceNo:self.customerDetails.invoiceNo ?? "" )
        }
                
        self.collectionSpin.reloadData()
        
        
        titleForGame()
        self.btnPlace.setTitle(storeDetails.storeName ?? "", for: .normal)
        btnContinue.setTitle("kl_BtnContNextTitle".localized, for: .normal)
        btnAddColors.setTitle("kl_ColorTitle".localized, for: .normal)
        openSelectedGame(selectedGame: .spinWheel)
        
        hideAllColorButtons()
        
        self.btnWinBigThisSeason.setTitle("WIN BIG\nTHIS SEASON", for: .normal)
        self.btnWinBigThisSeason.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.btnWinBigThisSeason.titleLabel!.numberOfLines = 0
        self.btnWinBigThisSeason.contentHorizontalAlignment = .center
        self.btnWinBigThisSeason.contentVerticalAlignment = .center
    }
    
    func titleForGame() {
        lblName.text = "kl_Description".relatedStrings(isScratchCard)
    }
    
    public func hideColorSection(){
        self.viewForColorSelection.isHidden = true
    }
    
    public func showColorSection(){
        self.viewForColorSelection.isHidden = false
    }
    
    //MARK:- Add And Remove SpinWheel
    func addSpinWheel(selectedColor:Int) {
        self.playMusicWhenSpinAppears()
        
        let spinWheelController = EN_VC_SpinWheel.instantiate(fromAppStoryboard: .Main)
        spinWheelController.isScratchCard = self.isScratchCard
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.campaignDetails = self.campaignDetails
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.isTrialOrRewardSpin = true
        spinWheelController.controller = self
        spinWheelController.dictRewardsArray = self.dictRewardsArray
        spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices
        spinWheelController.currentSpinNumber = self.currentSpinNumber
        spinWheelController.view.frame = self.viewSpinWheel.bounds
        spinWheelController.willMove(toParent: self)
        self.viewSpinWheel.addSubview(spinWheelController.view)
        spinWheelController.setUserSelectedSpinWheelColor(selectedColor)
        self.addChild(spinWheelController)
        spinWheelController.didMove(toParent: self)
    }
    
    func removeSpinWheel() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func actionBtnPlace(_ sender: Any) {
        
        
    }
    
    //MARK:- Actions
    @IBAction func actionMyReward(_ sender: Any) {
        let destination = EN_VC_RewardWinnings(nibName: "EN_VC_RewardWinnings", bundle: nil)
        destination.campaignDetails = self.campaignDetails
        destination.customerDetails = self.customerDetails
        
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: false, completion: nil)
    }
    //MARK:- Actions
    @IBAction func actionWinBigThisSeason(_ sender: Any) {
        let destination = EN_VC_WinBBPopupViewController(nibName: "EN_VC_WinBBPopupViewController", bundle: nil)
        destination.campaignDetails = self.campaignDetails
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: false, completion: nil)
    }
    
    func updateSpinLeft(leftSpins:Int)  {
        self.lblNumberOfSpinYouHave.isHidden = leftSpins <= 0
        self.lblNumberOfSpinYouHave.text =  "You Have \(leftSpins) Spins. Click On The \"Pointer\" To Stop The Wheel!"
    }
    
    @IBAction func actionBtnContinue(_ sender: Any) {
        
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
            self.showAlert(alertTitle: "Alert!", alertMessage: "Campaign and store details not available. Please try after some time.")
        }
    }
    
    @IBAction func actionBtnAllColors(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.isSelected == true {
            button.isSelected = false
            button.setImage(UIImage(named : "closeButton"), for: UIControl.State.normal)
            button.setTitle(" ", for: UIControl.State.normal)
            button.setBackgroundImage(UIImage(named : ""), for: UIControl.State.normal)
            unhideAllColorButtons()
        }else {
            button.isSelected = true
            button.setImage(UIImage(named : "bitmap"), for: UIControl.State.normal)
            button.setTitle("kl_ColorTitle".localized, for: UIControl.State.normal)
            button.setBackgroundImage(UIImage(named : "roundRectangle"), for: UIControl.State.normal)
            hideAllColorButtons()
        }
    }
    
    @IBAction func actionToSelectColor(_ sender: Any) {
        self.resetAllButtonsToInitailState()
        let button = sender as! UIButton
        previousColorIndex = (button.tag + 1)
        button.setImage(UIImage(named :String(format:"SpinColorSelected%d",(button.tag + 1) )), for: UIControl.State.normal)
        self.callNextSpinView(tag : button.tag, selectColor: true)
    }
    
    func callNextSpinView(tag : Int, selectColor : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.removeSpinWheel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                if selectColor{
                    self.addSpinWheel(selectedColor: tag)
                }else{
                    // self.openPopUpForSelection()
                    self.openSelectedGame(selectedGame: .spinWheel)
                }
            }
        }
    }
    
    func refreshCollection() {
        DispatchQueue.main.async {
            self.collectionSpin.reloadData()
            let takenCount = self.totalCount - self.remainingLocalTrialCount
            self.lblRemainingTrialsCount.text = "\(takenCount)"
        }
    }
    
    //MARK:- Reset All Color Options Buttons
    func resetAllButtonsToInitailState()
    {
        self.btnBlue.setImage(UIImage(named :"SpinColorUnSelected1"), for: UIControl.State.normal)
        self.btnViolet.setImage(UIImage(named :"SpinColorUnSelected2"), for: UIControl.State.normal)
        self.btnPurple.setImage(UIImage(named :"SpinColorUnSelected3"), for: UIControl.State.normal)
        self.btnRed.setImage(UIImage(named :"SpinColorUnSelected4"), for: UIControl.State.normal)
        self.btnYellow.setImage(UIImage(named :"SpinColorUnSelected5"), for: UIControl.State.normal)
        self.btnGreen.setImage(UIImage(named :"SpinColorUnSelected6"), for: UIControl.State.normal)
        self.btnAqua.setImage(UIImage(named :"SpinColorUnSelected7"), for: UIControl.State.normal)
        self.btnOrange.setImage(UIImage(named :"SpinColorUnSelected8"), for: UIControl.State.normal)
        self.btnIndigo.setImage(UIImage(named :"SpinColorUnSelected9"), for: UIControl.State.normal)
    }
    
    //MARK:- Hide and UnHide Buttons
    func hideAllColorButtons()
    {
        self.btnBlue.isHidden = true
        self.btnViolet.isHidden = true
        self.btnPurple.isHidden = true
        self.btnRed.isHidden = true
        self.btnYellow.isHidden = true
        self.btnGreen.isHidden = true
        self.btnAqua.isHidden = true
        self.btnOrange.isHidden = true
        self.btnIndigo.isHidden = true
    }
    
    func unhideAllColorButtons()
    {
        self.btnBlue.isHidden = false
        self.btnViolet.isHidden = false
        self.btnPurple.isHidden = false
        self.btnRed.isHidden = false
        self.btnYellow.isHidden = false
        self.btnGreen.isHidden = false
        self.btnAqua.isHidden = false
        self.btnOrange.isHidden = false
        self.btnIndigo.isHidden = false
    }
    
    //MARK:- Hide and UnHide ColorSelection Options . When Spin is Rotating
    
    func hideColorsSelectionOptions(){
        //     self.viewForColorSelection.isHidden = true
        btnAddColors.isSelected = false
        actionBtnAllColors(btnAddColors)
        self.viewForColorSelection.isUserInteractionEnabled = false
    }
    
    func unhideColorsSelectionOptions(){
        //        self.viewForColorSelection.isHidden = false
        self.viewForColorSelection.isUserInteractionEnabled = true
    }
    
    @IBAction func actionBackBtn(_ sender: Any){
        self.appDelegate.appLaunch()
    }
    
    // MARK: Play Music When Spin Appears
    func playMusicWhenSpinAppears(){
        
        DispatchQueue.main.async {
            let path = Bundle.main.path(forResource: "bubble_pop.aac", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                self.bombSoundEffect?.prepareToPlay()
                self.bombSoundEffect?.play()
                
            } catch {
                // couldn't load file :(
            }
            //     DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            //        self.appDelegate.playBackgroundMusic()
            //    }
        }
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

extension EN_VC_TrialSpin : UIPopoverPresentationControllerDelegate
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
    
    func alertOkButton(){
        self.callNextSpinView(tag : previousColorIndex - 1,selectColor: false)
    }
    
    // MARK: Helper Methods
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN))
    }
    
    func openSelectedGame(selectedGame: SelectedGame) {
        self.isScratchCard = selectedGame
        unhideColorsSelectionOptions()
        showColorSection()
        addSpinWheel(selectedColor:previousColorIndex - 1)
    }
    
}

extension EN_VC_TrialSpin : CustomPopUpUserDataDelegate{
    func selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame) {
        openSelectedGame(selectedGame: selectedGame)
    }
}

extension EN_VC_TrialSpin : UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictRewardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SpinImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinImageCollectionViewCell", for: indexPath) as! SpinImageCollectionViewCell
        let spinDetailsObj = dictRewardsArray[indexPath.row]
        let strImgName = spinDetailsObj?.clrSelected ?? ""
        cell.btnSpin.setBackgroundImage(UIImage(named: strImgName)! , for: .normal)
        cell.btnSpin.setTitle("\(indexPath.row + 1)", for: .normal)
        
        //if((spinDetailsObj?.amountSelected)! > 0)
        if let string = spinDetailsObj?.amountSelected, !string.isEmpty
        {
            if(string.isNumber)
            {
                let textContent = String(format:"%@ Points",(spinDetailsObj?.amountSelected)!)
                let textString = NSMutableAttributedString(string: textContent, attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14)!
                ])
                textString.setColorForText(textForAttribute:String(format:"%@",(spinDetailsObj?.amountSelected)!) , withColor: UIColor.black, withFont: UIFont(name: "Montserrat-Semibold", size: 16)!)
                cell.lblAmount.attributedText  = textString
            }
            else
            {
                let textContent = String(format:"%@",(spinDetailsObj?.amountSelected)!)
                let textString = NSMutableAttributedString(string: textContent, attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14)!
                ])
                textString.setColorForText(textForAttribute:String(format:"%@",(spinDetailsObj?.amountSelected)!) , withColor: UIColor.black, withFont: UIFont(name: "Montserrat-Semibold", size: 16)!)
                cell.lblAmount.attributedText  = textString
            }
            
            
            cell.btnSpin.setTitle("", for: .normal)
            if let image = UIImage(named: "plantWithBackgound") {//self.nameOfColor(strName: strImgName)){
                cell.btnSpin.setBackgroundImage(image, for: .normal)
            }
        }else
        {
            cell.lblAmount.text = String(format:"",(spinDetailsObj?.amountSelected)!)
        }
        
        return cell
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
}

