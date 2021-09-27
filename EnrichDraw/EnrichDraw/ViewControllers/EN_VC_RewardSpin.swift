//
//  EN_VC_TrialSpin.swift
//  EnrichProj
//
//  Created by Mugdha on 29/08/18.
//  Copyright © 2018 Mugdha. All rights reserved.
// Commit test 1


import UIKit
import PKHUD
import AVFoundation
import MarqueeLabel
enum SpinColors : String{
    case clrRoyalBlue = "RoyalBluewheelthumb"
    case clrYellow = "YellowWheelthumb"
    case clrGreen = "GreenWheelthumb"
    case clrViolet = "VioletWheelthumb"
    case clrOrange = "OrangeWheelthumb"
    case clrAqua = "AquaWheelthumb"
    case clrRed = "RedWheelthumb"
    case clrSkyBlue = "SkyBlueWheelthumb"
    case clrPink = "PinkWheelthumb"
    case clrWhite = "SpinWhiteImg"
}

struct SpinDetails {
    var clrSelected : String = SpinColors.clrRed.rawValue
    var amountSelected : String = ""
    var spinNo : Int = 0
    var invoiceNo : String?
}

class EN_VC_RewardSpin: UIViewController {
    @IBOutlet weak var lblEligible: UILabel!
    @IBOutlet weak var lblHashSpins: UILabel!
    @IBOutlet weak var lblSelctionColorTitle: UILabel!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet private weak var bannerAdvertise: UIImageView!

    @IBOutlet weak var btnPlace: UIButton!
    @IBOutlet weak var btnAddColors: UIButton!

    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var imgEnrich: UIImageView!
    
    @IBOutlet weak var viewRightPane: UIView!
    @IBOutlet weak var viewSpinWheel: UIView! // View for spinwheel
    @IBOutlet weak var viewSelectColors: UIView! // Big color selection view on landinding review screen
    @IBOutlet weak var viewForColorSelection: UIView! // Bottom color selection view on screen
   
    // Color Buttons : viewForColorSelection
    @IBOutlet weak var btnBlue: UIButton!  // btnRoyalBlue
    @IBOutlet weak var btnViolet: UIButton! // btnGrey
    @IBOutlet weak var btnPurple: UIButton! // btnPink
    @IBOutlet weak var btnRed: UIButton!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnAqua: UIButton! // btnWhite
    @IBOutlet weak var btnOrange: UIButton!
    @IBOutlet weak var btnIndigo: UIButton! // btnPink
    
    //Color Buttons : viewSelectColors
    @IBOutlet weak var btnSelectView1: UIButton!
    @IBOutlet weak var btnSelectView2: UIButton!
    @IBOutlet weak var btnSelectView3: UIButton!
    @IBOutlet weak var btnSelectView4: UIButton!
    @IBOutlet weak var btnSelectView5: UIButton!
    @IBOutlet weak var btnSelectView6: UIButton!
    @IBOutlet weak var btnSelectView7: UIButton!
    @IBOutlet weak var btnSelectView8: UIButton!
    @IBOutlet weak var btnSelectView9: UIButton!
    
    // Left View
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblBillNo: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblBillAmount: UILabel!
    @IBOutlet weak var lblNoOfSpin: UILabel!
    @IBOutlet weak var collectionSpin: UICollectionView!
    
    @IBOutlet weak var lblRemainingSpins: UILabel!
    @IBOutlet weak var lblRemainingSpinsCount: UILabel!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgLeftBackground: UIImageView!
    @IBOutlet private weak var imgRightBackground: UIImageView!
    
    @IBOutlet private weak var lblRecycleInfo: UILabel!
    
    @IBOutlet private weak var lblSpinCount: UILabel!
        @IBOutlet private weak var lblTotalRewardsRolled: UILabel!
        @IBOutlet private weak var lblPoints1: UILabel!
        @IBOutlet private weak var lblPoints2: UILabel!
        @IBOutlet private weak var lblPoints3: UILabel!
        @IBOutlet private weak var lblPoints4: UILabel!
        @IBOutlet private weak var lblPoints5: UILabel!
        @IBOutlet private weak var lblNumberOfSpinYouHave: UILabel!
    @IBOutlet private weak var animatedUIView: UIStackView!
        private var arrLastFiveSpinDetails = [CustomerSpin]()
        private var isViewInBackground = false
        private var isViewVisible = false
        
