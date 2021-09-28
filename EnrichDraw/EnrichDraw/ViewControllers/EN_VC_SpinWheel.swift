//
//  EN_VC_SpinWheel.swift
//  EnrichWheel
//
//  Modified on 20/08/2018.

//

import UIKit
//import TTFortuneWheel
import AVFoundation
import PKHUD
import SRScratchView

enum CasinoCityTags : Int {
    case macau = 1001
    case vegas
    case manila
    case monteCarlo
    case goa
}

class EN_VC_SpinWheel: UIViewController {
    
    var confettiImageView : UIImageView?
    var confettiImageView2 : UIImageView?
    var confettiImageView3 : UIImageView?
    var countdownTimer: Timer!
    var totalTime = 55
    
    var isTrialOrRewardSpin:Bool = false
    var adminSeletedSliceToStop:Int = 0
    var allSpinsCountIsZero:Bool = false
    
    var controller: UIViewController? = nil
    
    @IBOutlet weak var viewSpinWheelData: UIView!
    var bombSoundEffect: AVAudioPlayer?
    var dictRewardsArray = [Int : SpinDetails]()
    var currentSpinNumber:Int = 0
    var isTimerActive:Bool = false
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()
    var customerDetails = CustomerDetails()
    var totalEligibleSpinCountsAgainstAllInvoices = 0

    var btnSpinTitle:String = "Spin"
    
    
    //MARK:- --------------------------- SCRATCH VIEW
    @IBOutlet weak var lblSwipeMsg: UILabel!
    @IBOutlet weak var viewScratchCard: UIView!
    @IBOutlet weak var viewScrachCard3: UIView!
    @IBOutlet weak var viewScratchCards2: UIView!
    @IBOutlet weak var scratchViewContainer: UIView!
    @IBOutlet weak var scratchImageView: SRScratchView!
    @IBOutlet weak var scratchCardView: UIView!
    @IBOutlet weak var trophyBgView: UIView!
    @IBOutlet weak var lblYouWon: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRs: UILabel!
    @IBOutlet weak var lblPriceSC: UILabel!
    @IBOutlet weak var lblPriceSC2: UILabel!
    @IBOutlet weak var view2Background: UIView!
    
    var isScratchCard:SelectedGame = .spinWheel
    var strDetails = "spin"
    // ---------------------------
    
    //MARK:- --------------------------- CARDS VIEW
    var widthCard : CGFloat = 120
    var heightCard : CGFloat = 170
    var halfWidthCards : CGFloat = 0.0
    var halfHeightCards : CGFloat = 0.0
    @IBOutlet weak var btnFifth: UIButton!
    @IBOutlet weak var btnFourth: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    @IBOutlet weak var btnSec: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var viewCards: UIView!
    @IBOutlet weak var btnShuffle: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnShowCorner: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    
    var isInMid = false
    var isOpenMid = false
    var arrImges : [String] = []
    var arrImgesPrice = ["ImgBackground","ImgBackCard1","ImgBackground","ImgBackground","ImgBackCard1","ImgBackground"]
    
    var lastSelectedNo = 0
    
    var sixBtnY : CGFloat = 500.0
    var fifthBtnY : CGFloat = 500.0
    var fourBtnY : CGFloat = 500.0
    var thirdBtnY : CGFloat = 500.0
    var secondBtnY : CGFloat = 500.0
    var firstBtnY : CGFloat = 500.0
    // ---------------------------
    
    //MARK:- --------------------------- CASINO VIEW
    var isShowAmount:Bool = false
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var viewCasinoCities: UIView!
    @IBOutlet weak var viewCasinoFull: UIView!
    
    @IBOutlet weak var viewCasino: UIView!
    @IBOutlet weak var img21: UIImageView!
    @IBOutlet weak var img22: UIImageView!
    @IBOutlet weak var img23: UIImageView!
    
    @IBOutlet weak var img31: UIImageView!
    @IBOutlet weak var img32: UIImageView!
    @IBOutlet weak var img33: UIImageView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var img41: UIImageView!
    @IBOutlet weak var img42: UIImageView!
    @IBOutlet weak var img43: UIImageView!
    
    @IBOutlet weak var img51: UIImageView!
    @IBOutlet weak var img52: UIImageView!
    @IBOutlet weak var img53: UIImageView!
    
    @IBOutlet weak var img61: UIImageView!
    @IBOutlet weak var img62: UIImageView!
    @IBOutlet weak var img63: UIImageView!
    
    @IBOutlet weak var viewObj1: UIImageView!
    @IBOutlet weak var viewObj3: UIImageView!
    @IBOutlet weak var viewObj5: UIImageView!
    @IBOutlet weak var viewObj7: UIImageView!
    @IBOutlet weak var viewObj9: UIImageView!
    @IBOutlet weak var viewObj11: UIImageView!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgBack1: UIImageView!
    @IBOutlet weak var imgBack2: UIImageView!
    @IBOutlet weak var imgBack3: UIImageView!
    @IBOutlet weak var imgBack4: UIImageView!
    @IBOutlet weak var imgBack5: UIImageView!
    @IBOutlet weak var imgBack6: UIImageView!
    
    @IBOutlet weak var imgCasinoOut: UIImageView!
    @IBOutlet weak var constraintDigitWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnStop: UIButton!
    var finalCount = 000315
    var kAnimTimeCol1 = 0.1
    var kAnimTimeCol2 = 0.1
    var kAnimTimeCol3 = 0.1
    var kAnimTimeCol = 0.1
    var kAnimTimeCol4 = 0.1
    var kAnimTimeCol5 = 0.1
    
    var j1 = 0
    var j2 = 0
    var j3 = 4
    var j4 = 5
    var j5 = 5
    var j = 6
    
    var timer = Timer()
    var isStopCol1 = true
    var isStopCol2 = true
    var isStopCol3 = true
    var isStopCol4 = true
    var isStopCol5 = true
    var isStopCol = true
    
    var isStopAnim1 = true
    var isStopAnim2 = true
    var isStopAnim3 = true
    var isStopAnim4 = true
    var isStopAnim5 = true
    var isStopAnim = true
    // ----------------------------
    
    //MARK:- --------------------------- SPIN VIEW
    @IBOutlet weak private var btnSpin: UIButton!
    @IBOutlet weak private var spinningWheel: TTFortuneWheel!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var spinWheel: UIImageView!
    // ---------------------------
    
    //MARK:- --------------------------- DICE VIEW
    @IBOutlet weak var imgDiceShow: UIImageView!
    @IBOutlet weak private var imgCup: UIImageView!
    private var diceWidth = 180
    private var halfWidth = 100
    let square = UIButton()
    var isStopAnimation = 1
    let arrDiceImages = ["ImgDice1", "ImgDice2", "ImgDice3", "ImgDice4", "ImgDice5", "ImgDice"]
    
    @IBOutlet weak var viewDice: UIView!
    
    @IBOutlet weak var btnDiceSpin: UIButton!
    // ---------------------------
    
    @IBOutlet weak var spinwheelWidthCons: NSLayoutConstraint!
    @IBOutlet weak var spinwheelHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var spinwheelImageWidthCons: NSLayoutConstraint!
    @IBOutlet weak var spinwheelImageHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var spinwheelBorderWidthCons: NSLayoutConstraint!
    @IBOutlet weak var spinwheelBorderHeightCons: NSLayoutConstraint!
    
    var simulator = "Simulator "
    let iPad12Width:CGFloat = 600
    let iPad12Height:CGFloat = 600
    
    let iPad11Width:CGFloat = 440
    let iPad11Height:CGFloat = 440
    
    let iPadProWidth:CGFloat = 380
    let iPadProHeight:CGFloat = 380
    
    let iPadMiniWidth:CGFloat = 380
    let iPadMiniHeight:CGFloat = 380
    
    let iPadAirWidth:CGFloat = 340
    let iPadAirHeight:CGFloat = 340
    
    let iPadWidth:CGFloat = 320
    let iPadHeight:CGFloat = 320
    
    let appd:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        halfWidth = Int(view.frame.height)
        self.showSpinWheel()
        
        if Platform.isSimulator {
            print("Running on Simulator")
            self.simulator = "Simulator "
        }else{
            self.simulator = ""
        }
        
