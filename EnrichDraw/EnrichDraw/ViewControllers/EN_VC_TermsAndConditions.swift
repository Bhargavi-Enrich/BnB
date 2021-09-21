//
//  EN_VC_TermsAndConditions.swift
//  iPadEnrichApp
//
//  Created by Mugdha Mundhe on 8/29/18.
//  Copyright © 2018 ezest. All rights reserved.
//

import UIKit
import WebKit
class EN_VC_TermsAndConditions: UIViewController//, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var btnDisagree: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblTermsAndConditions: UILabel!
    @IBOutlet weak var btnPlace: UIButton!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgbackground: UIImageView!

    @IBOutlet weak var webViewTermsAndCondition: WKWebView!
    var storeDetails = StoreDetails()
    var campaignDetails = ModelRunningCampaignListData()

    
//    var arrTermsAndConditions = ["1.  This offer is valid from 1st October to 31st December 2018 across all Enrich outlets",
//                                 "2.  This offer cannot be clubbed with any other offer or membership discount",
//                                 "3.  Every invoice of ₹2,500 (excluding GST) & multiple thereof is eligible for this offer",
//                                 "4.  Service reward points you win today will be activated within two working days and will have 45 days validity",
//                                 "5.  All offer subscribers are eligible for the fortnightly draw",
//                                 "6.  Winners of the fortnightly lucky draws are also eligible for the grand lucky draw",
//                                 "7.  Winners of lucky draws will be announced and updated on enrich website in the following week of the draw date",
//                                 "8.  TDS will be applicable on all lucky draw prizes",
//                                 "9.  Lucky draw Prize Money cannot be exchanged for cash",
//                                 "10. Winners have to claim & collect the prizes within seven days from the date of announcement",
//                                 "11. Enrich employees or their immediate family members are not eligible to participate in any lucky draw",
//                                 "12. Enrich retains the right to change this offer as required and even to foreclose it without prior notice",
//                                 "13. For more details visit enrichsalon.com/beautyandbling"]
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCopyRight.text = self.getCopyRight()

        
        // Do any additional setup after loading the view.
//        self.updateImage(imageView: self.imgbackground, imageData: self.campaignDetails.backgroundImage ?? Data(), defaultImageName: "appBackground.png")
//        self.updateImage(imageView: self.imgViewBBLogo, imageData: self.campaignDetails.campaignLogo ?? Data(), defaultImageName: "")
        
        if let logoDetails = self.campaignDetails.campaign_background_image, let urlObj = logoDetails.url {
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imgbackground.image = image
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


        self.btnPlace.setTitle(storeDetails.storeName ?? "", for: .normal)
//        tblTermsAndConditions.delegate = self
//        tblTermsAndConditions.dataSource = self
//        tblTermsAndConditions.backgroundColor = UIColor.clear
        addGradientToDisAgreeButton()
        
//        let myVariable = "<font face='Montserrat-Regular' size='6' color= 'black'>%@"
//        let varObj = String(format: myVariable, (self.campaignDetails.term_condition ?? "<html><body><p>Hello1!</p><div style=\"color:#000000\"></body></html>"))

    self.webViewTermsAndCondition.loadHTMLString(self.campaignDetails.term_condition ?? "", baseURL: nil)
        self.webViewTermsAndCondition!.scrollView.backgroundColor = UIColor.clear
    }
    //MARK: - Add Gradient
    
    func addGradientToDisAgreeButton()
    {
        self.btnDisagree.layer.cornerRadius = 25
        self.btnDisagree.backgroundColor = UIColor(red:0.14, green:0.15, blue:0.22, alpha:1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func actionBtnBack(_ sender: Any) {
        self.appDelegate.appLaunch()
    }
    
    //MARK: - UITableViewDelegates
  /*  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTermsAndConditions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if(indexPath.row == arrTermsAndConditions.count-1)
        {
            guard let url = URL(string: "http://enrichsalon.com/beautyandbling") else {
                return //be safe
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(arrTermsAndConditions[indexPath.row])")
        attributedString.setColorForText(textForAttribute: attributedString.string, withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Regular", size: 16)!)
        
        // Bold middle strings
        attributedString.setColorForText(textForAttribute: "1st October to 31st December 2018",withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        attributedString.setColorForText(textForAttribute: "two working days", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        attributedString.setColorForText(textForAttribute: "45 days validity", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        attributedString.setColorForText(textForAttribute: "₹2,500 (excluding GST)", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        attributedString.setColorForText(textForAttribute: "seven days", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        attributedString.setColorForText(textForAttribute: "enrichsalon.com/beautyandbling", withColor: UIColor.black, withFont: UIFont(name: "Quicksand-Medium", size: 16)!)
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.numberOfLines = 0
        let textLayer = UILabel(frame: CGRect(x: 136, y: 150, width: 842, height: 390))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }*/
    
    //MARK:- IBActions
    @IBAction func actionAgreeAndContinue(_ sender: Any) {
        let spinWheelController = EN_VC_CutomerAuthenticate.instantiate(fromAppStoryboard: .Main)
        spinWheelController.storeDetails = self.storeDetails
        spinWheelController.campaignDetails = self.campaignDetails
        spinWheelController.isTrial = false
        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }
    
    @IBAction func actionDisagree(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actionBtnPlace(_ sender: Any) {
       // popupAction()
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

extension EN_VC_TermsAndConditions : UIPopoverPresentationControllerDelegate
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
