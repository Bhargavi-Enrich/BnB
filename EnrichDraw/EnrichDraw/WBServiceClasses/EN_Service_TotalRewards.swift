//
//  EN_Service_TotalRewards.swift
//  EnrichDraw
//
//  Created by Mugdha on 14/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class EN_Service_TotalRewards {
    private init(){}
    static let sharedInstance = EN_Service_TotalRewards()
    
    func getTotalRewards( userData: [String: Any]?, callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getStoreRewards)
        
        APICallsManagerClass.shared.postAPICall(params: userData,isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    func getRecycleRewards(customerId : String, callback: @escaping ApiResponse) {
        
        var urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getRecycleReward)
        urlEndpoint = String(format:"%@%@?is_custom=true",urlEndpoint,customerId)
        APICallsManagerClass.shared.getAPICall(urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
}
