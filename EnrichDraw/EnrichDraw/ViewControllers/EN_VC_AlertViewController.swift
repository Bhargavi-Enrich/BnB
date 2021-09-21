//
//  EN_VC_AlertViewController.swift
//  EnrichDraw
//

//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class EN_VC_AlertViewController: UIViewController {
    
    @IBOutlet weak var imageTrophy: UIImageView!
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var lblCongratulations: UILabel!
    @IBOutlet weak var lblPrizeWonMessage: UILabel!
    @IBOutlet weak var lblTipsMessage: UILabel!
    @IBOutlet weak var btnReadyForNextSpin: UIButton!
    @IBOutlet weak var alertViewSmall: UIView!
    
    var parentObj : UIViewController?
    var isTrialOrRewardSpin:Bool = false
    var dictRewardsArray = [Int : SpinDetails]()
    
    var bombSoundEffect: AVAudioPlayer?
    var gifWithImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.alertViewSmall.layer.cornerRadius = 8
        self.alertViewSmall.backgroundColor = UIColor.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bombSoundEffect?.volume = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Set Alert Values
    func setAlertValues(congratsMessage:String = "Congratulation!",imageTrophy:String = "greenPlant",winningMessage:NSMutableAttributedString?, btnTitle : String = "kl_ReadyForNextSpin".localized, btnBackgoundImage : String = "readyForTheNextSpin", tipMessage: String)
    {
        
        self.imageTrophy.image = UIImage(named: imageTrophy)
        self.lblCongratulations.text = congratsMessage
        self.lblPrizeWonMessage.attributedText = winningMessage
        self.btnReadyForNextSpin.setTitle(btnTitle, for: UIControl.State.normal)
        self.lblTipsMessage.text = tipMessage
        self.btnReadyForNextSpin.setBackgroundImage(UIImage(named: btnBackgoundImage), for: UIControl.State.normal)
        
        self.playSound(strSoundName:"chimes.wav" , numberOfLoops: 0)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showGif()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.removeGIF()
        }
    }
    
    //MARK:- Actions
    @IBAction func actionReadyForNextSpin(_ sender: Any) {
        
        if(self.isTrialOrRewardSpin == false)
        {
            if let obj:EN_VC_SpinWheel = self.parentObj as? EN_VC_SpinWheel
            {
                if let obj1 = obj.controller as? EN_VC_RewardSpin
                {
                    if (obj1.currentSpinNumber >= dictRewardsArray.count)
                    {
                        DispatchQueue.main.async {
                            let totalRewards = EN_VC_TotalRewards.instantiate(fromAppStoryboard: .Main)
                            totalRewards.storeDetails = obj1.storeDetails
                            totalRewards.dictRewardsArray = self.dictRewardsArray
                            totalRewards.customerDetails = obj1.customerDetails
                            totalRewards.isTrial = false
                            totalRewards.campaignDetails = obj1.campaignDetails
                            self.parentObj!.navigationController?.pushViewController(totalRewards, animated: true)
                        }
                        
                    }else{
                        obj.alertOkButton();
                    }
                }
            }
            
        }else{
            if let obj: EN_VC_SpinWheel = self.parentObj as? EN_VC_SpinWheel {
                
                if let obj1 = obj.controller as? EN_VC_TrialSpin
                {
                    if (obj1.currentSpinNumber >= dictRewardsArray.count)
                    {
                        DispatchQueue.main.async {
                            let totalRewards = EN_VC_TotalRewards.instantiate(fromAppStoryboard: .Main)
                            totalRewards.storeDetails = obj1.storeDetails
                            totalRewards.dictRewardsArray = self.dictRewardsArray
                            totalRewards.customerDetails = obj1.customerDetails
                            totalRewards.isTrial = true
                            totalRewards.campaignDetails = obj1.campaignDetails
                            self.parentObj!.navigationController?.pushViewController(totalRewards, animated: true)
                        }
                        
                    }else{
                        obj.alertOkButton();
                    }
                }
                
            }
        }
        
        
        
        self.dismiss(animated: false) {
            
        }
    }
}


extension EN_VC_AlertViewController {
    
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
    
    func showGif() {
        gifView.isHidden = false
        let x = (gifView.frame.size.width / 2) - 50
        let y = (gifView.frame.size.height / 2) - 75
        if let confettiImgView2 = UIImageView.fromGif(frame: CGRect(x: x, y: y, width: 100, height: 150), resourceName: "enrichPlant"), gifWithImageView == nil {
            self.gifWithImageView = confettiImgView2
            gifWithImageView!.alpha = 1
            gifView.addSubview(gifWithImageView!)
            gifWithImageView!.startAnimating()
        }
    }
    
    func removeGIF() {
        if gifWithImageView != nil && self.gifView.subviews.contains(gifWithImageView!){
            gifWithImageView!.removeFromSuperview()
            gifWithImageView = nil
            gifView.isHidden = true
        }
    }
}
