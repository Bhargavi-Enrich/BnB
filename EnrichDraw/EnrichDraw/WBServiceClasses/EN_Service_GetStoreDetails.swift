//
//  EN_Service_GetStoreDetails.swift
//  EnrichDraw
//
//  Created by Mugdha on 16/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class EN_Service_GetStoreDetails {
    private init(){}
    static let sharedInstance = EN_Service_GetStoreDetails()
    
    func getGetStoreDetails(email : String, callback: @escaping ApiResponse) {
        
        var urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getStoreDetails)
        urlEndpoint = String(format:"%@%@?is_custom=true",urlEndpoint,email)
        //print("getStoreDetails : \(urlEndpoint)")
        APICallsManagerClass.shared.getAPICall(urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
}