        self.checkiPadModelName()
        
    }
    
    func checkiPadModelName(){
        let modelName = UIDevice.modelName
        print("modelName=\(modelName)")
        if (modelName == simulator + "iPad Pro (12.9-inch) (5th generation)"){
            self.setWidthHeightCons(iPad12Width, iPad12Height)
        }
        else if (modelName == simulator + "iPad Pro (12.9-inch) (4th generation)"){
            self.setWidthHeightCons(iPad12Width, iPad12Height)
        }
        else if (modelName == simulator + "iPad Pro (12.9-inch) (3rd generation)"){
            self.setWidthHeightCons(iPad12Width, iPad12Height)
        }
        else if (modelName == simulator + "iPad Pro (12.9-inch) (2nd generation)"){
            self.setWidthHeightCons(iPad12Width, iPad12Height)
        }
        else if (modelName == simulator + "iPad Pro (12.9-inch) (1st generation)"){
            self.setWidthHeightCons(iPad12Width, iPad12Height)
        }
        else if (modelName == simulator + "iPad Pro (11-inch) (3rd generation)"){
            self.setWidthHeightCons(iPad11Width, iPad11Height)
        }
        else if (modelName == simulator + "iPad Pro (11-inch) (2nd generation)"){
            self.setWidthHeightCons(iPad11Width, iPad11Height)
        }
        else if (modelName == simulator + "iPad Pro (11-inch) (1st generation)"){
            self.setWidthHeightCons(iPad11Width, iPad11Height)
        }
        else if (modelName == simulator + "iPad Pro (10.5-inch)"){
            self.setWidthHeightCons(iPadProWidth, iPadProHeight)
        }
        else if (modelName == simulator + "iPad Pro (9.7-inch)"){
            self.setWidthHeightCons(iPadProWidth, iPadProHeight)
        }
        else if (modelName == simulator + "iPad mini (6th generation)"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad mini (5th generation)"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad mini 4"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad mini 3"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad mini 2"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad mini"){
            self.setWidthHeightCons(iPadMiniWidth, iPadMiniHeight)
        }
        else if (modelName == simulator + "iPad Air (4th generation)"){
            self.setWidthHeightCons(iPadAirWidth, iPadAirHeight)
        }
        else if (modelName == simulator + "iPad Air (4th generation)"){
            self.setWidthHeightCons(iPadAirWidth, iPadAirHeight)
        }
        else if (modelName == simulator + "iPad Air (3rd generation)"){
            self.setWidthHeightCons(iPadAirWidth, iPadAirHeight)
        }
        else if (modelName == simulator + "iPad Air 2"){
            self.setWidthHeightCons(iPadAirWidth, iPadAirHeight)
        }
        else if (modelName == simulator + "iPad Air"){
            self.setWidthHeightCons(iPadAirWidth, iPadAirHeight)
        }
        else if (modelName == simulator + "iPad (9th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (8th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (7th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (6th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (5th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (4th generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad (3rd generation)"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else if (modelName == simulator + "iPad 2"){
            self.setWidthHeightCons(iPadWidth, iPadHeight)
        }
        else{
            self.setWidthHeightCons(450, 450)
        }
    }
    
    func setWidthHeightCons(_ width:CGFloat, _ height:CGFloat){
        self.spinwheelWidthCons.constant = width
        self.spinwheelHeightCons.constant = height
        
        self.spinwheelImageWidthCons.constant = width
        self.spinwheelImageHeightCons.constant = height
        
        self.spinwheelBorderWidthCons.constant = width + 4
        self.spinwheelBorderHeightCons.constant = height + 4
        
        self.updateViewConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSelectedGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bombSoundEffect?.volume = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Set up selected game
    func showSelectedGame(){
        
        var isHideColor = true
        
        switch isScratchCard {
        case .spinWheel:
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.hideColorsView()
                obj.hideColorSection()
            }
            isHideColor = true
            viewSpinWheelData.isHidden = false
            hideCardsView()
            hideCasinoGame()
            hideDiceView()
            setUpWheelConfiguration()
            hideScratchCard()
            strDetails = "spin"
        case .scratchCard:
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.hideColorsView()
                obj.hideColorSection()
            }
            isHideColor = true
            viewSpinWheelData.isHidden = true
            hideCardsView()
            hideCasinoGame()
            hideDiceView()
            setUpWheelConfiguration()
            setupScratchCard()
            isTimerActive = true;
            strDetails = "scratch card"
        case .dice:
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.showColorsView()
            }
            isHideColor = false
            viewSpinWheelData.isHidden = true
            hideCardsView()
            hideCasinoGame()
            hideScratchCard()
            setUpWheelConfiguration()
            setUpDiceView()
            isTimerActive = true;
            strDetails = "dice"
        case .casino:
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.hideColorsView()
                obj.hideColorSection()
            }
            isHideColor = true
            viewSpinWheelData.isHidden = true
            hideCardsView()
            hideScratchCard()
            hideDiceView()
            setUpWheelConfiguration()
            casinoGameSetup()
            isTimerActive = true;
            strDetails = "Casino"
        case .cards:
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.hideColorsView()
                obj.hideColorSection()
            }
            viewSpinWheelData.isHidden = true
            isHideColor = true
            strDetails = "Cards"
            isTimerActive = true;
            setUpWheelConfiguration()
            showCardsView()
        }
        
        if let obj = self.controller as? EN_VC_TrialSpin{
            if isHideColor{
                obj.hideColorSection()
            }else{
                obj.showColorSection()
            }
        }
    }
    
    
    
    //MARK:- Gif Firework animation
    func showGifOnView(){
        switch self.isScratchCard{
        case .cards,.casino, .dice:break
        default://RouletteWheel-[AudioTrimmer.com]
            self.playSound(strSoundName:"chimes.wav" , numberOfLoops: 2)
        }
        
        //        if let confettiImgView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: 400, height: 400), resourceName: "enrichPlant"), confettiImageView == nil {
        //            confettiImageView = confettiImgView
        //            confettiImageView!.alpha = 0.7
        //            view.addSubview(confettiImageView!)
        //            confettiImageView!.startAnimating()
        //        }
        
        if let confettiImgView2 = UIImageView.fromGif(frame: CGRect(x: 200, y: 200, width: 400, height: 400), resourceName: "enrichPlant"), confettiImageView2 == nil{
            self.confettiImageView2 = confettiImgView2
            confettiImageView2!.alpha = 0.7
            view.addSubview(confettiImageView2!)
            confettiImageView2!.startAnimating()
        }
        //
        //        if let confettiImgView3 = UIImageView.fromGif(frame: CGRect(x: 350, y: 50, width: 350, height: 350), resourceName: "enrichPlant"), confettiImageView3 == nil{
        //            self.confettiImageView3 = confettiImgView3
        //            confettiImageView3!.alpha = 0.7
        //            view.addSubview(confettiImageView3!)
        //            confettiImageView3!.startAnimating()
        //        }
    }
    
    func removeGifOnView(){
        if confettiImageView != nil && self.view.subviews.contains(confettiImageView!){
            confettiImageView!.removeFromSuperview()
            confettiImageView = nil
        }
        
        if confettiImageView2 != nil && self.view.subviews.contains(confettiImageView2!){
            confettiImageView2!.removeFromSuperview()
            confettiImageView2 = nil
        }
        
        if confettiImageView3 != nil && self.view.subviews.contains(confettiImageView3!){
            confettiImageView3!.removeFromSuperview()
            confettiImageView3 = nil
        }
        
    }
    
    //MARK:- Play sounds
    func playSound(strSoundName: String, numberOfLoops : Int){
        // Sound
        let path = Bundle.main.path(forResource: strSoundName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            self.bombSoundEffect?.prepareToPlay()
            self.bombSoundEffect?.numberOfLoops = numberOfLoops
            self.bombSoundEffect?.volume = 1
            self.bombSoundEffect?.rate = 1.0
            self.bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
        
    }
    
    //MARK:- Timer actions
    func startTimer() {
        isTimerActive = true
        timerLabel.text = "00:00"
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func setTimerOn(){
        
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            isTimerActive = true
            totalTime -= 1
            if(totalTime < 30)
            {
                switch isScratchCard{
                case .casino:
                    self.btnStop.isHidden = false
                    let title = returnButtonSpinTitle(textContext: String(format:"Stop\n%@",timerLabel.text!), timer: timerLabel.text!)
                    self.btnStop.setAttributedTitle(title, for: .normal)
                    
                case .dice:
                    self.btnDiceSpin.isHidden = false
                    let title = returnButtonSpinTitle(textContext: String(format:"Stop dice\n%@",timerLabel.text!), timer: timerLabel.text!)
                    self.btnDiceSpin.setAttributedTitle(title, for: .normal)
                    
                default:
                    let title = returnButtonSpinTitle(textContext: String(format:"%@\n%@",self.btnSpinTitle,timerLabel.text!), timer: timerLabel.text!)
                    self.btnSpin.setAttributedTitle(title, for: .normal)
                }
            }
        } else {
            isTimerActive = false
            endTimer()
            
            switch isScratchCard{
            case .casino:
                self.stopCasinoAnim()
            case .dice:
                stopDiceAnimation()
            case .spinWheel:
                self.rotateButton(self.btnSpin)
                break
            case .scratchCard:
                break
            case .dice:
                break
            case .cards:
                break
            default : break
                
            }
            
        }
    }
    
    func endTimer() {
        self.btnSpin.setAttributedTitle(NSMutableAttributedString(string: ""), for: .normal)
        countdownTimer.invalidate()
        totalTime = 55
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%01d:%02d", minutes, seconds)
    }
    
    //MARK:- Spin middle button
    func returnButtonSpinTitle(textContext:String, timer:String)-> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let textString = NSMutableAttributedString(string: textContext, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Semibold", size: 25)!,.paragraphStyle: style])
        textString.setColorForText(textForAttribute:String(format: "%@",timer ) , withColor: getRandomColor(), withFont: UIFont(name: "Montserrat-Semibold", size: 25)!)
        return textString
    }
    
    //MARK:- Define admin configuration before spin appears
    func setUpWheelConfiguration() {
        if(isTrialOrRewardSpin) {// Trial Spin
            self.adminSeletedSliceToStop = (self.randomNumber(MIN: 0, MAX: self.spinningWheel.slices.count))
        }
        else {// Reward Spin
            self.adminSeletedSliceToStop = generateArrayForRewardsInRewardsSpin()
        }
    }
    
    func getRewardsIndextoStop(rewards_id: String) -> Int
    {
        self.allSpinsCountIsZero = false
        var indexToStopWheel = 0
       
        if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
        {
            for (index, element) in (campaignConfig.campaign_offers?.enumerated())!
            {
                if let id = element.campaign_reward_id,
                    id == rewards_id {
                    indexToStopWheel = index
                }
            }
        }
        
        return indexToStopWheel
    }
    
    //MARK:- Array for reward spin
    func generateArrayForRewardsInRewardsSpin()->Int
    {
        let obj:EN_VC_RewardSpin = self.controller as! EN_VC_RewardSpin
        
        self.allSpinsCountIsZero = false
        var indexToStopWheel = 0
        var array = [CarnivalWheelSlice]()
        //        if let campaignConfig:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignList, campaignConfig.listOfCampaign?.first?.campaign_offers != nil
        if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
        {
            for (_, element) in (campaignConfig.campaign_offers?.enumerated())!
            {
                //Mugdha-Changes - New
                //                if(obj.customerDetails.invoiceType == element.offer_type)
                //                {
                if let loop_offer_used = element.offer_used , let loop_count = Int(element.count ?? "0") {
                    let loopCountFinal = loop_count - Int(loop_offer_used)!
                    if loopCountFinal > 0 {
                        for _ in 0..<loopCountFinal {
                            let finalReward = "\(element.value ?? "0")".replacingOccurrences(of: "₹", with: "")
                            array.append(CarnivalWheelSlice.init(rewardName: String(format: " %@", finalReward), rewardValue: finalReward, rewardType: element.offer_type!, rewardCount: loop_count, campaignRewardId: Int(element.campaign_reward_id ?? "0") ?? 0))
                        }
                    }
                }
                //}
            }
            
            // Condition To check in case all Multiplier/Counts againts all wheels are zero
            if(array.count > 0)
            {
                indexToStopWheel = (self.randomNumber(MIN: 0, MAX: (array.count)))
                let object = array[indexToStopWheel]
                for (indexOf, element) in (self.spinningWheel.slices.enumerated())
                {
                    // if(obj.customerDetails.invoiceType == element.rewardType) {
                    if (element.campaignRewardId == object.campaignRewardId ) {
                        indexToStopWheel  = indexOf
                        break
                    }
                    //}
                }
            }
            else
                
            {
                self.allSpinsCountIsZero = true
                
            }
        }
        
        return indexToStopWheel
    }
    
    // MARK:- UpdateUserDefualt Campaign Details
    func updateCampaingDetailsInUserDefault(selectedObject:FortuneWheelSliceProtocol, isTrial: Bool)
    {
        if !isTrial {
            //        if let campaignConfig:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignList, campaignConfig.listOfCampaign?.first?.campaign_offers != nil
            if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
            {
                if((campaignConfig.campaign_offers?.count)! > 0)
                {
                    if let campaignConfigAll:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignList, campaignConfigAll.listOfCampaign?.first?.campaign_offers != nil
                    {
                        
                        var objectOf:ModelRunningCampaignListData = (campaignConfigAll.listOfCampaign?.first)!
                        let objectOfArray:[Model_campaign_offers] = campaignConfig.campaign_offers ?? []
                        
                        if var object = objectOfArray.first(where: {$0.campaign_reward_id?.uppercased() == "\(selectedObject.campaignRewardId)".uppercased()}) {
                            // Object Found
                            
                            //Mugdha-Changes - New
                            if let i = objectOfArray.index(where: {$0.campaign_reward_id?.uppercased() == "\(selectedObject.campaignRewardId)".uppercased()}) {
                                //                        if(object.balance! > 0)
                                //                        {
                                //                            object.balance = object.balance! - 1
                                //                        }
                                
                                let count = object.count ?? "0"
                                let balance = object.offer_used ?? "0"
                                let finalBalance = Int(count)! - Int(balance)!
                                
                                if(finalBalance > 0)
                                {
                                    object.offer_used = "\(finalBalance - 1)"
                                }
                                
                                objectOf.campaign_offers![i] = object
                                do {
                                    let finalObject = try objectOf.asDictionary()
                                    if  let data = GlobalFunctions.shared.jsonToNSData(json: finalObject as AnyObject)
                                    {
                                        UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: data, strKey: UserDefaultKeys.modelCampaignDetails)
                                    }
                                } catch {
                                    // couldn't load file :(
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            if let obj = self.controller as? EN_VC_RewardSpin {
                
                self.updateServerForEachSpin(invoiceNo:obj.customerDetails.invoiceNo!, amountWon: String(format:"%@",selectedObject.rewardValue), storeId: obj.storeDetails.storeId, campaignRewardId: selectedObject.campaignRewardId, isTrial: isTrial)
            }
            
        }
        else {
            if let obj = self.controller as? EN_VC_TrialSpin {
                self.updateServerForEachSpin(invoiceNo:obj.customerDetails.invoiceNo ?? "", amountWon: String(format:"%@",selectedObject.rewardValue), storeId: obj.storeDetails.storeId, campaignRewardId: selectedObject.campaignRewardId, isTrial: isTrial)
            }
            
        }
        
    }
    
    // MARK:- API CALL Update Server For Each Spin
    func updateServerForEachSpin(invoiceNo:String,amountWon:String,storeId:Int,campaignRewardId:Int, isTrial:Bool) {
        // Server Call Code
        
        let params : [String: Any] = [
            "invoiceNo":invoiceNo,
            "amountWon":amountWon,
            "storeId":storeId,
            "campaignRewardId":campaignRewardId,
            "campaignId" :self.campaignDetails.entity_id ?? "",
            "is_custom" : true,
            "customerId" : self.customerDetails.customerId ?? "",
            "is_trial" : isTrial ? 1 : 0
        ]
        EN_Service_Customer.sharedInstance.updateCustomerSpinDetails(params) { (errorCode, errorMsg, dictData) in
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    //self.showAlert(alertTitle: "ServerError", alertMessage: msg)
                }
            }else
            {
                // HANDLE SUCCESS
                if let statusCode:Bool = (dictData!["status"] as? Bool), statusCode == false
                {
                    if let msgOf = dictData!["message"] as? String // msgOf ==  "kl_ErrorExhausted".localized
                    {
                        self.showMessageWhenSpinExaust(message:msgOf)
                        return
                    }
                }
            }
        }
    }
    
    func getWinningDetails(callback: @escaping (_ reward_id: String) -> Void) {
        // Server Call Code
        
        let obj:EN_VC_RewardSpin = self.controller as! EN_VC_RewardSpin

        let params : [String: Any] = [
            "customerId" : self.customerDetails.customerId ?? "",
            "campaignId" :self.campaignDetails.entity_id ?? "",
            "is_custom" : true
        ]
        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: obj.view)
        EN_Service_Customer.sharedInstance.getWinningDetails(params) { (errorCode, errorMsg, dictData) in
            HUD.hide()
            if errorCode != 0
            {
                // HANDLE ERROR
                if let msg = errorMsg
                {
                    print("ErrorMessage: \(msg)")
                    self.showAlert(alertTitle: "Please try again", alertMessage: msg)
                }
            }else
            {
                // HANDLE SUCCESS
                if let statusCode:Bool = (dictData!["status"] as? Bool)
                {
                    if let msgOf = dictData!["message"] as? String // msgOf ==  "kl_ErrorExhausted".localized
                    {
                        if statusCode == true,
                            let data = dictData!["data"] as? [String:Any],
                            let reward_id = data["campaign_reward_id"] as? String{
                            callback(reward_id)
                        }
                        else {
                            self.showAlert(alertTitle: "Alert", alertMessage: msgOf)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK:- Message When Spin Exaust
    func showMessageWhenSpinExaust(message:String = "kl_ErrorExhausted".localized){
        
        let alertViewController = EN_VC_AlertViewController .instantiate(fromAppStoryboard: .Main)
        alertViewController.parentObj = self
        alertViewController.isTrialOrRewardSpin = self.isTrialOrRewardSpin
        alertViewController.dictRewardsArray = self.dictRewardsArray
        
        self.present(alertViewController, animated: false, completion: {
            alertViewController.alertViewSmall.alpha = 0.0
            // Fade out to set the text
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
            }, completion: {
                (finished: Bool) -> Void in
                self.playMusicWhenSpinStops()
                //Once the label is completely invisible, set the text and fade it back in
                
                if self.isTrialOrRewardSpin {
                    if let obj1 = self.controller as? EN_VC_TrialSpin
                    {
                        obj1.currentSpinNumber = self.dictRewardsArray.count
                    }
                }
                else {
                    if let obj1 = self.controller as? EN_VC_RewardSpin
                    {
                        obj1.currentSpinNumber = self.dictRewardsArray.count
                    }
                }
                
                
                let textString = self.returnAttributedStringForAlertPopUp(textContext: message, winningPrice:"")
                
                alertViewController.setAlertValues(congratsMessage: "Sorry!", imageTrophy:"greenPlant", winningMessage: textString ,btnTitle: "Show All Rewards", tipMessage: "")
                
                // Fade in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    alertViewController.alertViewSmall.alpha = 1.0
                    
                }, completion: nil)
            })
        })
    }
    
    
    // MARK:- Show Spin Wheel
    func showSpinWheel()
    {
        var slices = [CarnivalWheelSlice]()
        if(isTrialOrRewardSpin) // Trial Spin
        {
            //            if let campaignConfig:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignList, campaignConfig.listOfCampaign?.first?.campaign_offers != nil
            if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
                
            {
                //Mugdha-Changes - New
                for (_, element) in (campaignConfig.campaign_offers?.enumerated())!
                {
                    //                    if("SERVICE" == element.type)
                    //                    {
                    let finalReward = (element.offer_used ?? "")//.replacingOccurrences(of: "₹", with: "")
                    let offerName = element.trial_display_name ?? "Offer"
                    //                    slices.append(CarnivalWheelSlice.init(rewardName: String(format: "  %@", offerName.maxLength(length: 25)), rewardValue:finalReward , rewardType: element.offer_type!, rewardCount: Int(element.count!) ?? 0, campaignRewardId: Int(element.campaign_reward_id!) ?? 0))
                    //
                    slices.append(CarnivalWheelSlice.init(rewardName: String(format: "  %@", offerName.maxLength(length: 25)), rewardValue: "\(element.trial_reward_points ?? 0)", rewardType: element.offer_type!, rewardCount: Int(element.count!) ?? 0, campaignRewardId: Int(element.campaign_reward_id!) ?? 0))
                    
                    //                    }
                }
            }
            
            
            /* if let path = Bundle.main.path(forResource: "CampaignDetails", ofType: "json") {
             do {
             let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
             let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
             if  let dataOutput = GlobalFunctions.shared.jsonToNSData(json: jsonResult as AnyObject)
             {
             do {
             let decoder = JSONDecoder()
             let campaignConfig = try decoder.decode(ModelCampaignDetails.self, from: dataOutput)
             for (_, element) in (campaignConfig.campaignSpinDetailsViews?.enumerated())!
             {
             if("SERVICE" == element.type)
             {
             slices.append(CarnivalWheelSlice.init(rewardName: String(format: "     %@", element.rewardValue!), rewardValue: element.rewardValue!, rewardType: element.type!, rewardCount: element.count!, campaignRewardId: element.campaignRewardId!))
             }
             }
             }
             catch let error {
             #if DEBUG
             print("parse error: \(error.localizedDescription)")
             #endif
             
             }
             }
             } catch {
             // handle error
             #if DEBUG
             print("Json File errr: \(error.localizedDescription)")
             #endif
             }
             }*/
            
        }
        else // Reward Spin
        {
            let obj:EN_VC_RewardSpin = self.controller as! EN_VC_RewardSpin
            
            //            if let campaignConfig:ModelRunningCampaignList = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignList, campaignConfig.listOfCampaign?.first?.campaign_offers != nil
            
            if let campaignConfig:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
            {
                for (_, element) in (campaignConfig.campaign_offers?.enumerated())!
                {
                    //                    if(obj.customerDetails.invoiceType == element.type) {
                    
                    //Mugdha-Changes - New
                    //                        let finalReward = (element.rewardValue ?? "")//.replacingOccurrences(of: "₹", with: "")
                    //                        slices.append(CarnivalWheelSlice.init(rewardName: String(format: "  %@", finalReward.maxLength(length: 25)), rewardValue: finalReward, rewardType: element.type!, rewardCount: element.count!, campaignRewardId: element.campaignRewardId!))
                    
                    let finalReward = (element.offer_used ?? "")//.replacingOccurrences(of: "₹", with: "")
                    let offerName = element.offer_name ?? "Offer"
                    
                    // slices.append(CarnivalWheelSlice.init(rewardName: String(format: "  %@", offerName.maxLength(length: 25)), rewardValue:finalReward , rewardType: element.offer_type!, rewardCount: Int(element.count!) ?? 0, campaignRewardId: Int(element.campaign_reward_id!) ?? 0))
                    slices.append(CarnivalWheelSlice.init(rewardName: String(format: "  %@", offerName.maxLength(length: 25)), rewardValue:element.value ?? "" , rewardType: element.offer_type!, rewardCount: Int(element.count!) ?? 0, campaignRewardId: Int(element.campaign_reward_id!) ?? 0))
                    
                    
                    //                    }
                }
            }
        }
        
        //        slices = slices.shuffled()
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 2
        
    }
    //MARK:- Get random color
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    //MARK:- Set user selected color for dice/wheel
    func setUserSelectedSpinWheelColor(_ userSelectedIndex:Int = 0)
    {
        
        var darkColor:Style = .darkRoyalBlue
        var lightColor:Style = .lightRoyalBlue
        var spinWheelImageName:String = "royalbluewheel"
        
        switch userSelectedIndex {
        case 0:
            darkColor = .darkRoyalBlue
            lightColor = .lightRoyalBlue
            spinWheelImageName = "royalbluewheel"
            
        case 1:
            
            darkColor = .darkYellow
            lightColor = .lightYellow
            spinWheelImageName = "yellowwheel"
            
        case 2:
            
            darkColor = .darkGreen
            lightColor = .lightGreen
            spinWheelImageName = "greenwheel"
            
        case 3:
            darkColor = .darkAqua
            lightColor = .lightAqua
            spinWheelImageName = "aquawheel"
            
        case 4:
            
            darkColor = .darkOrange
            lightColor = .lightOrange
            spinWheelImageName = "orangewheel"
            
        case 5:
            
            darkColor = .darkViolet
            lightColor = .lightViolet
            spinWheelImageName = "violetwheel"
            
        case 6:
            darkColor = .darkRed
            lightColor = .lightRed
            spinWheelImageName = "redwheel"
            
        case 7:
            darkColor = .darkBlue
            lightColor = .lightBlue
            spinWheelImageName = "bluewheel"
            
        case 8:
            darkColor = .darkPink
            lightColor = .lightPink
            spinWheelImageName = "pinkwheel"
            
        default:
            darkColor = .darkRoyalBlue
            lightColor = .lightRoyalBlue
            spinWheelImageName = "royalbluewheel"
        }
        
        // DICE BUTTON BACKGROUND
        self.btnDiceSpin.backgroundColor = darkColor.backgroundColor
        self.square.setBackgroundImage(UIImage(named: self.returnDiceColorImage(spinNumber: userSelectedIndex)), for: .normal)
        self.imgDiceShow.image = UIImage(named: self.returnDiceColorImage(spinNumber: userSelectedIndex))
        
        //SPIN WHEEL BACKGROUND
        darkColor = .darkYellow
        lightColor = .lightYellow
        
        self.spinWheel.image = UIImage(named: "royalbluewheel")
        //        self.btnSpin.setTitleColor(darkColor.backgroundColor, for: UIControlState.normal)
        
        // SCRATCH CARD BACKGROUND
        //    self.setScratchCardViewBackgroundColors(lightColor: lightColor,darkColor : darkColor , userSelectedIndex: userSelectedIndex)
        
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0: slice.style = darkColor
            case 1: slice.style = lightColor
            case 2: slice.style = darkColor
            case 3: slice.style = lightColor
            default: slice.style = darkColor
            }
        }
    }
    
    func setScratchCardViewBackgroundColors(lightColor: Style,darkColor : Style , userSelectedIndex: Int){
        self.trophyBgView.backgroundColor = darkColor.backgroundColor
        self.viewScratchCards2.backgroundColor = darkColor.backgroundColor
        self.scratchImageView.image = UIImage.init(named: String(format:"ScratchImg%d",userSelectedIndex + 1))
        self.view2Background.backgroundColor = darkColor.backgroundColor
        self.viewScratchCard.backgroundColor = UIColor.white
    }
    
    //MARK: Return number Of Spin
    func returnSpinNumberInString(spinNumber:Int = 1) ->String
    {
        switch spinNumber {
        case 1: return "first"
            
        case 2: return "second"
            
        case 3: return "third"
            
        case 4: return "fourth"
            
        case 5: return "fifth"
            
        case 6: return "sixth"
            
        case 7: return "seventh"
            
        case 8: return "eighth"
            
        case 9: return "nineth"
            
        default : return""
            
        }
    }
    
    //MARK: Return dice image name
    func returnDiceColorImage(spinNumber:Int) ->String {
        return (spinNumber == 0) ? "ImgDice" : "ImgDice\(spinNumber)"
    }
    
    
    //MARK:- **** UPDATE POINTS ON SERVER : Spin Wheel Action ****
    @IBAction func rotateButton(_ sender: Any) {
        
        if(self.btnSpin.titleLabel?.text == "Spin It") // Spin Wheel
        {
            
            if(isTrialOrRewardSpin) {// Trial Spin
                self.adminSeletedSliceToStop = (self.randomNumber(MIN: 0, MAX: self.spinningWheel.slices.count))
                
                self.hideColorOptionsWhenSpinIsRotating()
                self.btnSpin.setTitle("Stop", for: UIControl.State.normal)
                self.btnSpinTitle = self.btnSpin.currentTitle!
                spinningWheel.startAnimating()
                startTimer()
                
                DispatchQueue.main.async {
                    self.playMusicWhenSpinRotates()
                }
            }
            else {// Reward Spin
                
                self.getWinningDetails { reward_id in
                    self.adminSeletedSliceToStop = self.getRewardsIndextoStop(rewards_id: reward_id)
                    
                    self.hideColorOptionsWhenSpinIsRotating()
                    self.btnSpin.setTitle("Stop", for: UIControl.State.normal)
                    self.btnSpinTitle = self.btnSpin.currentTitle!
                    self.spinningWheel.startAnimating()
                    self.startTimer()
                    
                    DispatchQueue.main.async {
                        self.playMusicWhenSpinRotates()
                    }
                }
            }
            
        }
        else // Stop Wheel
        {
            self.btnSpin.isUserInteractionEnabled = false
            self.playSound(strSoundName:"RouletteWheelEnd.mp3" , numberOfLoops: 0)
            endTimer()
            self.btnSpin.isUserInteractionEnabled = false
            self.btnSpin.setTitle("Wait", for: UIControl.State.normal)
            self.btnSpinTitle = self.btnSpin.currentTitle!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.bombSoundEffect?.fadeOut()
                self.spinningWheel.startAnimating(fininshIndex: (self.adminSeletedSliceToStop)) { (finished) in
                    self.btnSpin.setTitle("Spin It", for: UIControl.State.normal)
                    self.btnSpinTitle = self.btnSpin.currentTitle!
                    print("Status: \(finished)")
                    if self.spinningWheel.slices.count > self.adminSeletedSliceToStop
                    {
                        print ("Index Of Won Prize \(self.adminSeletedSliceToStop) and Value \(self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardName )")
                    }
                    if(self.isTimerActive == true)
                    {
                        if self.isTrialOrRewardSpin
                        {
                            self.setTrialSpinData()
                        }
                        else {
                            self.setSpinData()
                        }
                    }
                    
                    self.unhideColorOptionsWhenSpinIsRotating()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if self.isTimerActive == true{
                            self.showPopUpPointsWithFirework()
                        }else{
                            self.btnSpin.isUserInteractionEnabled = true
                            let tip = self.campaignDetails.campaign_offers?[self.adminSeletedSliceToStop].tip ?? ""
                            self.showCongratsMessagePopUp(winningPrice:self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue,numberOfSpin:self.currentSpinNumber, tipMessage: tip)
                        }
                    }
                }
            }
        }
    }
    
    func setSpinData(){
        var spinData = self.dictRewardsArray[self.currentSpinNumber]
        spinData?.amountSelected = (self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue)
        self.dictRewardsArray[self.currentSpinNumber] = spinData
        
        self.currentSpinNumber = self.currentSpinNumber + 1
        self.updateCampaingDetailsInUserDefault(selectedObject: self.spinningWheel.slices [self.adminSeletedSliceToStop], isTrial: false)
    }
    
    func setTrialSpinData(){
        var spinData = self.dictRewardsArray[self.currentSpinNumber]
        spinData?.amountSelected = (self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue)
        self.dictRewardsArray[self.currentSpinNumber] = spinData
        
        self.currentSpinNumber = self.currentSpinNumber + 1
        self.updateCampaingDetailsInUserDefault(selectedObject: self.spinningWheel.slices [self.adminSeletedSliceToStop], isTrial: true)
    }
    
    
    // MARK:- Play Music When Spin Stops
    func playMusicWhenSpinStops(){
        self.playSound(strSoundName:"victory.aac" , numberOfLoops: 0)
    }
    
    // MARK:- Play Music When Spin rotates
    func playMusicWhenSpinRotates(){
        self.playSound(strSoundName:"RouletteWheel2.mp3" , numberOfLoops: -1)
    }
    
    //MARK:- Pop up for alerts
    func showCongratsMessagePopUp(winningPrice:String,numberOfSpin:Int, tipMessage:String){
        
        let alertViewController = EN_VC_AlertViewController .instantiate(fromAppStoryboard: .Main)
        alertViewController.parentObj = self
        alertViewController.isTrialOrRewardSpin = self.isTrialOrRewardSpin
        alertViewController.dictRewardsArray = self.dictRewardsArray
        
        self.present(alertViewController, animated: false, completion: {
            alertViewController.alertViewSmall.alpha = 0.0
            // Fade out to set the text
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
            }, completion: {
                (finished: Bool) -> Void in
                // self.appDelegate.stopBackgroundMusic()
                // self.playMusicWhenSpinStops()
                //Once the label is completely invisible, set the text and fade it back in
                if(self.isTimerActive == false)
                {
                    let strErrorMsg = (self.isScratchCard ==  .spinWheel) ? "Please stop the wheel within 60 seconds." : "Please stop the slot game within 60 seconds."
                    let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "\(strErrorMsg)",winningPrice,numberOfSpin ), winningPrice: winningPrice)
                    alertViewController.setAlertValues(congratsMessage: "Timeout!", imageTrophy:"timeoutIcon", winningMessage: textString,btnTitle: "Try again",btnBackgoundImage: "timeoutBntImage", tipMessage: tipMessage)
                }
                else
                    if(self.isTrialOrRewardSpin)
                    {
                        var btnTitle = "kl_ReadyForNextSpin".localized
                        let strMsgWon = "kl_WonMsg3".relatedStrings(self.isScratchCard)
                        
                        
                        if let obj1 = self.controller as? EN_VC_TrialSpin
                        {
                            if (obj1.currentSpinNumber == self.dictRewardsArray.count)                             {
                                btnTitle = "Show All Rewards"
                            }
                        }
                        
                        if(winningPrice.isNumber)
                        {
                            let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "%@%@%@%@%@","kl_WonMsg1".localized ,winningPrice,"kl_WonMsgPts".relatedStrings(self.isScratchCard) ,"kl_WonMsg2".localized, strMsgWon ), winningPrice: winningPrice)
                            alertViewController.setAlertValues(congratsMessage: "Woohoo!", imageTrophy:"greenPlant", winningMessage: textString, btnTitle: btnTitle, tipMessage: tipMessage)
                            
                        }
                        else
                        {
                            let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "%@%@%@%@","kl_WonMsg1".localized ,winningPrice ,"kl_WonMsg2".localized,strMsgWon), winningPrice: winningPrice)
                            alertViewController.setAlertValues(congratsMessage: "Woohoo!", imageTrophy:"greenPlant", winningMessage: textString, btnTitle: btnTitle, tipMessage: tipMessage)
                            
                        }
                    }
                    else
                    {
                        let strMsgWon = self.isScratchCard == .scratchCard ? "kl_WonMsgScratch".localized : "kl_WonMsgSpin".localized
                        
                        if(self.allSpinsCountIsZero == false)
                        {
                            
                            var  btnTitle = "kl_ReadyForNextSpin".localized
                            
                            if let obj1 = self.controller as? EN_VC_RewardSpin
                            {
                                if (obj1.currentSpinNumber == self.dictRewardsArray.count)  && self.totalEligibleSpinCountsAgainstAllInvoices <= 0
                                {
                                    btnTitle = "Show All Rewards"
                                }
                            }
                            
                            
                            if(winningPrice.isNumber)
                            {
                                let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "%@%@%@%@%@","kl_WonMsg1".localized ,winningPrice,"kl_WonMsgPts".relatedStrings(self.isScratchCard)  ,"kl_WonMsg2".localized,strMsgWon), winningPrice: winningPrice)
                                
                                alertViewController.setAlertValues(congratsMessage: "Woohoo!", imageTrophy:"greenPlant", winningMessage: textString ,btnTitle: btnTitle, tipMessage: tipMessage)
                            }
                            else
                            {
                                let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "%@%@%@%@","kl_WonMsg1".localized ,winningPrice ,"kl_WonMsg2".localized,strMsgWon), winningPrice: winningPrice)
                                alertViewController.setAlertValues(congratsMessage: "Woohoo!", imageTrophy:"greenPlant", winningMessage: textString ,btnTitle: btnTitle, tipMessage: tipMessage)
                                
                            }
                        }
                        else
                        {
                            let textString = self.returnAttributedStringForAlertPopUp(textContext: String(format: "kl_ErrorContactAdmin".localized ,winningPrice,numberOfSpin ), winningPrice: winningPrice)
                            alertViewController.setAlertValues(congratsMessage: "Sorry!", imageTrophy:"greenPlant", winningMessage: textString, tipMessage: tipMessage)
                            
                        }
                }
                
                // Fade in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    alertViewController.alertViewSmall.alpha = 1.0
                    
                }, completion: nil)
            })
        })
        
    }
    
    // MARK: Return attributed string for alertPopUp
    func returnAttributedStringForAlertPopUp(textContext:String, winningPrice:String)-> NSMutableAttributedString {
        return self.returnAttributedStringForAlertPopUp(textContext: textContext, winningPrice: winningPrice, fontSizepts: 14, fintSizeWinPrice: 20)
    }
    
    func returnAttributedStringForAlertPopUp(textContext:String, winningPrice:String, fontSizepts : CGFloat, fintSizeWinPrice : CGFloat)-> NSMutableAttributedString {
        let textString = NSMutableAttributedString(string: textContext, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: fontSizepts)!])
        textString.setColorForText(textForAttribute:String(format: "" ) , withColor: UIColor(red:64/255, green:144/255, blue:84/255, alpha:1), withFont: UIFont(name: "Montserrat-Regular", size: fontSizepts)!)
        textString.setColorForText(textForAttribute:String(format: "60 seconds" ) , withColor: UIColor.black, withFont: UIFont(name: "Montserrat-Regular", size: 12)!)
        textString.setColorForText(textForAttribute: "kl_WonMsgPts".localized , withColor: UIColor(red:64/255, green:144/255, blue:84/255, alpha:1), withFont: UIFont(name: "Montserrat-Regular", size: fontSizepts)!)
        textString.setColorForText(textForAttribute:String(format: "%@",winningPrice ) , withColor: UIColor(red:64/255, green:144/255, blue:84/255, alpha:1), withFont: UIFont(name: "Montserrat-Regular", size: fintSizeWinPrice)!)
        return textString
    }
    
    // MARK: Hide and show color options to change when spin is not roating
    func hideColorOptionsWhenSpinIsRotating(){
        if(isTrialOrRewardSpin == true){
            let obj:EN_VC_TrialSpin = self.controller as! EN_VC_TrialSpin
            obj.btnPlace.isUserInteractionEnabled = false
            obj.btnContinue.isUserInteractionEnabled = false
            obj.hideColorsSelectionOptions()
        }
        else {
            let obj:EN_VC_RewardSpin = self.controller as! EN_VC_RewardSpin
            obj.btnBack.isUserInteractionEnabled = false
            obj.btnPlace.isUserInteractionEnabled = false
            obj.hideColorsSelectionOptions()
        }
    }
    
    func unhideColorOptionsWhenSpinIsRotating(){
        if(isTrialOrRewardSpin == true){
            let obj:EN_VC_TrialSpin = self.controller as! EN_VC_TrialSpin
            
            obj.currentSpinNumber = self.currentSpinNumber
            
            self.appd.totalEligibleSpinCountsAgainstAllInvoices = self.appd.totalEligibleSpinCountsAgainstAllInvoices - 1
            obj.updateSpinLeft(leftSpins: self.appd.totalEligibleSpinCountsAgainstAllInvoices)
            
            self.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices - self.currentSpinNumber
            if(currentSpinNumber != 0 && isTimerActive)
            {
                var spinData = self.dictRewardsArray[currentSpinNumber]
                spinData?.clrSelected = (self.dictRewardsArray[currentSpinNumber - 1]?.clrSelected ?? "")
                self.dictRewardsArray[currentSpinNumber] = spinData
                obj.dictRewardsArray = self.dictRewardsArray
                obj.remainingLocalTrialCount = obj.remainingLocalTrialCount - 1
                obj.refreshCollection()
            }
            
            obj.btnPlace.isUserInteractionEnabled = true
            obj.btnContinue.isUserInteractionEnabled = true
            obj.unhideColorsSelectionOptions()
        }
        else  {
            let obj:EN_VC_RewardSpin = self.controller as! EN_VC_RewardSpin
            obj.currentSpinNumber = self.currentSpinNumber
            
            obj.updateSpinLeft(leftSpins: self.totalEligibleSpinCountsAgainstAllInvoices - self.currentSpinNumber)
            if (obj.currentSpinNumber == self.dictRewardsArray.count)
            {
            self.totalEligibleSpinCountsAgainstAllInvoices = self.totalEligibleSpinCountsAgainstAllInvoices - self.customerDetails.remainingSpins
                if self.totalEligibleSpinCountsAgainstAllInvoices <= 0
                {
                    obj.btnBack.isUserInteractionEnabled = true
                }
            }
            if(currentSpinNumber != 0 && isTimerActive)
            {
                var spinData = self.dictRewardsArray[currentSpinNumber]
                spinData?.clrSelected = (self.dictRewardsArray[currentSpinNumber - 1]?.clrSelected ?? "")
                self.dictRewardsArray[currentSpinNumber] = spinData
                obj.dictRewardsArray = self.dictRewardsArray
                obj.remainingLocalRideCount = obj.remainingLocalRideCount - 1
                obj.refreshCollection()
            }
            
           
            obj.btnPlace.isUserInteractionEnabled = true
            //obj.btnBack.isUserInteractionEnabled = true
            obj.unhideColorsSelectionOptions()
        }
        
    }
    
    // MARK: Helper Methods
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN))
    }
}

