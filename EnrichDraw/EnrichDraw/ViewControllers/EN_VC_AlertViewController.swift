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
    @IBOutlet weak var spinLeftStackView: UIStackView!
    @IBOutlet weak var spinLeftLabel: UILabel!
    @IBOutlet weak var btnClosed: UIButton!
    @IBOutlet weak var lblCollectionViewSpacer: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parentObj : UIViewController?
    var isTrialOrRewardSpin:Bool = false
    var dictRewardsArray = [Int : SpinDetails]()
    
    var bombSoundEffect: AVAudioPlayer?
    var gifWithImageView: UIImageView?
    
    let spinLeftText = "3 MORE SPINS"
    
    @IBOutlet weak var collectionViewConstraintWidth: NSLayoutConstraint!
    var listOfGifts: [assured_gift_details] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.alertViewSmall.layer.cornerRadius = 20
        //self.alertViewSmall.backgroundColor = UIColor.white
        
        self.spinLeftStackView.isHidden =  self.appDelegate.totalEligibleSpinCountsAgainstAllInvoices <= 0
        
        let normalText = "You have "
        let boldText = "\(self.appDelegate.totalEligibleSpinCountsAgainstAllInvoices)" + " MORE SPINS "
        let normalTextEnd = "left"
        let attributedString = NSMutableAttributedString(string:normalText)
        let attributedStringEnd = NSMutableAttributedString(string:normalTextEnd)
        let attrs = [NSAttributedString.Key.font : UIFont.init(name: FontName.FuturaPTHeavy, size: 16)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
        attributedString.append(attributedStringEnd)
        self.spinLeftLabel.attributedText = attributedString
        
        
        //self.btnReadyForNextSpin.setBackgroundImage(UIImage(named: "spinAgain-button"), for: .normal)
        //self.btnReadyForNextSpin.setTitle("SPIN AGAIN  >", for: .normal)
        //self.btnReadyForNextSpin.setBackgroundImage(UIImage(named: "enableButton"), for: .normal)
        //self.btnReadyForNextSpin.setTitle("CLOSE  >", for: .normal)
        
        self.lblCollectionViewSpacer.isHidden = false
        self.collectionView.isHidden = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "SurpriseGiftCell", bundle: nil), forCellWithReuseIdentifier: "SurpriseGiftCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.flashScrollIndicators()
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
    func setAlertValues(congratsMessage:String = "WOOHOO!",imageTrophy:String = "greenPlant",winningMessage:NSMutableAttributedString?, surpriseGifts : [assured_gift_details] , btnTitle : String = "kl_ReadyForNextSpin".localized, btnBackgoundImage : String = "readyForTheNextSpin", tipMessage: String)
    {
        
        self.imageTrophy.image = UIImage(named: imageTrophy)
        self.lblCongratulations.text = congratsMessage
        self.lblPrizeWonMessage.attributedText = winningMessage?.uppercased()
        self.btnReadyForNextSpin.setTitle(btnTitle, for: UIControl.State.normal)
        //self.lblTipsMessage.text = tipMessage
        //self.btnReadyForNextSpin.setBackgroundImage(UIImage(named: btnBackgoundImage), for: UIControl.State.normal)
        
        if btnTitle.containsIgnoreCase("NEXT SPIN  >")  {
            //self.btnReadyForNextSpin.setTitleColor(UIColor(red: 232.0/255.0, green: 34.0/255.0, blue: 46.0/255.0, alpha: 1.0), for: . normal)
            lblTipsMessage.text = "They have been added to your ENRICH WALLET"
        }
        
        else
        {
            //self.btnReadyForNextSpin.setTitleColor(UIColor.white, for: . normal)
            //self.btnReadyForNextSpin.setBackgroundImage(UIImage(named: "enableButton"), for: UIControl.State.normal)

        }
        
        
//        if btnTitle == "Show All Rewards"
//        {
//            self.lblCongratulations.text = "Uh-oh!"
//            self.lblPrizeWonMessage.text = "You have 0 spins left."
//            self.spinLeftLabel.text = String (format: "Spend Rs. %@ or more to spin the wheel.",campaignDetails.threshold ?? "")
//
//        }
//        else
//        {
//            if btnTitle.containsIgnoreCase("SPIN AGAIN  >")  {
//                lblTipsMessage.text = "They have been added to your Enrich Wallet."
//
//        }
//        }
//        if winningMessage?.string == "You have 0 spins left." {
//            self.spinLeftLabel.text = String (format: "Spend Rs. %@ or more to spin the wheel.",campaignDetails.threshold ?? "")
//        }
        
    
        
        self.btnReadyForNextSpin.setTitle(btnTitle, for: UIControl.State.normal)
        
        
        
        self.playSound(strSoundName:"chimes.wav" , numberOfLoops: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showGif()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.removeGIF()
        }
        
        self.listOfGifts = surpriseGifts
        switch self.listOfGifts.count {
        case 0:
            self.lblCollectionViewSpacer.isHidden = true
            self.collectionView.isHidden = true
            break

        case 1:
            collectionViewConstraintWidth.constant = 206.0
            break

        case 2:
            collectionViewConstraintWidth.constant = 424.0
            break

        default:
            collectionViewConstraintWidth.constant = 550.0
            break
        }
        self.collectionView.reloadData()
        
    }
    
    
    
    //MARK:- Actions
    @IBAction func actionReadyForNextSpin(_ sender: Any) {
        
        
        
        self.dismiss(animated: false) {
            if(self.isTrialOrRewardSpin == false)
            {
                if let obj:EN_VC_SpinWheel = self.parentObj as? EN_VC_SpinWheel
                {
                    if let obj1 = obj.controller as? EN_VC_RewardSpin
                    {
                        if (obj1.currentSpinNumber >= self.dictRewardsArray.count)
                        {
                            obj.alertOkButton();

                            /*DispatchQueue.main.async {
                                let totalRewards = EN_VC_TotalRewards.instantiate(fromAppStoryboard: .Main)
                                totalRewards.storeDetails = obj1.storeDetails
                                totalRewards.dictRewardsArray = self.dictRewardsArray
                                totalRewards.customerDetails = obj1.customerDetails
                                totalRewards.isTrial = false
                                totalRewards.campaignDetails = obj1.campaignDetails
                                self.parentObj!.navigationController?.pushViewController(totalRewards, animated: true)
                            }*/
                            
                        }else{
                            obj.alertOkButton();
                        }
                    }
                }
                
            }else{
                if let obj: EN_VC_SpinWheel = self.parentObj as? EN_VC_SpinWheel {
                    
                    if let obj1 = obj.controller as? EN_VC_TrialSpin
                    {
                        if (obj1.currentSpinNumber >= self.dictRewardsArray.count)
                        {
                            /*DispatchQueue.main.async {
                                let totalRewards = EN_VC_TotalRewards.instantiate(fromAppStoryboard: .Main)
                                totalRewards.storeDetails = obj1.storeDetails
                                totalRewards.dictRewardsArray = self.dictRewardsArray
                                totalRewards.customerDetails = obj1.customerDetails
                                totalRewards.isTrial = true
                                totalRewards.campaignDetails = obj1.campaignDetails
                                self.parentObj!.navigationController?.pushViewController(totalRewards, animated: true)
                            }*/
                                
                            let alert = UIAlertController(title:"Alert!", message: "You have already availed all the trials.", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                // Do nothing
                                self.navigationController?.popToViewController(ofClass: EN_VC_LandingScreen.self, animated: false)

                            }))
                            self.parentObj?.present(alert, animated: true, completion: nil)
                            
                        }else{
                            obj.alertOkButton();
                        }
                    }
                    
                }
            }
            
            
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
        let x = (gifView.frame.size.width / 2)  - 150
        let y = (gifView.frame.size.height / 2)  - 130 //width: 100, height: 150),
        
        if let confettiImgView2 = UIImageView.fromGif(frame: CGRect(x: x, y: y, width: 300, height: 280), resourceName: "gif1"), gifWithImageView == nil {
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


extension EN_VC_AlertViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfGifts.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurpriseGiftCell", for: indexPath) as! SurpriseGiftCell
        
        cell.configureCell(gift_details: self.listOfGifts[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 206, height: 60)
    }
}