        let appd:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblAnimation: MarqueeLabel!


    var remainingLocalRideCount = 0
    var totalCount = 0
    
    var previousColorIndex = 1
    var customerDetails = CustomerDetails()
    
    
    var pageNo = 1
    var totalRecords:Int64 = 0
    var records = [MyProductOrdersModuleModel.GetMyOrders.Orders]()
    var originalRecords = [MyProductOrdersModuleModel.GetMyOrders.Orders]()

    var accessToken: String = ""
    var selectedIndexFromRecordsArray = 0
    var totalEligibleSpinCountsAgainstAllInvoices = 0
    
    var dictRewardsArray = [Int : SpinDetails]()
    var currentSpinNumber:Int = 0
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()

    var bombSoundEffect: AVAudioPlayer?
    var isScratchCard:SelectedGame = .spinWheel
    let labelSpace = "   "
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrLastFiveSpinDetails = appd.arrLastFiveSpinDetails
        self.changeLastFiveSpinData()
        self.viewSelectColors.isHidden = true
        self.viewForColorSelection.isHidden = true
        self.lblCopyRight.text = self.getCopyRight()
        setFirstTimeSetColor()
        self.setUpUI()
        //self.initialSetUp()
       // openPopUpForSelection()
        lblRecycleInfo.text = campaignDetails.recycle_message ?? ""
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
            print("self.storeDetails.no_of_spin_availed=\(self.storeDetails)")
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
    
    func initialSetUp() {
        self.navigationController?.isNavigationBarHidden = true
        self.btnPlace.setTitle(self.storeDetails.storeName ?? "", for: .normal)
        hideAllColorButtons()
    }
    