//MARK:- SCRATCH CARD APP
extension EN_VC_SpinWheel : SRScratchViewDelegate{
    
    //MARK: **** UPDATE POINTS ON SERVER : Delegate method - Check % of image scratches ****
    func scratchCardEraseProgress(eraseProgress: Float) {
        
        lblSwipeMsg.isHidden = true
        self.hideColorOptionsWhenSpinIsRotating()
        
        // Scratched image % greater than 80% - Clear scratch image
        if eraseProgress > 85.0{
            self.playSound(strSoundName:"magicBox.mp3" , numberOfLoops: -1)
            setDataToScratchCard()
            self.scratchImageView.delegate = nil
            self.scratchImageView.alpha = 0.0
            
            if self.isTrialOrRewardSpin == true {
                self.setTrialSpinData()
                self.setCurrentScratchSpinData()
                self.unhideColorOptionsWhenSpinIsRotating()
            }else{
                self.setSpinData()
                self.unhideColorOptionsWhenSpinIsRotating()
                self.setCurrentScratchSpinData()
            }
            
        }
    }
    
    func setCurrentScratchSpinData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showPopUpPointsWithFirework()
        }
    }
    
    func getRandomNo(rangeFrom : Int, rangeTo : Int) -> Int {
        return Int.random(in: rangeFrom...rangeTo)
    }
    
    func setupScratchCard() {
        if isTrialOrRewardSpin {
            lblSwipeMsg.isHidden = true
        }else{
            lblSwipeMsg.isHidden = false
        }
        self.scratchImageView.alpha = 1.0
        lblPrice.text = "*****"
        lblPriceSC.text = ""
        lblPriceSC2.text = "$$$$$"
        
        var intData = 1
        repeat {
            intData = getRandomNo(rangeFrom: 1, rangeTo: 4)
        } while GlobalFunctions.shared.scratchCardLastGame == intData
        GlobalFunctions.shared.scratchCardLastGame = intData
        
        var intLabel = 0
        repeat {
            intLabel = getRandomNo(rangeFrom: 0, rangeTo: 2)
        } while GlobalFunctions.shared.scratchCardLastLabelShow == intLabel
        GlobalFunctions.shared.scratchCardLastLabelShow = intLabel
        
        self.scratchImageView.image = UIImage(named: "ImgScratchOut\(GlobalFunctions.shared.scratchCardLastGame)")
        
        switch intLabel {
        case 0:
            self.viewScratchCard.isHidden = false
            self.viewScratchCards2.isHidden = true
            self.viewScrachCard3.isHidden = true
            
        case 1:
            self.viewScratchCard.isHidden = true
            self.viewScratchCards2.isHidden = false
            self.viewScrachCard3.isHidden = true
            
        case 2:
            self.viewScratchCard.isHidden = true
            self.viewScratchCards2.isHidden = true
            self.viewScrachCard3.isHidden = false
            
        default: break
        }
        
        scratchViewContainer.isHidden = false
        
        scratchImageView.lineWidth = 40.0
        self.scratchImageView.delegate = self
        
        //        self.scratchImageView.layer.cornerRadius = 8
        self.scratchImageView.layer.masksToBounds = true
        
        //        self.scratchCardView.layer.cornerRadius = 8
        self.scratchCardView.layer.masksToBounds = true
        
        //        self.trophyBgView.layer.cornerRadius = self.trophyBgView.frame.height/2
        self.trophyBgView.layer.masksToBounds = true
    }
    
    func hideScratchCard() {
        scratchViewContainer.isHidden = true
        scratchImageView.lineWidth = 40.0
        self.scratchImageView.delegate = nil
    }
    
    func setDataToScratchCard(){
        lblPrice.text = self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue
        lblPriceSC.text = self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue
        lblPriceSC2.text = self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue
    }
    
    func alertOkButton(){
        if(isTimerActive == false || isScratchCard == .scratchCard || isScratchCard == .casino || isScratchCard == .cards || isScratchCard == .dice || isScratchCard == .spinWheel){
            if let parentObj : EN_VC_TrialSpin = self.parent as? EN_VC_TrialSpin{
                parentObj.alertOkButton()
            }
            
            if let parentObj : EN_VC_RewardSpin = self.parent as? EN_VC_RewardSpin{
                parentObj.alertOkButton()
            }
        }
    }
}

