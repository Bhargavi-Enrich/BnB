//
//  EN_Service_CampaignList.swift
//  EnrichDraw
//
//  Created by Apple on 22/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
class EN_Service_CampaignList{
    private init(){}
    static let sharedInstance = EN_Service_CampaignList()
    
    func getCampaignList(callback: @escaping ApiResponse) {
        var urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getCampaignList)
//        if let userDetails = UserDefaults.standard.value(forKey: UserDefaultKeys.modelAdminProfile.rawValue) as? [String : Any], let salon_idObj =  userDetails["salon_id"] as? String {
//            urlEndpoint = String(format:"%@%@?is_custom=true",urlEndpoint, salon_idObj)
//        }
        
        if let userDetails:ModelAdminProfile = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let salon_idObj = userDetails.salon_id, !salon_idObj.isEmpty
        {
            urlEndpoint = String(format:"%@%@?is_custom=true&applicableTo=Store",urlEndpoint, salon_idObj)

        }
        
        APICallsManagerClass.shared.getAPICall(urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
            
        }
        
    }
    
}
