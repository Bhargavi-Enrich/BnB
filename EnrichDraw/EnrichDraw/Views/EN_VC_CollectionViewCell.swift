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
    @IBOutlet weak var midNumberOfSpinLabel: UILabel!
    
    private var totalRewardsCount : Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.showProgressValue()
       
    }
    
    
    //configure data struct value data
    func configureDataNew( model :TotalWonRewardSpin,_ indexPath:IndexPath, totalNumberOfRecords: Int ){
        
        self.startSpinView.isHidden = true
        self.midSpinView.isHidden = true
        self.completedSpinView.isHidden = true
        
        let spinNumber = indexPath.row + 1
        if(model.cellType == TypeOfCell.lock){
            
            self.startSpinView.isHidden = false
            self.midSpinView.isHidden = true
            self.completedSpinView.isHidden = true
            self.startSpinLabel.text = "You Have 1\n More Spin Left"
            
        }
        else if (model.cellType == TypeOfCell.gold){
            //self.progressCurrentValueLabel.text = String(model.amountWon)

            self.startSpinView.isHidden = true
            self.midSpinView.isHidden = true
            self.completedSpinView.isHidden = false
            
            self.percentageOfTreatedPatient = Int(model.amountWon)!
            self.setProgresValue(model.circularProgress)
            self.progressCurrentValueLabel.text = String(percentageOfTreatedPatient)
            self.numberOfSpinLabel.text = "\(spinNumber.ordinal) Spin"
        }
        else if (model.cellType == TypeOfCell.blue) {
            
            self.startSpinView.isHidden = true
            self.midSpinView.isHidden = false
            self.completedSpinView.isHidden = true
            //self.progressCurrentValueLabel.text = model.amountWon
            self.percentageOfTreatedPatient = Int(model.amountWon)!
            self.setProgresValue(model.circularProgress)
            self.midProgressCurrentValueLabel.text = String(percentageOfTreatedPatient)
            self.midNumberOfSpinLabel.text = "\(spinNumber.ordinal) Spin"
        }
        
        
    }
    
    var timer = Timer()
    var percentageOfTreatedPatient = 0
//    func showProgressValue() {
//
//        self.progressValue = 0.0
//        self.timer = Timer.scheduledTimer(withTimeInterval: 0.02 , repeats: true, block: { (_) in
//            self.progressValue = self.progressValue + 0.1 //0.01
//        })
//
//    }
    
    func setProgresValue(_ value:Float){
        self.progressCurrentValueLabel.text = String(percentageOfTreatedPatient)
        self.progressView.createCircularPath(value: Double(percentageOfTreatedPatient))
        self.progressView.progressAnimation(0.1, value)
        
        self.midSpinProgressView.createCircularPath(value: Double(percentageOfTreatedPatient))
        self.midSpinProgressView.progressAnimation(0.1, value)
    }
    
  /*  //ProgressView Animation
    open var progressValue: Double = 0.0 {
        didSet {
            let progressPercentage = progressValue * 100
            let percentageValueInInt: Int = progressPercentage >= Double(percentageOfTreatedPatient) ? Int(percentageOfTreatedPatient) : Int(progressPercentage)
            self.progressCurrentValueLabel.text = "\(percentageValueInInt)" // + "%"
            self.midProgressCurrentValueLabel.text = "\(percentageValueInInt)" // + "%"
        }
    }*/
    
}

extension Int {

    var ordinal: String {
        var suffix: String
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "\(self)\(suffix)"
    }

}