//MARK:- DICE APP
extension EN_VC_SpinWheel {
    
    func hideDiceView() {
        imgCup.isHidden = true
        self.viewDice.sendSubviewToBack(imgCup)
        viewDice.isHidden = true
        scratchImageView.lineWidth = 40.0
    }
    
    func setUpDiceView(){
        self.imgDiceShow.isHidden = false
        imgCup.isHidden = false
        if let obj = self.controller as? EN_VC_TrialSpin{
            obj.unhideColorsSelectionOptions()
            
        }
        if let obj = self.controller as? EN_VC_RewardSpin{
            obj.unhideColorsSelectionOptions()
        }
        
        self.square.titleLabel?.lineBreakMode = .byWordWrapping
        self.square.titleLabel?.textAlignment = .center
        self.square.frame = CGRect(x:  250, y: self.halfWidth - 300, width: diceWidth, height: diceWidth)
        self.square.setTitleColor(UIColor.white, for: .normal)
        self.square.titleLabel?.backgroundColor = UIColor.clear
        self.square.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 35)!
        self.viewDice.addSubview(self.square)
        
        btnDiceSpin.isHidden = false
        btnDiceSpin.layer.cornerRadius = 10
        
        self.viewDice.sendSubviewToBack(square)
        self.square.setTitle(self.spinningWheel.slices [Int.random(in: 0..<self.spinningWheel.slices.count)].rewardValue, for: .normal)
    }
    
    //MARK: **** UPDATE POINTS ON SERVER : Stop/Start button action ****
    @IBAction func actionDiceBtnSpin(_ sender: Any) {
        
        if self.isStopAnimation == 1 {
            self.imgDiceShow.isHidden = true
            btnDiceSpin.isUserInteractionEnabled = false
            btnDiceSpin.isHidden = true
            
            self.square.frame = CGRect(x: 250, y:  self.halfWidth - 300, width: self.diceWidth, height: self.diceWidth)
            
            btnDiceSpin.setTitle("Stop dice", for: .normal)
            
            if let obj = self.controller as? EN_VC_TrialSpin{
                obj.hideColorsSelectionOptions()
            }
            if let obj = self.controller as? EN_VC_RewardSpin{
                obj.hideColorsSelectionOptions()
            }
            
            startTimer()
            
            // Sound
            self.playSound(strSoundName:"RATTLE2.wav" , numberOfLoops: 3)
            
            // imgCup
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.09
            animation.repeatCount = 15
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: imgCup.center.x - 10, y: imgCup.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: imgCup.center.x + 10, y: imgCup.center.y))
            imgCup.layer.add(animation, forKey: "position")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.playSound(strSoundName:"RollDice.mp3" , numberOfLoops: -1)
                self.startAnimation(fromframe: CGRect(x: 250, y:  self.halfWidth - 300, width: self.diceWidth, height: self.diceWidth), toframe:  CGRect(x: 250, y: 20, width: self.diceWidth, height: self.diceWidth))
            }
        }else {
            self.isStopAnimation = 3
            btnDiceSpin.setTitle("Shake cup", for: .normal)
            self.btnDiceSpin.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.square.layer.removeAllAnimations()
                self.square.setTitle("\(self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue)", for: .normal)
                self.showPopUpPointsWithFirework()
                self.btnDiceSpin.isHidden = true
                self.isStopAnimation = 1
                if self.isTrialOrRewardSpin == true {
                    self.setTrialSpinData()
                }else{
                    self.setSpinData()
                }
                self.endTimer()
                self.unhideColorOptionsWhenSpinIsRotating()
                if let obj = self.controller as? EN_VC_TrialSpin{
                    obj.hideColorsSelectionOptions()
                }
                if let obj = self.controller as? EN_VC_RewardSpin{
                    obj.hideColorsSelectionOptions()
                }
            })
        }
    }
    
    func stopDiceAnimation(){
        self.square.layer.removeAllAnimations()
        self.isStopAnimation = 1
        self.btnDiceSpin.isHidden = false
        isTimerActive = false
        let tip = self.campaignDetails.campaign_offers?[self.adminSeletedSliceToStop].tip ?? ""
        
        self.showCongratsMessagePopUp(winningPrice:self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue,numberOfSpin:self.currentSpinNumber, tipMessage: tip)
    }
    
    func startAnimation(fromframe : CGRect , toframe : CGRect){
        self.square.frame = fromframe
        
        let timeInterval: CFTimeInterval = 0.3
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = timeInterval
        rotateAnimation.repeatCount=Float.infinity
        self.square.layer.add(rotateAnimation, forKey: nil)
        
        animateView(toframe:toframe)
    }
    
    func changeImages(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.isStopAnimation != 1 {
                self.square.setTitle("\(self.spinningWheel.slices [Int.random(in: 0..<self.spinningWheel.slices.count)].rewardValue)", for: .normal)
                self.changeImages()
            }
        }
    }
    
    func animateView(toframe : CGRect){
        changeImages()
        UIView.animate(withDuration: 1, delay: 0, options: .transitionFlipFromTop, animations: {
            self.square.frame = toframe
        }, completion: { (isTrue) in
            self.isStopAnimation = self.isStopAnimation + 1
            if self.isStopAnimation == 3{
                self.btnDiceSpin.isUserInteractionEnabled = true
                self.btnDiceSpin.isHidden = false
                return
            }
            self.animateView(toframe: CGRect(x: 250, y: self.halfWidth - 600, width: self.diceWidth, height: self.diceWidth))
        })
    }
}

