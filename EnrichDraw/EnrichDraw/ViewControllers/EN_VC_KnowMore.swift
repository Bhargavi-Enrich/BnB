//
//  EN_VC_KnowMore.swift
//  EnrichDraw
//

//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class EN_VC_KnowMore: UIViewController {

@IBOutlet weak var lblLocation: UILabel!
 @IBOutlet weak var lblCampaignPeriod: UILabel!
    @IBOutlet weak var lblTotalRewards: UILabel!
    @IBOutlet weak var lblFortnigtText: UILabel!
    @IBOutlet weak var lblLuxuryText: UILabel!
    @IBOutlet weak var viewDrawLine: UIView!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!


    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()

    var totalRewards:String = " "
    let urlIpad = Bundle.main.url(forResource: "animationsteps1", withExtension: "m4v")
    var playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()

        lblLocation.text = storeDetails.storeName ?? ""
        // Do any additional setup after loading the view.
        self.InitialSetup()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "")
        
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

        
        playVideo(urlIpad!)
//        NotificationCenter.default.addObserver(self, selector: #selector(EN_VC_TotalRewards.dismissVideoScreen), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil)
        { notification in
            let t1 = CMTimeMake(value: 0, timescale: 1);
            self.player.seek(to: t1)
            self.player.play()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerLayer.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissVideoScreen() {
//        self.playerLayer.removeFromSuperlayer()
//        NotificationCenter.default.removeObserver(self)
        self.player.playImmediately(atRate: 1.0)
        self.player.play()
    }
    
    //MARK:- InitialSetup
     func InitialSetup() {
        
        let textForTotalRewards = "kl_WonMsg1".localized + "kl_WonMsgTotal".localized + String(format:"%.0fpts",totalRewards) + "kl_RedeemMsg".localized
//        let textForTotalRewards = String(format:"You have won a total %.0fpts service reward points that you can redeem within the next 45 days at any Enrich Salon",totalRewards)
        self.lblTotalRewards.attributedText = self.returnAttributedStringForAlertPopUp(textContext: textForTotalRewards, winningPrice: totalRewards)
        
        let textForForthnight = String(format:"Luxury Merchandise worth ₹ 1,00,000 (1st Prize) and eight other prizes worth ₹ 50,000 each")
        self.lblFortnigtText.attributedText = self.returnAttributedStringForAlertPopUp(textContext: textForForthnight, winningPrice: totalRewards)
        
        let textForlblLuxuryText = String(format:"Luxury Merchandise worth ₹ 2,50,000")
        self.lblLuxuryText.attributedText = self.returnAttributedStringForAlertPopUp(textContext: textForlblLuxuryText, winningPrice: totalRewards)
        
    }
    
    //MARK: Video
    func playVideo(_ movieURL : URL) {

        let videoView = UIView(frame: self.view.frame)
        
        let playerItem = AVPlayerItem(url: movieURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
       
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        videoView.layer.addSublayer(playerLayer)
        self.view.addSubview(videoView)
        self.view.sendSubviewToBack(videoView)
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        player.automaticallyWaitsToMinimizeStalling = true
        
        //allows other apps to keep playing audio files
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        player.play()
    }
    
    //MARK:- Actions
    @IBAction func actionBtnPlace(_ sender: Any) {
       // popupAction()
    }
    //MARK:- Actions
    @IBAction func actionOkGotIt(_ sender: Any) {
        self.navigationController?.popToVC(ofKind: EN_VC_LandingScreen.self)
        
    }
    @IBAction func actionMyRewards(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func returnAttributedStringForAlertPopUp(textContext:String, winningPrice:String)-> NSMutableAttributedString{
        return self.returnAttributedStringForAlertPopUp(textContext: textContext, winningPrice: winningPrice, fontSizepts: 14.0, fintSizeWinPrice: 20.0)
    }
    
    func returnAttributedStringForAlertPopUp(textContext:String, winningPrice:String, fontSizepts : CGFloat, fintSizeWinPrice : CGFloat)-> NSMutableAttributedString {
        let textString = NSMutableAttributedString(string: textContext, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Quicksand-Medium", size: 16)!])
        textString.setColorForText(textForAttribute:String(format: "pts" ) , withColor: UIColor(red:239/255, green:41/255, blue:118/255, alpha:1), withFont: UIFont(name: "Quicksand-Medium", size: fontSizepts)!)
        textString.setColorForText(textForAttribute:String(format: "%@",winningPrice ) , withColor: UIColor(red:239/255, green:41/255, blue:118/255, alpha:1), withFont: UIFont(name: "Quicksand-Medium", size: fintSizeWinPrice)!)
        textString.setColorForText(textForAttribute:"₹1,00,000 (1st Prize)", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        textString.setColorForText(textForAttribute:"₹25,000", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        textString.setColorForText(textForAttribute:"₹2,50,000", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        return textString
    }
}

extension EN_VC_KnowMore : UIPopoverPresentationControllerDelegate
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
