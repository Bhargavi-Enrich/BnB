//
//  ServiceLogin.swift
//
//  

//

import Foundation

class EN_Service_AdminLogin{
    private init(){}
    static let sharedInstance = EN_Service_AdminLogin()
    
    //MARK: Authenticate customer invoice and mobile number
    func downloadImageAndVideos(callback: @escaping ApiResponse) {
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.imgVideoCalls)
        APICallsManagerClass.shared.getAPICall(urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    func authenticateAdmin(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.adminLogin)
        
        APICallsManagerClass.shared.postAPICall(params: userData, isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    

    
}