//MARK:- CASINO APP
extension EN_VC_SpinWheel {
    
    func hideCasinoGame(){
        self.viewCasino.isHidden = true
        scratchImageView.lineWidth = 40.0
    }
    
    func casinoGameSetup() {
        self.isShowAmount = false
        self.btnTimer.isHidden = false
        self.viewCasinoCities.isHidden = false
        btnStop.setTitle("Spin It", for: .normal)
        self.viewCasino.isHidden = false
        var strFinal = self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue
        print("strFinal : \(strFinal)")
        strFinal = strFinal.containsIgnoreCase("₹") ? strFinal.replacingOccurrences(of: "₹", with: "") : strFinal
        strFinal = strFinal.containsIgnoreCase(" ") ? strFinal.replacingOccurrences(of: " ", with: "") : strFinal
        print("strFinal : \(strFinal)")
        finalCount = Int(strFinal) ?? 0
    }
    
    //-------------------------------------------------
    @IBAction func actionBtnStop(_ sender: Any) {
        
        if checkAllAnimDone() {
            
            self.playSound(strSoundName:"slot.mp3" , numberOfLoops: 0)
            self.playSound(strSoundName:"CasinoBack.mp3" , numberOfLoops: -1)
            
            startTimer()
            self.viewCasinoCities.isHidden = true
            btnStop.setTitle("Stop", for: .normal)
            btnStop.isEnabled = true
            
            j1 = Int(getRandonNumber(range: 0...9))
            j2 = Int(getRandonNumber(range: 0...9))
            j3 = Int(getRandonNumber(range: 0...9))
            j4 = Int(getRandonNumber(range: 0...9))
            j5 = Int(getRandonNumber(range: 0...9))
            j = Int(getRandonNumber(range: 0...9))
            
            isStopCol1 = false
            isStopCol2 = false
            isStopCol3 = false
            isStopCol4 = false
            isStopCol5 = false
            isStopCol = false
            
            isStopAnim1 = false
            isStopAnim2 = false
            isStopAnim3 = false
            isStopAnim4 = false
            isStopAnim5 = false
            isStopAnim = false
            
            setAnimCol1()
            setAnimCol2()
            setAnimCol3()
            setAnimCol4()
            setAnimCol5()
            setAnimCol()
            return
        }else if !isStopCol && !isStopCol1 && !isStopCol2 && !isStopCol3 && !isStopCol4 && !isStopCol5 {
            
            btnStop.isEnabled = false
            btnStop.setTitle("Spin It", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.1...0.2), execute: {
                self.isStopCol = true
                _ = self.checkUptoZero()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.1...0.4), execute: {
                self.isStopCol1 = true
                _ = self.checkUptoFirst()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.2...0.3), execute: {
                self.isStopCol2 = true
                _ = self.checkUptoSec()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.1...0.3), execute: {
                self.isStopCol3 = true
                _ = self.checkUptoThird()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.1...0.4), execute: {
                self.isStopCol4 = true
                _ = self.checkUptoFour()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + getRandonNumber(range: 0.1...0.2), execute: {
                self.isStopCol5 = true
                _ = self.checkUptoFive()
            })
            
        }
    }
    
