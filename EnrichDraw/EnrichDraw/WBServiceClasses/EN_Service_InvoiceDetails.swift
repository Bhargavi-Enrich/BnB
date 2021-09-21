//
//  EN_Service_InvoiceDetails.swift
//  EnrichDraw
//
//  Created by Mugdha Mundhe on 9/14/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class EN_Service_InvoiceDetails {
    private init(){}
    static let sharedInstance = EN_Service_InvoiceDetails()
    
    func getInvoiceDetails(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getInvoiceDetails)
        APICallsManagerClass.shared.postAPICall(params: userData, isHeader: true,  urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            
            callback(errorCode, errorMsg, dictData)

        }
        
    }
}
