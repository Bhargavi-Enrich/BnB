//
//  EN_VC_Setting.swift
//  EnrichDraw
//
//  Created by Mugdha on 26/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import PKHUD

protocol delegateAzureCallBack {
    func refreshData()
    func showError(errorMsg: String)
    func refresh()
}


class EN_VC_Setting: UIViewController,delegateAzureCallBack {
    
    @IBOutlet weak var imgEnrich: UIImageView!
    @IBOutlet weak var tblImages: UICollectionView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var btnEnrichImg: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var imgViewBBLogo: UIImageView!
    @IBOutlet private weak var imgbackground: UIImageView!
    @IBOutlet weak var lblCopyRight: UILabel!
    
    var campaignDetails = ModelRunningCampaignListData()
    
    
    
    @IBAction func actionBtnSync(_ sender: Any) {
        //        HUD.show(.labeledProgress(title: "", subtitle: "Please wait."), onView: self.view)
        //        EN_Service_GetAzureData.sharedInstance.delegate = self
        //        EN_Service_GetAzureData.sharedInstance.azureConnection()
        appDelegate.downloadImagesVideos()
        //        self.btnSync.isEnabled = false
        //        self.btnSync.setTitle("Sync in progress", for: .normal)
    }
    
    @IBAction func actionBtnEnrichImg(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.array(forKey: gUDKeyImagesVideosData) as? [[String : Any]] {
            var gListOfImages : [[String : Any]]? = []
            
            for model in data {
                if let strURL = model["url"] as? String, !strURL.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty, let _ = model["id"] as? String {
                    gListOfImages?.append(model)
                    
                }
                
                self.appDelegate.gListOfImages = gListOfImages
            }
        }
        self.lblCopyRight.text = self.getCopyRight()
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
        
        
        self.tblImages.delegate = self
        self.tblImages.dataSource = self
        self.tblImages.reloadData()
        
        self.btnSync.isEnabled = true
        self.btnSync.setTitle("Sync", for: .normal)
        //        EN_Service_GetAzureData.sharedInstance.delegate = self
        
        //        if (EN_Service_GetAzureData.sharedInstance.isInSync)
        //        {
        //            self.btnSync.setTitle("Sync in progress", for: .normal)
        //            self.btnSync.isEnabled = false
        //        }
        
        self.lblPlace.text = ""
        
        guard let userDetailsObj = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let storeIdObj = userDetailsObj.salon_id, !storeIdObj.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            self.lblPlace.text = userDetailsObj.base_salon_name ?? "My Salon"
        }
    }
    
    //delegateAzureCallBack
    func refreshData()
    {
        //        self.appDelegate.gListOfImages = self.appDelegate.gListOfImages?.sorted { $0.name! < $1.name! }
        self.tblImages.reloadData()
        HUD.hide()
        self.btnSync.setTitle("Sync", for: .normal)
        self.btnSync.isEnabled = true
    }
    
    func refresh()
    {
        //        self.appDelegate.gListOfImages = self.appDelegate.gListOfImages.sorted { $0.name! < $1.name! }
        self.tblImages.reloadData()
    }
    
    func showError(errorMsg: String) {
        // Show error msg
        //        HUD.hide()
    }
}

extension EN_VC_Setting : UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((self.appDelegate.gListOfImages ?? []).count == 0) {
            self.tblImages.setEmptyMessage("No data found")
        } else {
            self.tblImages.restore()
        }
        return (self.appDelegate.gListOfImages ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImagesVideosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesVideosCollectionViewCell", for: indexPath) as! ImagesVideosCollectionViewCell
        
        if let spinDetailsObj = appDelegate.gListOfImages,  spinDetailsObj.count > indexPath.row {
            let dataObj = spinDetailsObj[indexPath.row]
            // Show attributed text : name /n type
            if let strFinal = dataObj["url"] as? String, !strFinal.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty , let title = dataObj["title"] as? String, let idStr = dataObj["id"] as? String {
                let arrObj = strFinal.components(separatedBy: ".")
                let textContent = String(format:"%@\n%@",title, (arrObj.last ?? ""))
                let textString = NSMutableAttributedString(string: textContent, attributes: [
                    NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 24)!
                ])
                // Pink : UIColor(red:0.94, green:0.16, blue:0.46, alpha:1)
                textString.setColorForText(textForAttribute:textContent , withColor:UIColor.black, withFont: UIFont(name: "Montserrat-Regular", size: 24)!)
                textString.setColorForText(textForAttribute:String(format:"\n%@",(arrObj.last ?? "")) , withColor: UIColor.black, withFont: UIFont(name: "Montserrat-Regular", size: 18)!)
                cell.lblNameAndType.attributedText = textString
                
                let imgURL = GlobalFunctions.shared.getImageDirectoryURL(strName: "\(idStr)_image.jpeg").absoluteString.replacingOccurrences(of: "file:///", with: "/")
                cell.imgShow.contentMode = .scaleAspectFit
                cell.imgShow.image = UIImage(contentsOfFile: imgURL)
            }
        }
        return cell
    }
}