    func stopCasinoAnim(){
        self.isStopCol = true
        self.isStopCol1 = true
        self.isStopCol2 = true
        self.isStopCol3 = true
        self.isStopCol4 = true
        self.isStopCol5 = true
        
        self.isStopAnim = true
        self.isStopAnim1 = true
        self.isStopAnim2 = true
        self.isStopAnim3 = true
        self.isStopAnim4 = true
        self.isStopAnim5 = true
        self.btnStop.isHidden = false
        
        isTimerActive = false
        endTimer()
        
        let tip = self.campaignDetails.campaign_offers?[self.adminSeletedSliceToStop].tip ?? ""
        
        self.showCongratsMessagePopUp(winningPrice:self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue,numberOfSpin:self.currentSpinNumber, tipMessage: tip)
    }
    
    //-------------------------------------------------
    func getRandonNumber(range : ClosedRange<Double>) -> Double{
        let number1 = Double.random(in: range)
        print("number1 : \(number1)")
        return number1
    }
    
    //-------------------------------------------------
    func setButtonsj5(){
        j5 = j5 + 1
        j5 = j5 == 10 ? 0 : j5
    }
    
    func setButtonsj4(){
        j4 = j4 + 1
        j4 = j4 == 10 ? 0 : j4
    }
    
    func setButtonsj3(){
        j3 = j3 + 1
        j3 = j3 == 10 ? 0 : j3
    }
    
    func setButtonsj2(){
        j2 = j2 + 1
        j2 = j2 == 10 ? 0 : j2
    }
    
    func setButtonsj1(){
        j1 = j1 + 1
        j1 = j1 == 10 ? 0 : j1
    }
    
    func setButtonsj(){
        j = j + 1
        j = j == 10 ? 0 : j
    }
    