    func setFirstTimeSetColor(){
        //lblEligible.text = "kl_EligibleSpins".localized
        //lblHashSpins.text = "kl_hashSpins".localized
        lblSelctionColorTitle.text = "kl_colorMsg".relatedStrings(isScratchCard)
        btnAddColors.setTitle("kl_ColorTitle".localized, for: .normal)

        if isScratchCard == .scratchCard {
            btnSelectView1.setImage( UIImage.init(named:"scratchIcon1"), for: .normal)
            btnSelectView2.setImage( UIImage.init(named:"scratchIcon2"), for: .normal)
            btnSelectView3.setImage( UIImage.init(named:"scratchIcon3"), for: .normal)
            btnSelectView4.setImage( UIImage.init(named:"scratchIcon4"), for: .normal)
            btnSelectView5.setImage( UIImage.init(named:"scratchIcon5"), for: .normal)
            btnSelectView6.setImage( UIImage.init(named:"scratchIcon6"), for: .normal)
            btnSelectView7.setImage( UIImage.init(named:"scratchIcon7"), for: .normal)
            btnSelectView8.setImage( UIImage.init(named:"scratchIcon8"), for: .normal)
            btnSelectView9.setImage( UIImage.init(named:"scratchIcon9"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Hide and Show (bottom) color bars and First time color selection images
    public func hideColorSection(){
        self.viewForColorSelection.isHidden = true
    }
    
    public func showColorSection(){
        self.viewForColorSelection.isHidden = false
    }
    
    public func showColorsView(){
        if self.viewSelectColors != nil{
            self.viewForColorSelection.isHidden = true
            self.viewSelectColors.isHidden = false
            self.viewSpinWheel.bringSubviewToFront(viewSelectColors)
        }
    }
    
    public func hideColorsView(){
        if self.viewSelectColors != nil{
            self.viewForColorSelection.isHidden = true
            self.viewSelectColors.removeFromSuperview()
            self.viewSelectColors.isHidden = true
            self.viewSpinWheel.sendSubviewToBack(viewSelectColors)
        }
    }
    
    func updateSpinLeft(leftSpins:Int)  {
        self.lblNumberOfSpinYouHave.isHidden = leftSpins <= 0 
        self.lblNumberOfSpinYouHave.text =  "You Have \(leftSpins) Spins. Click On The Pointer To Spin The Wheel"
    }
    
    //MARK:- Hide and UnHide ColorSelection Options . When Spin is Rotating
    func hideColorsSelectionOptions(){
        btnAddColors.isSelected = false
        actionBtnAllColors(btnAddColors)
        self.viewForColorSelection.isUserInteractionEnabled = false
    }
    
    func unhideColorsSelectionOptions(){
        self.viewForColorSelection.isUserInteractionEnabled = true
    }
    
    //MARK:- Add And Remove SpinWheel
    func addSpinWheel(selectedColor:Int){
        playMusicWhenSpinAppears()

        let spinWheelController = EN_VC_SpinWheel.instantiate(fromAppStoryboard: .Main)
        spinWheelController.isScratchCard = self.isScratchCard
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.campaignDetails = self.campaignDetails
        spinWheelController.customerDetails = self.customerDetails
        spinWheelController.isTrialOrRewardSpin = false
        spinWheelController.controller = nil
        spinWheelController.controller = self
        spinWheelController.dictRewardsArray = self.dictRewardsArray
        spinWheelController.currentSpinNumber = self.currentSpinNumber
        spinWheelController.view.frame = self.viewSpinWheel.bounds
        spinWheelController.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices
        spinWheelController.willMove(toParent: self)
        self.viewSpinWheel.addSubview(spinWheelController.view)
        if viewSelectColors != nil{
            self.viewSpinWheel.bringSubviewToFront(viewSelectColors)
        }
        spinWheelController.setUserSelectedSpinWheelColor(selectedColor)
        self.addChild(spinWheelController)
        spinWheelController.didMove(toParent: self)
    }
    
    func removeSpinWheel()
    {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func actionBtnBack(_ sender: Any) {

        let alert = UIAlertController(title:"", message: "Do you want to go home or back?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Home", style: UIAlertAction.Style.cancel, handler: { (action) in
            self.appDelegate.appLaunch()
        }))
        alert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (action) in
            // Do nothing
            self.navigationController?.popToViewController(ofClass: EN_VC_CutomerOTPVerification.self, animated: false)

        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- Actions
    @IBAction func actionMyReward(_ sender: Any) {
        let destination = EN_VC_RewardWinnings(nibName: "EN_VC_RewardWinnings", bundle: nil)
        destination.campaignDetails = self.campaignDetails
        destination.customerDetails = self.customerDetails
        destination.totalSpinLeftString = self.totalEligibleSpinCountsAgainstAllInvoices - self.currentSpinNumber
        destination.originalRecords = self.originalRecords
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
    
    @IBAction func actionToSelectColorFromBigRoundRightPane(_ sender: Any) {
        
        if self.viewSelectColors != nil{
            self.viewForColorSelection.isHidden = false
            self.viewSelectColors.removeFromSuperview()
        }
        
        self.viewForColorSelection.isHidden = false
        
        let button = sender as! UIButton
        
        removeSpinWheel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addSpinWheel(selectedColor: button.tag)
            
        }
        var colorSelected:UIButton = button
        
        //TODO:******** Set to selected spin wheel
        var spinObj = dictRewardsArray[currentSpinNumber]
        
        switch colorSelected.tag {
        case 0:
            colorSelected = self.btnBlue
            spinObj?.clrSelected = SpinColors.clrRoyalBlue.rawValue
        case 1:
            colorSelected = self.btnViolet
            spinObj?.clrSelected = SpinColors.clrViolet.rawValue
        case 2:
            colorSelected = self.btnPurple
            spinObj?.clrSelected = SpinColors.clrPink.rawValue
        case 3:
             colorSelected = self.btnRed
             spinObj?.clrSelected = SpinColors.clrRed.rawValue
        case 4:
            colorSelected = self.btnYellow
            spinObj?.clrSelected = SpinColors.clrYellow.rawValue
        case 5:
             colorSelected = self.btnGreen
             spinObj?.clrSelected = SpinColors.clrGreen.rawValue
        case 6:
             colorSelected = self.btnAqua
             spinObj?.clrSelected = SpinColors.clrAqua.rawValue
        case 7:
             colorSelected = self.btnOrange
             spinObj?.clrSelected = SpinColors.clrOrange.rawValue
        case 8:
             colorSelected = self.btnIndigo
             spinObj?.clrSelected = SpinColors.clrPink.rawValue
        default:
            colorSelected = self.btnBlue
            spinObj?.clrSelected = SpinColors.clrRoyalBlue.rawValue
        }
        
        dictRewardsArray[currentSpinNumber] = spinObj
        self.collectionSpin.reloadData()
        self.actionToSelectColor(colorSelected)
    }
        
    @IBAction func actionBtnPlace(_ sender: Any) {
       // popupAction()
    }
    
    @IBAction func actionBtnContinue(_ sender: Any) {
        let spinWheelController = EN_VC_TermsAndConditions.instantiate(fromAppStoryboard: .Main)
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.campaignDetails = self.campaignDetails
        self.navigationController?.pushViewController(spinWheelController, animated: true)
        
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
        button.setImage(UIImage(named :String(format:"SpinColorSelected%d",(button.tag + 1) )), for: UIControl.State.normal)
        previousColorIndex = (button.tag + 1)
        var spinObj = self.dictRewardsArray[self.currentSpinNumber]
        spinObj?.clrSelected = self.nameOfColor(tag: (button.tag + 1))
        self.dictRewardsArray[self.currentSpinNumber] = spinObj
        
        removeSpinWheel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.addSpinWheel(selectedColor: button.tag)
            DispatchQueue.main.async {
                self.collectionSpin.reloadData()
            }
        }
    }
    
    //MARK:- Other functions
    func nameOfColor(tag : Int) -> String
    {
        switch tag {
        case 1:
            return SpinColors.clrRoyalBlue.rawValue
        case 2:
            return SpinColors.clrYellow.rawValue
        case 3:
            return SpinColors.clrGreen.rawValue
        case 4:
            return SpinColors.clrAqua.rawValue
        case 5:
            return SpinColors.clrOrange.rawValue
        case 6:
            return SpinColors.clrViolet.rawValue
        case 7:
            return SpinColors.clrRed.rawValue
        case 8:
            return SpinColors.clrSkyBlue.rawValue
        case 9:
            return SpinColors.clrPink.rawValue
        default:
            return SpinColors.clrWhite.rawValue
        }
    }
    
    func callNextSpinView(tag : Int) {
        if (self.currentSpinNumber == self.dictRewardsArray.count) // All Spin Done for Selected Invoice
        {
            self.currentSpinNumber  = 0
            self.selectedIndexFromRecordsArray = 0
            self.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices - self.customerDetails.remainingSpins
            records.removeAll(where: {$0.greenrich?.invoice_number == self.customerDetails.invoiceNo})
            if !records.isEmpty
            {
                actionPlaySpinGame(indexPath:IndexPath.init(row: self.selectedIndexFromRecordsArray, section: 0))
            }
            else
            {
                actionMyReward(self)
            }
            //getOrdersData(pageNo: self.pageNo, accessToken: accessToken)
        }
        else
        {
            updateSpinAfterDone(tag: tag)
        }
        
    }
    
    func updateSpinAfterDone(tag : Int)
    {
        removeSpinWheel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
           // self.openPopUpForSelection()
            self.addSpinWheel(selectedColor: self.previousColorIndex - 1)
            
            DispatchQueue.main.async {
                self.collectionSpin.reloadData()
            }
        }
    }
    
    func refreshCollection() {
        DispatchQueue.main.async {
            self.collectionSpin.reloadData()
            let takenCount = self.totalCount - self.remainingLocalRideCount
            self.lblRemainingSpinsCount.text = "\(takenCount)"
        }
    }
    
    //MARK:- Reset All Color Options Buttons
    func resetAllButtonsToInitailState() {
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
    
    //MARK: Hide and UnHide Buttons
    func hideAllColorButtons() {
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
    
    func unhideAllColorButtons() {
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
    }
    }    
}

extension EN_VC_RewardSpin : UICollectionViewDataSource, UICollectionViewDelegate
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

extension EN_VC_RewardSpin : UIPopoverPresentationControllerDelegate
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

extension EN_VC_RewardSpin
{
    // MARK :- Initial SetUp Before View Load
    func setUpUI()
    {
        DispatchQueue.main.async {
            
//            self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "")
//            self.updateImage(imageView: self.imgLeftBackground, imageData: self.campaignDetails.campaignLeftBackground ?? Data(), defaultImageName: "LeftBackImg.png")
            
            /*if let logoDetails = self.campaignDetails.campaign_left_background_image, let urlObj = logoDetails.url {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imgLeftBackground.image = image
                            }
                        }
                    }
                }
            }*/
            
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
            
            self.lblBillNo.text = self.customerDetails.invoiceNo ?? ""
            self.lblCustomerName.text = self.customerDetails.customerName ?? ""
            self.lblBillAmount.text = "₹ \(String(format: "%2.0f",self.customerDetails.amount ?? 0.0))"
            
            let remaining = self.customerDetails.remainingSpins
            let noOfSpins = self.customerDetails.noOfSpins ?? 0
            self.totalCount = remaining + noOfSpins
            self.remainingLocalRideCount = remaining
            
            self.lblNoOfSpin.text = "\(self.totalCount)"
            self.lblRemainingSpins.isHidden = false
            self.lblRemainingSpinsCount.isHidden = false
            
            let takenCount = self.totalCount - self.remainingLocalRideCount
            self.lblRemainingSpinsCount.text = "\(takenCount)"
                        
            self.btnPlace.setTitle(self.storeDetails.storeName ?? "", for: .normal)

            for index in 0..<( self.customerDetails.remainingSpins )
            {
                self.dictRewardsArray[index] = SpinDetails.init(clrSelected: GlobalFunctions.shared.getRandonColor() , amountSelected: "", spinNo: index, invoiceNo:self.customerDetails.invoiceNo ?? "" )
            }
            
            self.collectionSpin.reloadData()
            
            self.openSelectedGame(selectedGame: .spinWheel)
        }
        
        
    }
    
    func alertOkButton(){
        self.callNextSpinView(tag: previousColorIndex - 1)
    }
    
    
    // MARK: Helper Methods
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN))
    }

    func openSelectedGame(selectedGame: SelectedGame) {
        self.isScratchCard = selectedGame
        unhideColorsSelectionOptions()
        showColorSection()
        self.addSpinWheel(selectedColor: previousColorIndex - 1)
        initialSetUp()
    }

}

extension EN_VC_RewardSpin : CustomPopUpUserDataDelegate {
    func selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame) {
        self.openSelectedGame(selectedGame: selectedGame)
    }
}



