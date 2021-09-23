//
//  EN_VC_CollectionViewCell.swift
//  PaytmiOSSDK
//
//  Created by Suraj Singh on 22/09/21.
//

import UIKit

class EN_VC_CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dropShadowView: UIView!
    @IBOutlet weak var startSpinView: UIView!
    @IBOutlet weak var midSpinView: UIView!
    @IBOutlet weak var completedSpinView: UIView!
    @IBOutlet weak var startSpinLabel: UILabel!
    @IBOutlet weak var numberOfSpinLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var midSpinProgressView: CircularProgressView!
    @IBOutlet weak var progressCurrentValueLabel: UILabel!
    @IBOutlet weak var midProgressCurrentValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.startSpinView.layer.borderWidth = 1.0
        self.startSpinView.layer.borderColor = UIColor(rgb: 0x7118B0).cgColor
        self.dropShadowView.backgroundColor = UIColor(rgb: 0x55068D)

        self.showProgressValue()
        
    }
    
    //configure data struct value data
    func configureData(_ indexPath:IndexPath){
        
        self.numberOfSpinLabel.text = "1st Spin"
        
        if indexPath.row == 0{
            self.midSpinView.backgroundColor = UIColor(rgb: 0x7118B0)
            self.startSpinView.isHidden = true
            self.midSpinView.isHidden = false
            self.completedSpinView.isHidden = true
            
            self.percentageOfTreatedPatient = 250
        }
        else if(indexPath.row == 1){
            self.startSpinView.backgroundColor = UIColor(rgb: 0x7118B03B)
            self.startSpinView.isHidden = false
            self.midSpinView.isHidden = true
            self.completedSpinView.isHidden = true
            
            self.startSpinLabel.text = "You Have \n 1 More Spin Left"
        }
        else if (indexPath.row == 2){
            self.completedSpinView.backgroundColor = UIColor(rgb: 0xDAB145)
            self.startSpinView.isHidden = true
            self.midSpinView.isHidden = true
            self.completedSpinView.isHidden = false
            
            self.percentageOfTreatedPatient = 300
            
        }
        else {
            self.completedSpinView.backgroundColor = UIColor(rgb: 0xDAB145)
            self.startSpinView.isHidden = true
            self.midSpinView.isHidden = true
            self.completedSpinView.isHidden = false
            
            self.percentageOfTreatedPatient = 650
            
        }
        
    }
    
    var timer = Timer()
    var percentageOfTreatedPatient = 0
    func showProgressValue() {
        self.progressCurrentValueLabel.text = String(percentageOfTreatedPatient)
        self.progressView.createCircularPath(value: Double(percentageOfTreatedPatient))
        self.progressView.progressAnimation(0.1, 0.5)
        
        self.midSpinProgressView.createCircularPath(value: Double(percentageOfTreatedPatient))
        self.midSpinProgressView.progressAnimation(0.1, 0.5)
        
        self.progressValue = 0.0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.02 , repeats: true, block: { (_) in
            self.progressValue = self.progressValue + 0.1 //0.01
        })
        
    }
    
    //ProgressView Animation
    open var progressValue: Double = 0.0 {
        didSet {
            let progressPercentage = progressValue * 100
            let percentageValueInInt: Int = progressPercentage >= Double(percentageOfTreatedPatient) ? Int(percentageOfTreatedPatient) : Int(progressPercentage)
            self.progressCurrentValueLabel.text = "\(percentageValueInInt)" // + "%"
            self.midProgressCurrentValueLabel.text = "\(percentageValueInInt)" // + "%"
        }
    }
    
}