    //-------------------------------------------------
    @objc func setAnimCol(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj()
        
        self.viewObj1.image = UIImage(named:"img\(self.j)")
        
        self.img2.image = UIImage()
        
        self.viewObj1.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol, animations: {
            self.viewObj1.frame = (self.isStopCol && self.checkUptoZero()) ? self.img2.frame :  self.img3.frame
        }) { (isTrue) in
            
            self.viewObj1.isHidden = true
            
            if self.isStopCol{
                if self.checkUptoZero(){
                    self.viewObj1.frame = self.img1.frame
                    //                    DispatchQueue.main.async {
                    self.img2.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") : UIImage(named:"img\(self.j)")
                    //                    }
                    return
                }
            }
            self.viewObj1.frame = self.img1.frame
            self.img2.image = UIImage(named:"img\(self.j)")
            self.setAnimCol()
        }
    }
    
    @objc func setAnimCol1(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj1()
        self.viewObj3.image = UIImage(named:"img\(self.j1)")
        self.img22.image = UIImage()
        self.viewObj3.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol1, animations: {
            self.viewObj3.frame = (self.isStopCol1 && self.checkUptoFirst()) ? self.img22.frame : self.img23.frame
            
        }) { (isTrue) in
            self.viewObj3.isHidden = true
            
            if self.isStopCol2{
                if self.checkUptoFirst(){
                    self.viewObj3.frame = self.img21.frame
                    //                    DispatchQueue.main.async {
                    self.img22.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") : UIImage(named:"img\(self.j1)")
                    //                    }
                    return
                }
            }
            self.viewObj3.frame = self.img21.frame
            self.img22.image = UIImage(named:"img\(self.j1)")
            self.setAnimCol1()
        }
    }
    
    @objc func setAnimCol2(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj2()
        
        self.viewObj5.image = UIImage(named:"img\(self.j2)")
        
        self.img32.image = UIImage()
        
        self.viewObj5.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol2, animations: {
            self.viewObj5.frame = (self.isStopCol2 && self.checkUptoSec()) ? self.img32.frame :  self.img33.frame
        }) { (isTrue) in
            
            self.viewObj5.isHidden = true
            
            if self.isStopCol2{
                if self.checkUptoSec(){
                    self.viewObj5.frame = self.img31.frame
                    //                    DispatchQueue.main.async {
                    self.img32.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") : UIImage(named:"img\(self.j2)")
                    //                    }
                    return
                }
            }
            self.viewObj5.frame = self.img31.frame
            self.img32.image = UIImage(named:"img\(self.j2)")
            self.setAnimCol2()
        }
    }
    
    @objc func setAnimCol3(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj3()
        
        self.viewObj7.image = UIImage(named:"img\(self.j3)")
        
        self.img42.image = UIImage()
        
        self.viewObj7.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol3, animations: {
            self.viewObj7.frame = (self.isStopCol3 && self.checkUptoThird()) ? self.img42.frame :  self.img43.frame
        }) { (isTrue) in
            
            self.viewObj7.isHidden = true
            
            if self.isStopCol3{
                if self.checkUptoThird(){
                    self.viewObj7.frame = self.img41.frame
                    //                    DispatchQueue.main.async {
                    self.img42.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") :UIImage(named:"img\(self.j3)")
                    //                    }
                    return
                }
            }
            self.viewObj7.frame = self.img41.frame
            self.img42.image = UIImage(named:"img\(self.j3)")
            self.setAnimCol3()
        }
    }
    
    @objc func setAnimCol4(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj4()
        
        self.viewObj9.image = UIImage(named:"img\(self.j4)")
        
        self.img52.image = UIImage()
        
        self.viewObj9.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol4, animations: {
            self.viewObj9.frame = (self.isStopCol4 && self.checkUptoFour()) ? self.img52.frame :  self.img53.frame
        }) { (isTrue) in
            
            self.viewObj9.isHidden = true
            
            if self.isStopCol4{
                if self.checkUptoFour(){
                    self.viewObj9.frame = self.img51.frame
                    //                    DispatchQueue.main.async {
                    
                    self.img52.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") : UIImage(named:"img\(self.j4)")
                    //                    }
                    return
                }
            }
            self.viewObj9.frame = self.img51.frame
            self.img52.image = UIImage(named:"img\(self.j4)")
            self.setAnimCol4()
        }
    }
    
    @objc func setAnimCol5(){
        self.view.layer.removeAllAnimations()
        self.setButtonsj5()
        
        self.viewObj11.image = UIImage(named:"img\(self.j5)")
        
        self.img62.image = UIImage()
        
        self.viewObj11.isHidden = false
        
        UIView.animate(withDuration: kAnimTimeCol5, animations: {
            self.viewObj11.frame = (self.isStopCol5 && self.checkUptoFive()) ? self.img62.frame :  self.img63.frame
        }) { (isTrue) in
            
            self.viewObj11.isHidden = true
            
            if self.isStopCol5{
                if self.checkUptoFive(){
                    self.viewObj11.frame = self.img61.frame
                    //                    DispatchQueue.main.async {
                    self.img62.image = (self.finalCount == 0) ? UIImage(named:"ImgGiftCard") : UIImage(named:"img\(self.j5)")
                    //                    }
                    return
                }
            }
            self.viewObj11.frame = self.img61.frame
            self.img62.image = UIImage(named:"img\(self.j5)")
            self.setAnimCol5()
        }
    }
    
    
    
    //-------------------------------------------------
    //MARK:  **** UPDATE POINTS ON SERVER : Casino game ****
    func stopCasinoGame(){
        if checkAllAnimDone() && isTimerActive == true && isShowAmount == false{
            isShowAmount = true
            // *********************************
            if self.isTrialOrRewardSpin == true {
                self.setTrialSpinData()
            }else{
                self.setSpinData()
            }
            self.viewCasinoCities.isHidden = true
            self.btnTimer.isHidden = true
            showPopUpPointsWithFirework()
            endTimer()
            self.unhideColorOptionsWhenSpinIsRotating()
            // *********************************
        }
    }
    
    func checkUptoZero() -> Bool{
        let firstNo = (finalCount/100000)
        if j == firstNo{
            self.isStopCol = true
            //           self.kAnimTimeCol2 = self.kAnimTimeCol2 + 0.1
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            //                self.isStopCol2 = true
            //                self.checkUptoSec()
            //            })
            isStopAnim = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol1()
        return false
    }
    
    func checkUptoFirst() -> Bool{
        let firstNo = (( finalCount / 10000 ) % 10)
        if j1 == firstNo{
            self.isStopCol1 = true
            //           self.kAnimTimeCol2 = self.kAnimTimeCol2 + 0.1
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            //                self.isStopCol2 = true
            //                self.checkUptoSec()
            //            })
            isStopAnim1 = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol1()
        return false
    }
    
    func checkUptoSec() -> Bool{
        let secNo = (( finalCount / 1000 ) % 10 )
        if j2 == secNo{
            self.isStopCol2 = true
            //            self.kAnimTimeCol3 = self.kAnimTimeCol3 + 0.1
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            //                self.isStopCol3 = true
            //                self.checkUptoThird()
            //            })
            isStopAnim2 = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol2()
        return false
    }
    
    func checkUptoThird() -> Bool{
        let thirdNo = ( ( finalCount / 100) % 10 )
        if j3 == thirdNo{
            self.isStopCol3 = true
            isStopAnim3 = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol3()
        return false
    }
    
    func checkUptoFour() -> Bool{
        let fourNo = ( (finalCount / 10) % 10 )
        if j4 == fourNo{
            self.isStopCol4 = true
            isStopAnim4 = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol3()
        return false
    }
    
    func checkUptoFive() -> Bool{
        let fiveNo = ( finalCount % 10 )
        if j5 == fiveNo{
            self.isStopCol5 = true
            isStopAnim5 = true
            stopCasinoGame()
            return true
        }
        //        setAnimCol3()
        return false
    }
    
    func showPopUpPointsWithFirework(){
        if isTimerActive == true{
            DispatchQueue.main.async {
                switch self.isScratchCard{
                case .scratchCard, .spinWheel: break
                case .casino:
                    self.playSound(strSoundName:"Applause-1.mp3" , numberOfLoops: 0)
                case .cards:
                    self.playSound(strSoundName:"ApplauseCrowd.mp3" , numberOfLoops: -1)
                case .dice:
                    self.playSound(strSoundName:"Crowd.mp3" , numberOfLoops: 0)
                default:
                    self.playSound(strSoundName:"TaDa.mp3" , numberOfLoops: -1)
                }
            }
            self.btnStop.isHidden = true
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //                self.showGifOnView()
            //            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // self.removeGifOnView()
                
                let tip = self.campaignDetails.campaign_offers?[self.adminSeletedSliceToStop].tip ?? ""
                
                self.showCongratsMessagePopUp(winningPrice:self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue,numberOfSpin:self.currentSpinNumber, tipMessage: tip)
                self.btnStop.isHidden = false
            }
        }
    }
    
    func checkAllAnimDone() -> Bool{
        if isStopAnim && isStopAnim1 && isStopAnim2 && isStopAnim3 && isStopAnim4 && isStopAnim5{
            return true
        }
        return false
    }
    
    @IBAction func actionCasinoCityBtn(_ sender: UIButton) {
        
        self.playSound(strSoundName:"Ting-Popup.mp3" , numberOfLoops: 0)
        viewCasinoFull.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            switch sender.tag {
            case CasinoCityTags.macau.rawValue:
                //                self.casinoMacauSettings()
                self.imgBackground.image = UIImage(named: "ImgMacao")
                
            case CasinoCityTags.vegas.rawValue:
                //                self.casinoVegasSettings()
                self.imgBackground.image = UIImage(named: "ImgVegas")
                
            case CasinoCityTags.manila.rawValue:
                //                self.casinoManilaSettings()
                self.imgBackground.image = UIImage(named: "ImgManila")
                
            case CasinoCityTags.monteCarlo.rawValue:
                //                self.casinoMontoSettings()
                self.imgBackground.image = UIImage(named: "ImgMontoCarlo")
                
            case CasinoCityTags.goa.rawValue:
                //                self.casinoGoaSettings()
                self.imgBackground.image = UIImage(named: "imgCasinoBack")
            default:
                break
            }
            self.viewCasinoFull.alpha = 0.5
        }) { (istrue) in
            self.viewCasinoFull.alpha = 1
        }
    }
    func imgBackSilver(silver : Bool){
        //        let imgName = silver ? "ImgSilverBack" : "ImgGoldBack"
        //        imgBack1.image = UIImage(named: imgName)
        //        imgBack2.image = UIImage(named: imgName)
        //        imgBack3.image = UIImage(named: imgName)
        //        imgBack4.image = UIImage(named: imgName)
        //        imgBack5.image = UIImage(named: imgName)
        //        imgBack6.image = UIImage(named: imgName)
    }
    
    func casinoMacauSettings(){
        //        constraintYCasino.constant = 75
        //        constrintsHeightCasino.constant = 185
        //        constraintDigitWidth.constant = 555
        //        constraintMidDigits.constant = -20
        //
        //        imgBackSilver(silver: false)
        //        imgCasinoOut.image = UIImage(named: "ImgCasino")
    }
    
    func casinoMontoSettings(){
        //        constraintYCasino.constant = 116
        //        constrintsHeightCasino.constant = 160
        //        constraintDigitWidth.constant = 610
        //        constraintMidDigits.constant = -18
        //
        //        imgBackSilver(silver: true)
        //        imgCasinoOut.image = UIImage(named: "ImgFrontMonto")
    }
    
    func casinoManilaSettings(){
        //        constraintYCasino.constant = 78
        //        constrintsHeightCasino.constant = 165
        //        constraintDigitWidth.constant = 555
        //        constraintMidDigits.constant = -16
        //
        //        imgBackSilver(silver: false)
        //        imgCasinoOut.image = UIImage(named: "ImgFrontManila")
    }
    
    func casinoVegasSettings(){
        //        constraintYCasino.constant = 78
        //        constrintsHeightCasino.constant = 168
        //        constraintDigitWidth.constant = 600
        //        constraintMidDigits.constant = -18
        //
        //        imgBackSilver(silver: true)
        //        imgCasinoOut.image = UIImage(named: "ImgFrontvegas")
    }
    
    func casinoGoaSettings(){
        //        constraintYCasino.constant = 70
        //        constrintsHeightCasino.constant = 185
        //        constraintDigitWidth.constant = 575
        //        constraintMidDigits.constant = -20
        //        imgBackSilver(silver: false)
        //        imgCasinoOut.image = UIImage(named: "ImgCasino")
    }
}
//MARK:- CARDS APP
extension EN_VC_SpinWheel {
    
    func hideCardsView(){
        self.viewCards.isHidden = true
    }
    
    func showCardsView() {
        
        self.view.bringSubviewToFront(self.viewCards)
        self.btnReset.setTitle("Open cards", for: .normal)
        
        self.btnReset.layer.cornerRadius = 25
        self.btnShuffle.layer.cornerRadius = 25
        
        self.btnReset.isHidden = false
        self.viewCards.isHidden = false
        
        self.btnFirst.isExclusiveTouch = true
        self.btnSec.isExclusiveTouch = true
        self.btnThird.isExclusiveTouch = true
        self.btnFourth.isExclusiveTouch = true
        self.btnFifth.isExclusiveTouch = true
        self.btnSec.isExclusiveTouch = true
        
        halfWidthCards = self.view.frame.width/2
        halfHeightCards = UIScreen.main.bounds.height / 2
        
        let heightView = UIScreen.main.bounds.height - 40
        btnShowCorner.frame = CGRect(x: 20, y: heightView - 225 , width: widthCard, height: heightCard)
        
        sixBtnY = heightView - 210
        fifthBtnY = heightView - 215
        fourBtnY = heightView - 210
        thirdBtnY = heightView - 215
        secondBtnY = heightView - 220
        firstBtnY = heightView - 225
        CardNamesForChangeDeck.shared.intLastSelected = 1
        setImagesOneByOne()
    }
    
    func setImagesBackToDeck(){
        widthCard = 120
        heightCard = 170
        
        self.btnSix.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.btnFifth.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.btnFourth.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.btnThird.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.btnSec.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.btnFirst.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.btnFirst.setTitle("", for: .normal)
        self.btnSec.setTitle("", for: .normal)
        self.btnThird.setTitle("", for: .normal)
        self.btnFourth.setTitle("", for: .normal)
        self.btnFifth.setTitle("", for: .normal)
        self.btnSix.setTitle("", for: .normal)
        
        self.btnSix.frame = CGRect(x: 20, y: self.sixBtnY , width: widthCard, height: heightCard)
        self.btnFifth.frame = CGRect(x: 20, y: self.fifthBtnY , width: widthCard, height: heightCard)
        self.btnFourth.frame = CGRect(x: 20, y: self.fourBtnY , width: widthCard, height: heightCard)
        self.btnThird.frame = CGRect(x: 20, y: self.thirdBtnY , width: widthCard, height: heightCard)
        self.btnSec.frame = CGRect(x: 20, y: self.secondBtnY , width: widthCard, height: heightCard)
        self.btnFirst.frame = CGRect(x: 20, y: self.firstBtnY , width: widthCard, height: heightCard)
        
        //        self.btnSec.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.btnSix.isUserInteractionEnabled = true
        self.btnFifth.isUserInteractionEnabled = true
        self.btnFirst.isUserInteractionEnabled = true
        self.btnSec.isUserInteractionEnabled = true
        self.btnThird.isUserInteractionEnabled = true
        self.btnFourth.isUserInteractionEnabled = true
    }
    
    func setImagesOneByOne(){
        setImagesBackToDeck()
        changeCardDeck(isChangeDeck: false)
        setImagesSequence()
    }
    
    func setImagesSequence(){
        
        self.viewCards.bringSubviewToFront(btnFirst)
        self.viewCards.bringSubviewToFront(btnSec)
        self.viewCards.bringSubviewToFront(btnThird)
        self.viewCards.bringSubviewToFront(btnFourth)
        self.viewCards.bringSubviewToFront(btnFifth)
        self.viewCards.bringSubviewToFront(btnSix)
        
        self.btnFirst.setTitle("", for: .normal)
    }
    
    //MARK: **** UPDATE POINTS ON SERVER : Card action ****
    @IBAction func actionBtnCenter(_ sender: UIButton) {
        
        if isInMid{
            
            isInMid = false
            self.widthCard = 150
            self.heightCard = 200
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
                self.setImagesOneByOne()
            }) { (istrue) in
            }
            return
        }
        
        if isOpenMid{
            
            UIView.animate(withDuration: 0.5, animations: {
                
                let pointWidth = 1.5 * self.widthCard
                let pointHeight = 1.5 * self.heightCard
                
                let pointX = self.halfWidthCards-(pointWidth/2)
                let pointY = (UIScreen.main.bounds.height / 2) - (self.halfHeightCards/2) - 30
                self.lastSelectedNo = Int.random(in: 0...5)
                switch sender.tag {
                case 101:
                    self.btnFirst.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFirst.frame = CGRect(x:pointX , y:pointY , width:pointWidth , height: pointHeight)
                    self.btnFirst.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnFirst)
                    self.btnFirst.titleLabel?.textAlignment = .center
                    self.btnFirst.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                case 102:
                    self.btnSec.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnSec.frame = CGRect(x: pointX, y: pointY , width: pointWidth, height: pointHeight)
                    self.btnSec.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnSec)
                    self.btnSec.titleLabel?.textAlignment = .center
                    self.btnSec.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                case 103:
                    self.btnThird.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnThird.frame = CGRect(x: pointX, y: pointY , width: pointWidth, height: pointHeight)
                    self.btnThird.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnThird)
                    self.btnThird.titleLabel?.textAlignment = .center
                    self.btnThird.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                case 104:
                    self.btnFourth.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFourth.frame = CGRect(x: pointX, y: pointY , width: pointWidth, height: pointHeight)
                    self.btnFourth.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnFourth)
                    self.btnFourth.titleLabel?.textAlignment = .center
                    self.btnFourth.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                case 105:
                    self.btnFifth.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFifth.frame = CGRect(x: pointX, y: pointY , width: pointWidth, height: pointHeight)
                    self.btnFifth.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnFifth)
                    self.btnFifth.titleLabel?.textAlignment = .center
                    self.btnFifth.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                case 106:
                    self.btnSix.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnSix.frame = CGRect(x: pointX, y: pointY , width: pointWidth, height: pointHeight)
                    self.btnSix.transform = CGAffineTransform(scaleX: -1, y: 1)
                    self.viewCards.bringSubviewToFront(self.btnSix)
                    self.btnSix.titleLabel?.textAlignment = .center
                    self.btnSix.setBackgroundImage(UIImage(named: self.arrImgesPrice[self.lastSelectedNo])
                        , for:.normal)
                    
                    
                    
                default: break
                }
            }) { (isTrue) in
                self.isInMid = true
                self.isOpenMid = false
                self.btnReset.isHidden = true
                self.btnShuffle.isHidden = true
                
                self.btnFifth.isUserInteractionEnabled = false
                self.btnFirst.isUserInteractionEnabled = false
                self.btnSec.isUserInteractionEnabled = false
                self.btnThird.isUserInteractionEnabled = false
                self.btnFourth.isUserInteractionEnabled = false
                self.btnSix.isUserInteractionEnabled = false
                
                
                let textString = self.returnAttributedStringForAlertPopUp(textContext: "\n\n \(self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue)", winningPrice: "\(self.spinningWheel.slices [self.adminSeletedSliceToStop].rewardValue)", fontSizepts: 30, fintSizeWinPrice: 40)
                
                switch sender.tag {
                    
                case 101:
                    self.btnFirst.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFirst.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnFirst.setAttributedTitle(textString, for: .normal)
                    
                case 102:
                    self.btnSec.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnSec.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnSec.setAttributedTitle(textString, for: .normal)
                    
                case 103:
                    self.btnThird.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnThird.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnThird.setAttributedTitle(textString, for: .normal)
                    
                case 104:
                    self.btnFourth.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFourth.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnFourth.setAttributedTitle(textString, for: .normal)
                    
                case 105:
                    self.btnFifth.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnFifth.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnFifth.setAttributedTitle(textString, for: .normal)
                    
                case 106:
                    self.btnSix.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.btnSix.titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 30)!
                    self.btnSix.setAttributedTitle(textString, for: .normal)
                    
                default: break
                }
                
                // *********************************
                self.showPopUpPointsWithFirework()
                if self.isTrialOrRewardSpin == true {
                    self.setTrialSpinData()
                }else{
                    self.setSpinData()
                }
                self.unhideColorOptionsWhenSpinIsRotating()
                // *********************************
            }
            return
        }
        self.isOpenMid = true
        self.btnReset.setTitle("New cards", for: .normal)
        resetCards(isChangeDeck: false)// Reset position of cards
        spreadCards()
    }
    
    /*
     func spreadCards(){
     self.btnReset.isHidden = false
     self.widthCard = 180
     self.heightCard = 230
     self.btnFirst.setTitle("", for: .normal)
     
     //        UIView.animate(withDuration: 0.5, animations: {
     // First line
     //            self.btnFifth.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2), y: 20 , width: self.widthCard, height: self.heightCard)
     
     // Second line
     self.btnFourth.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2) - (self.widthCard + 30), y: 80 , width: self.widthCard, height: self.heightCard)
     self.btnSec.frame = CGRect(x: self.halfWidthCards + (self.widthCard/2) + 30, y: 80 , width: self.widthCard, height: self.heightCard)
     
     // Third line
     self.btnThird.frame = CGRect(x: self.halfWidthCards - (self.widthCard + 10), y: 320  , width: self.widthCard, height: self.heightCard)
     self.btnFirst.frame = CGRect(x: self.halfWidthCards + 10, y: 320 , width: self.widthCard, height: self.heightCard)
     //        }) { (isTrue) in
     //        }
     
     UIView.transition(with: btnFifth, duration: 0.3, options: .transitionCurlDown, animations: {
     self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
     // First line
     self.btnFifth.isHidden = false
     self.btnFifth.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2), y: 20 , width: self.widthCard, height: self.heightCard)
     }) { (istrue) in
     UIView.transition(with: self.btnFourth, duration: 0.3, options: .transitionCurlDown, animations: {
     self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
     // Second line
     self.btnFourth.isHidden = false
     }) { (istrue) in
     UIView.transition(with: self.btnThird, duration: 0.3, options: .transitionCurlDown, animations: {
     self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
     // Third line
     self.btnThird.isHidden = false
     }) { (istrue) in
     UIView.transition(with: self.btnSec, duration: 0.3, options: .transitionCurlDown, animations: {
     self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
     // Second line
     self.btnSec.isHidden = false
     }) { (istrue) in
     UIView.transition(with: self.btnFirst, duration: 0.3, options: .transitionCurlDown, animations: {
     self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
     // Third line
     self.btnFirst.isHidden = false
     }) { (istrue) in
     
     }
     }
     }
     }
     }
     
     self.btnFourth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
     self.btnSec.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
     self.btnFifth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
     self.btnFifth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
     
     }*/
    
    func spreadCards(){
        
        btnShuffle.isUserInteractionEnabled = false
        btnReset.isUserInteractionEnabled = false
        
        self.btnReset.isHidden = false
        self.widthCard = 200
        self.heightCard = 270
        self.btnFirst.setTitle("", for: .normal)
        
        // First
        self.btnFirst.isHidden = true
        self.btnFirst.frame = CGRect(x: 100 , y: 205 , width: self.widthCard, height: self.heightCard)
        self.btnFirst.transform = self.btnFirst.transform.rotated(by: CGFloat(-(M_PI_2 * 0.9)))
        
        //  Second (self.halfWidthCards - (self.widthCard))
        self.btnSec.isHidden = true
        self.btnSec.frame = CGRect(x: 120 , y: 100 , width: self.widthCard, height: self.heightCard)
        self.btnSec.transform = self.btnSec.transform.rotated(by: CGFloat(-(M_PI_2 * 0.5)))
        
        // Third (self.halfWidthCards - (self.widthCard/2)) + 10,
        self.btnThird.isHidden = true
        self.btnThird.frame = CGRect(x: 200 , y: 30 , width: self.widthCard, height: self.heightCard)
        self.btnThird.transform = self.btnThird.transform.rotated(by: CGFloat(-(M_PI_2 * 0.2)))
        
        // Fourth
        self.btnFourth.isHidden = true
        self.btnFourth.frame = CGRect(x: self.halfWidthCards - 30, y: 30 , width: self.widthCard, height: self.heightCard)
        self.btnFourth.transform = self.btnFifth.transform.rotated(by: CGFloat((M_PI_2 * 0.2)))
        
        // Fifth (self.halfWidthCards + self.widthCard/4) - 30
        self.btnFifth.isHidden = true
        self.btnFifth.frame = CGRect(x: (self.halfWidthCards + self.widthCard/4), y: 100 , width: self.widthCard, height: self.heightCard)
        self.btnFifth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
        
        // Six
        self.btnSix.isHidden = true
        self.btnSix.frame = CGRect(x: (self.halfWidthCards + self.widthCard/3) - 3, y: 205 , width: self.widthCard, height: self.heightCard)
        self.btnSix.transform = self.btnSix.transform.rotated(by: CGFloat(M_PI_2 * 0.9))
        
        let timingCurl = 0.2
        UIView.transition(with: btnFirst, duration: timingCurl, options: .curveEaseInOut, animations: {
            self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
            self.btnFirst.isHidden = false
        }) { (istrue) in
            
            self.btnSec.isHidden = false
            self.btnSec.alpha = 0.5
            UIView.transition(with: self.btnSec, duration: timingCurl, options: .curveEaseInOut, animations: {
                self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                // First line
                self.btnSec.alpha = 1
            }) { (istrue) in
                
                self.btnThird.isHidden = false
                self.btnThird.alpha = 0.5
                UIView.transition(with: self.btnThird, duration: timingCurl, options: .curveEaseInOut, animations: {
                    self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                    // Second line
                    self.btnThird.alpha = 1
                }) { (istrue) in
                    
                    self.btnFourth.isHidden = false
                    self.btnFourth.alpha = 0.5
                    UIView.transition(with: self.btnFourth, duration: timingCurl, options: .curveEaseInOut, animations: {
                        self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                        // Third line
                        self.btnFourth.alpha = 1
                    }) { (istrue) in
                        
                        self.btnFifth.isHidden = false
                        self.btnFifth.alpha = 0.5
                        UIView.transition(with: self.btnFifth, duration: timingCurl, options: .curveEaseInOut, animations: {
                            self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                            // Second line
                            self.btnFifth.alpha = 1
                        }) { (istrue) in
                            
                            self.btnSix.isHidden = false
                            self.btnSix.alpha = 0.5
                            UIView.transition(with: self.btnSix, duration: timingCurl, options: .curveEaseInOut, animations: {
                                self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                                // Third line
                                self.btnSix.alpha = 1
                            }) { (istrue) in
                                
                                self.btnShuffle.isUserInteractionEnabled = true
                                self.btnReset.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
            
            
            // Third
            //        self.btnThird.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2 + 40), y: 20 , width: self.widthCard, height: self.heightCard)
            //        self.btnThird.transform = self.btnFifth.transform.rotated(by: CGFloat(-(M_PI_2 * 0.3)))
            //        self.btnThird.isHidden = false
            
            //        // Second line
            //        self.btnFourth.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2) - (self.widthCard + 30), y: 80 , width: self.widthCard, height: self.heightCard)
            //        self.btnSec.frame = CGRect(x: self.halfWidthCards + (self.widthCard/2) + 30, y: 80 , width: self.widthCard, height: self.heightCard)
            //
            //        // Third line
            //        self.btnThird.frame = CGRect(x: self.halfWidthCards - (self.widthCard + 10), y: 320  , width: self.widthCard, height: self.heightCard)
            //
            //        self.btnFifth.frame = CGRect(x: self.halfWidthCards - (self.widthCard/2), y: 20 , width: self.widthCard, height: self.heightCard)
            //        self.btnFifth.isHidden = false
            
            //
            //        self.btnFourth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
            //        self.btnSec.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
            //        self.btnFifth.transform = self.btnFifth.transform.rotated(by: CGFloat(M_PI_2 * 0.5))
            
        }
    }
    
    
    func resetCards(isChangeDeck : Bool){
        setImagesOneByOne()
        
        self.btnFirst.isHidden = true
        self.btnSec.isHidden = true
        self.btnThird.isHidden = true
        self.btnFourth.isHidden = true
        self.btnFifth.isHidden = true
        self.btnSix.isHidden = true
        
        if isChangeDeck{
            changeCardDeck(isChangeDeck: isChangeDeck)
        }
    }
    
    func changeCardDeck(isChangeDeck : Bool){
        
        if isChangeDeck{
            self.arrImges = CardNamesForChangeDeck.shared.getRandomCardDeck()
        }else{
            //            self.arrImges = CardNamesForChangeDeck.shared.sendArrayOfRandomCards()
        }
        
        if self.arrImges.count > 4{
            for index in 0...5{
                let imgObject = UIImage(named: self.arrImges[index])
                switch index {
                case 0:
                    self.btnFirst.setBackgroundImage(imgObject, for: .normal)
                case 1:
                    self.btnSec.setBackgroundImage(imgObject, for: .normal)
                case 2:
                    self.btnThird.setBackgroundImage(imgObject, for: .normal)
                case 3:
                    self.btnFourth.setBackgroundImage(imgObject, for: .normal)
                case 4:
                    self.btnFifth.setBackgroundImage(imgObject, for: .normal)
                case 5:
                    self.btnSix.setBackgroundImage(imgObject, for: .normal)
                    
                default:
                    break
                }
                btnShowCorner.setBackgroundImage(imgObject, for: .normal)
            }
        }
    }
    
    func curlUp() {
        
        btnShuffle.isUserInteractionEnabled = false
        btnReset.isUserInteractionEnabled = false
        
        let timingCurl = 0.2
        UIView.transition(with: btnFirst, duration: timingCurl, options: .transitionCurlDown, animations: {
            self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
            self.btnFirst.isHidden = false
        }) { (istrue) in
            UIView.transition(with: self.btnSec, duration: timingCurl, options: .transitionCurlDown, animations: {
                self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                self.btnSec.isHidden = false
            }) { (istrue) in
                UIView.transition(with: self.btnThird, duration: timingCurl, options: .transitionCurlDown, animations: {
                    self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                    self.btnThird.isHidden = false
                }) { (istrue) in
                    UIView.transition(with: self.btnFourth, duration: timingCurl, options: .transitionCurlDown, animations: {
                        self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                        self.btnFourth.isHidden = false
                    }) { (istrue) in
                        UIView.transition(with: self.btnFifth, duration: timingCurl, options: .transitionCurlDown, animations: {
                            self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                            self.btnFifth.isHidden = false
                        }) { (istrue) in
                            UIView.transition(with: self.btnSix, duration: timingCurl, options: .transitionCurlDown, animations: {
                                self.playSound(strSoundName:"bubble_pop.aac" , numberOfLoops: 0)
                                self.btnSix.isHidden = false
                            }) { (istrue) in
                                self.btnShuffle.isUserInteractionEnabled = true
                                self.btnReset.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    // CHANGE CARDS
    @IBAction func actionBtnReset(_ sender: Any) {
        if isInMid == false && isOpenMid == false {
            self.actionBtnCenter(UIButton.init())
        }else{
            self.btnReset.setTitle("New cards", for: .normal)
            setImagesBackToDeck()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.spreadCards()
            }
        }
    }
    
    // CHANGE DECK
    @IBAction func actionShuffle(_ sender: Any) {
        self.btnReset.setTitle("Open cards", for: .normal)
        setImagesOneByOne()
        isInMid = false
        isOpenMid = false
        resetCards(isChangeDeck: true)
        curlUp()
    }
    
}