extension EN_VC_RewardSpin
{
    
    func getOrdersData(pageNo: Int, accessToken: String) {
        self.selectedIndexFromRecordsArray = 0

        guard let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let storeIdObj = userDetailsObj.salon_id, !storeIdObj.isEmpty else {
            return
        }
        
        
        let params : [String: Any] = [
            "limit" : 100,
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
        
        //records.append(contentsOf: model.orders ?? [])
        records.append(contentsOf: finalFilteredRecords(model: model))
        if !records.isEmpty
        {
            actionPlaySpinGame(indexPath:IndexPath.init(row: self.selectedIndexFromRecordsArray, section: 0))
        }
        else
        {
            actionMyReward(self)
        }
    }
    
    func finalFilteredRecords(model: MyProductOrdersModuleModel.GetMyOrders.MyOrdersData) -> [MyProductOrdersModuleModel.GetMyOrders.Orders]
    {
        var recordsNew = [MyProductOrdersModuleModel.GetMyOrders.Orders]()

        if let orders = model.orders, !orders.isEmpty {
            recordsNew.removeAll()
            for element in orders
            {
               if  let spinDetails =  element.greenrich?.spin_details, !spinDetails.isEmpty, let spinFirst = spinDetails.first, let spinCount = spinFirst.remaining_spins, spinCount > 0 {
                    recordsNew.append(element)
            }
            
        }
    
    }
        return recordsNew
    }
    func actionPlaySpinGame(indexPath: IndexPath) {
        if !self.records.isEmpty{
        let model = self.records[indexPath.row]
        
        let selectedCampaign = model.greenrich?.applicable_campaigns?.first {
            $0.entity_id == campaignDetails.entity_id
        }
        
        if selectedCampaign != nil,
           let spinDetails = model.greenrich?.spin_details,
            !spinDetails.isEmpty,
            let customerData = spinDetails.first {
            print("Done")
            self.configureCustomerData(customerData: customerData)
            updateSpinAfterDone(tag: previousColorIndex - 1)
        }else {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Selected campaign is not applicable for current invoice. Please selected another campaign")
            return
        }
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
            self.dictRewardsArray.removeAll()
            for index in 0..<( self.customerDetails.remainingSpins )
            {
                self.dictRewardsArray[index] = SpinDetails.init(clrSelected: GlobalFunctions.shared.getRandonColor() , amountSelected: "", spinNo: index, invoiceNo:self.customerDetails.invoiceNo ?? "" )
            }
        }
        else {
            self.showAlert(alertTitle: "Alert!", alertMessage: "Customer id is missing")
        }
        
    }
    
    
}
