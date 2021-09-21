//
//  ServiceLogin.swift
//
//  

//

import Foundation

class EN_Service_AdminCampaign{
    private init(){}
    static let sharedInstance = EN_Service_AdminCampaign()
    
    func getCampaignDetails(campaignId : Int64,callback: @escaping ApiResponse) {
        
        var urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getCampaignDetails)
        urlEndpoint = String(format:"%@%d?is_custom=true",urlEndpoint,campaignId)
        APICallsManagerClass.shared.getAPICall(urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)

        }
        
    }
    
}

