//
//  EN_VC_WinBBPopupViewController.swift
//  PaytmiOSSDK
//
//  Created by Suraj Singh on 23/09/21.
//

import UIKit

class EN_VC_WinBBPopupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var campaignDetails = ModelRunningCampaignListData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "EN_VC_WinBBPopupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EN_VC_WinBBPopupCollectionViewCell")
        self.crossButton.addTarget(self, action: #selector(self.dismissPopupScreen), for: .touchUpInside)
        
        if let logoDetails = self.campaignDetails.campaign_win_bnb_small_image, let urlObj = logoDetails.url {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: URL(string: urlObj)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EN_VC_WinBBPopupCollectionViewCell", for: indexPath) as! EN_VC_WinBBPopupCollectionViewCell
        
        cell.configureData(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 6 - 15
        return CGSize(width: size, height: size + 120)
    }
    
    @objc func dismissPopupScreen() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
