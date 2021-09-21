//
//  MyOrderCell.swift
//  EnrichDraw
//
//  Created by Harshal on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol MyOrderDelegate: class {
    func actionPlaySpinGame(indexPath: IndexPath)
}

class MyOrderCell: UITableViewCell {
    
    @IBOutlet weak private var lblOrderTitle: UILabel!
    @IBOutlet weak private var lblOrderValue: UILabel!
    @IBOutlet weak private var lblStatusTitle: UILabel!
    @IBOutlet weak private var lblStatusValue: UILabel!
    @IBOutlet weak private var lblDateTitle: UILabel!
    @IBOutlet weak private var lblDateValue: UILabel!
    @IBOutlet weak private var lblShipTo: UILabel!
    @IBOutlet weak private var lblShipToValue: UILabel!
    @IBOutlet weak private var lblTotalTitle: UILabel!
    @IBOutlet weak private var lblTotalValue: UILabel!
    
    // Spin count
    @IBOutlet weak var lblSpin: UILabel!
    @IBOutlet weak var viewSpinCount: UIView!
    @IBOutlet weak var lblTextSpin: UILabel!
    
    weak var delegate: MyOrderDelegate?
    private var indexPath = IndexPath(row: 0, section: 0)
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionSpinCount(_ sender: UIButton) {
        delegate?.actionPlaySpinGame(indexPath: indexPath)
    }
    
    func configureCell(model: MyProductOrdersModuleModel.GetMyOrders.Orders, indexPaths: IndexPath, selectedCampaign: ModelRunningCampaignListData) {
        
        indexPath = indexPaths
        
        lblOrderValue.text = model.increment_id ?? "NA"
        lblStatusValue.text = model.order_status ?? "NA"
       // lblShipTo.isHidden = true
       // lblShipToValue.isHidden = true
        
//        if (model.address?.shipping_address) != nil {
//            lblShipTo.isHidden = false
//            lblShipToValue.isHidden = false
//        }
        
        if let orderDate = model.created_at, !orderDate.isEmpty {
                let date = orderDate.getFormattedDatehh()
                let fullDate = String(format: "%@%@ %@ %@", date.dayYearMonthDate.getFormattedDateForEditProfile().dayDateName, date.dayYearMonthDate.getFormattedDateForEditProfile().daySuffix(), date.dayYearMonthDate.getFormattedDateForEditProfile().monthNameFirstThree, date.dayYearMonthDate.getFormattedDateForEditProfile().OnlyYear)
                lblDateValue.text = fullDate
        }
                
        lblShipToValue.text = String(format: "%@ %@", model.first_name ?? "", model.last_name ?? "")
        lblTotalValue.text = " ₹ \(model.grand_total?.toDouble() ?? 0)"
        
        // Spin count
        viewSpinCount.isHidden = true
        
        let applicableCampaign = model.greenrich?.applicable_campaigns?.first {
            $0.entity_id == selectedCampaign.entity_id
        }
        
        if applicableCampaign != nil,
            let spinDetails =  model.greenrich?.spin_details, !spinDetails.isEmpty, let spinFirst = spinDetails.first, let spinCount = spinFirst.remaining_spins, spinCount > 0 {
            viewSpinCount.isHidden = false
            lblSpin.text = "\(spinCount)"
            lblTextSpin.text = "Based on your invoice amount, you are eligible to ride the Virtuous Cycle \(spinCount) times, and win upto 10 times your spend."
            
            lblSpin.layer.cornerRadius = 25; // this value vary as per your desire
            lblSpin.clipsToBounds = true;
        }
    }
}
