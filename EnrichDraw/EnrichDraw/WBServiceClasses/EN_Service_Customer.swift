//
//  ServiceLogin.swift
//
//  

//

import Foundation

class EN_Service_Customer{
    private init(){}
    static let sharedInstance = EN_Service_Customer()
    
    //MARK: Update Server on each spin
    func updateCustomerSpinDetails(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.updateCustomerSpinDetails)
        
        APICallsManagerClass.shared.postAPICall(params: userData,isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    func getWinningDetails(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getWinningDetails)
        
        APICallsManagerClass.shared.postAPICall(params: userData,isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    //MARK: Authenticate customer invoice and mobile number
    func authenticateCustomerWithInvoiceAndMobile(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.customerAuthentication)
        
        APICallsManagerClass.shared.postAPICall(params: userData,isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    //MARK: Validate customer OTP
    func validateOtp(_ userData: [String: Any]?,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.validateOtp)
        
        APICallsManagerClass.shared.postAPICall(params: userData,isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
    //MARK: Validate customer OTP
    func getMyOrders(_ userData: [String: Any]?, accessToken: String ,callback: @escaping ApiResponse) {
        
        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.getMyOders)
        
        APICallsManagerClass.shared.postAPICall(params: userData, Headers: ["Authorization": "Bearer \(accessToken)"], urlString: urlEndpoint){ (errorCode, errorMsg, dictData) in
            callback(errorCode, errorMsg, dictData)
        }
    }
    
}

