//
//  APICallsManagerClass.swift
//  Created by Mugdha Mundhe on 8/20/18.
//  Copyright © 2018 ezest. All rights reserved.
//

import UIKit

enum ReturnErrorCode : Int
{
    case Success = 0
    case Failure = 1
}

typealias ApiResponse = (_ errorCode: Int, _ error: String?, _ result:Dictionary<String, Any>?) -> Void
//MARK: -  Webservice TimeOut
public enum EN_WebServiceTimeOut: Double
{
    case webServiceTimeOut = 90.0
}


class APICallsManagerClass: NSObject
{
    var request : URLRequest?
    var session : URLSession?
    var configuration = URLSessionConfiguration.default
    
    
    static let shared = APICallsManagerClass()
    
    // ************* GET *******************
    func getAPICall(urlString:String,callback: @escaping ApiResponse)
    {
        
        // *********** NETWORK CONNECTION
        if !NetworkRechability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                callback(ReturnErrorCode.Failure.rawValue, "Network connection error", nil)
            }
        }
        
        // *********** URL CHECK
        guard let url = URL(string: urlString) else
        {
            DispatchQueue.main.async {
                callback(ReturnErrorCode.Failure.rawValue, "URL is not valid", nil)
            }
            return
        }
        
        request = URLRequest(url: URL(string: urlString)!)
        request?.httpMethod = "GET"
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        session = self.setConfiguration()
        
        print("URL-\(url)")
        
        session?.dataTask(with: request! as URLRequest, completionHandler: { data, response, error -> Void in
            
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject> {
                            DispatchQueue.main.async {
                                print(json)
                                callback(ReturnErrorCode.Success.rawValue, nil, json)
                                
                            }
                        }
                    } catch {
                        print("error")
                        DispatchQueue.main.async {
                            callback(ReturnErrorCode.Failure.rawValue,"Enabled to parse json.", nil)
                        }
                    }
                }
                else if let response = response as? HTTPURLResponse, response.statusCode == 401 && GlobalFunctions.shared.isUserLoggedIn()
                {
                    // ******** REFRESH TOCKEN CALL - Need to write condition for refresh tocken call
                    self.refreshToken(isGetRequest: true, param: [:], urlString: url.absoluteString, callback: callback)
                    
                }
                else {
                    DispatchQueue.main.async {
                        callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                }
                
            }
        }).resume()
    }
    
    // ************* POST *******************
    func postAPICall(params : Dictionary<String, Any>?, isHeader: Bool,urlString:String ,callback: @escaping ApiResponse){
        // *********** NETWORK CONNECTION
        if !NetworkRechability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                
                callback(ReturnErrorCode.Failure.rawValue, "Network connection error", nil)
            }
        }
        
        // *********** URL CHECK
        guard URL(string: urlString) != nil else
        {
            callback(1, "URL is not valid", nil)
            return
        }
        
        request = URLRequest(url: URL(string: urlString)!)
        request?.httpMethod = "POST"
        print("POST URL : \(request?.url?.description ?? "")")
        
        if isHeader
        {
            let  jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
            request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.setValue("application/json", forHTTPHeaderField: "Accept")
            request?.httpBody = jsonData
        } else {
            let postString = "username=\(params!["username"] ?? "")&password=\(params!["password"] ?? "")&grant_type=password&client_id=client&client_secret=enrich@2018"
            request?.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request?.httpBody = postString.data(using: String.Encoding.utf8)
        }
        
        session = self.setConfiguration()
        let str = String(decoding: (request?.httpBody)!, as: UTF8.self)
        print("httpBody : \(str)")
        print("headers : \(request?.allHTTPHeaderFields ?? [:])")
        
        session?.dataTask(with: request! as URLRequest, completionHandler: { data, response, error -> Void in
            
            //            self.refreshToken(isGetRequest: false, param: params!, urlString: urlString, callback: callback)
            
            if let data = data {
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                        DispatchQueue.main.async {
                            print("Response : \(json)")
                            callback(ReturnErrorCode.Success.rawValue, nil, json)
                        }
                        
                    } catch {
                        print("error")
                        DispatchQueue.main.async {
                            
                            callback(ReturnErrorCode.Failure.rawValue,"Enabled to parse json.", nil)
                        }
                    }
                    
                    
                }
                else if let response = response as? HTTPURLResponse, response.statusCode == 401 && GlobalFunctions.shared.isUserLoggedIn() {
                    
                    // ******** REFRESH TOCKEN CALL - Need to write condition for refresh tocken call
                    self.refreshToken(isGetRequest: false, param: params!, urlString: urlString, callback: callback)
                }
                    
                else {
                    DispatchQueue.main.async {
                        callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                }
                
            }
        }).resume()
        
    }
    
    func postAPICall(params : Dictionary<String, Any>?, Headers: [String: String],urlString:String ,callback: @escaping ApiResponse){
        // *********** NETWORK CONNECTION
        if !NetworkRechability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                
                callback(ReturnErrorCode.Failure.rawValue, "Network connection error", nil)
            }
        }
        
        // *********** URL CHECK
        guard URL(string: urlString) != nil else
        {
            callback(1, "URL is not valid", nil)
            return
        }
        
        request = URLRequest(url: URL(string: urlString)!)
        request?.httpMethod = "POST"
        print("POST URL : \(request?.url?.description ?? "")")
        
        let  jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        
        Headers.forEach {
            request?.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.httpBody = jsonData
        
        session = self.setConfiguration()
        let str = String(decoding: (request?.httpBody)!, as: UTF8.self)
        print("httpBody : \(str)")
        print("headers : \(request?.allHTTPHeaderFields ?? [:])")
        
        session?.dataTask(with: request! as URLRequest, completionHandler: { data, response, error -> Void in
            
            //            self.refreshToken(isGetRequest: false, param: params!, urlString: urlString, callback: callback)
            
            if let data = data {
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                        DispatchQueue.main.async {
                            print("Response : \(json)")
                            callback(ReturnErrorCode.Success.rawValue, nil, json)
                        }
                        
                    } catch {
                        print("error")
                        DispatchQueue.main.async {
                            
                            callback(ReturnErrorCode.Failure.rawValue,"Enabled to parse json.", nil)
                        }
                    }
                    
                    
                }
                else if let response = response as? HTTPURLResponse, response.statusCode == 401 && GlobalFunctions.shared.isUserLoggedIn() {
                    
                    // ******** REFRESH TOCKEN CALL - Need to write condition for refresh tocken call
                    self.refreshToken(isGetRequest: false, param: params!, urlString: urlString, callback: callback)
                }
                    
                else {
                    DispatchQueue.main.async {
                        callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
                }
                
            }
        }).resume()
        
    }
    
    //    {
    //        // *********** NETWORK CONNECTION
    //        if !NetworkRechability.isConnectedToNetwork()
    //        {
    //            callback(ReturnErrorCode.Failure.rawValue, "Network connection error", nil)
    //        }
    //
    //        // *********** URL CHECK
    //        guard URL(string: urlString) != nil else
    //        {
    //            callback(1, "URL is not valid", nil)
    //            return
    //        }
    //
    //        request = URLRequest(url: URL(string: urlString)!)
    //        request?.httpMethod = "POST"
    //
    //        if isHeader
    //        {
    //            let  jsonData = try? JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
    //            request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request?.setValue("application/json", forHTTPHeaderField: "Accept")
    //            request?.httpBody = jsonData
    //
    //        }
    //        else{
    //
    //            let postString = "username=\(params!["username"] ?? "")&password=\(params!["password"] ?? "")&grant_type=password&client_id=client&client_secret=enrich@2018"
    //            request?.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //            request?.httpBody = postString.data(using: String.Encoding.utf8)
    //        }
    //
    //        session = self.setConfiguration()
    //        session?.dataTask(with: request! as URLRequest, completionHandler: { data, response, error -> Void in
    //
    //            if let data = data {
    //
    //                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
    //                    do {
    //                        let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
    //                        DispatchQueue.main.async {
    //
    //                            if let status = json["status"] as? Bool, status == true {
    //                                callback(ReturnErrorCode.Success.rawValue, nil, json)
    //                                return
    //                            }
    //
    //                            if let errorMsg = json["message"] as? String {
    //                                callback(ReturnErrorCode.Failure.rawValue, errorMsg, json)
    //                                return
    //                            }
    //
    //                            callback(ReturnErrorCode.Failure.rawValue, "Something went wrong. Please try after some time.", nil)
    //                        }
    //                        print(json)
    //                    } catch {
    //                        print("error")
    //                        callback(ReturnErrorCode.Failure.rawValue,"Enabled to parse json.", nil)
    //                    }
    //
    //                }
    //                else if let response = response as? HTTPURLResponse, response.statusCode == 401
    //                {
    //                    // ******** REFRESH TOCKEN CALL - Need to write condition for refresh tocken call
    //                    self.refreshToken(isGetRequest: false, param: params!, urlString: urlString, callback: callback)
    //                }
    //                else {
    //                    DispatchQueue.main.async {
    //                        callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
    //                    }
    //                }
    //            }else {
    //                DispatchQueue.main.async {
    //                    callback(ReturnErrorCode.Failure.rawValue, ErrorCodeHandlerClass.shared.checkErrorCodes(error: error), nil)
    //                }
    //
    //            }
    //        }).resume()
    //
    //    }
    func setConfiguration() -> URLSession
    {
        self.configuration = URLSessionConfiguration.default
        //        if let adminLogin:ModelAdminProfile = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile
        //        if let adminLogin = UserDefaults.standard.dictionary(forKey: UserDefaultKeys.modelAdminProfile.rawValue)
        //        {
        //            let authorizationKey = String(format:"bearer \(adminLogin["access_token"] ?? "")" /*adminLogin.access_token ?? ""*/)
        //            self.configuration.httpAdditionalHeaders = ["Authorization": authorizationKey]
        //        }
        
        if let adminLogin:ModelAdminProfile = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let accesstoken = adminLogin.access_token, !accesstoken.isEmpty
        {
            let authorizationKey = String(format:"bearer \(accesstoken)")
            self.configuration.httpAdditionalHeaders = ["Authorization": authorizationKey]
        }
        
        self.configuration.timeoutIntervalForRequest = EN_WebServiceTimeOut.webServiceTimeOut.rawValue
        self.configuration.timeoutIntervalForResource = 300
        session = URLSession(configuration: self.configuration)
        return session!
    }
    
    // MARK:- CreateUrl
    func getBaseUrl() -> String {
        
        // MAGENTO
        var  BaseUrl = "https://enrichbeauty.com/rest/V1/"
        #if DEBUG
        print("DEBUG")
        // Dev URL //"https://enrichsalon.co.in/rest/V1/"
        // PreProd // https://preprod.enrichsalon.co.in/
        BaseUrl =  "https://dev.enrichbeauty.com/rest/V1/"
        #elseif STAGE
        print("STAGE")
        BaseUrl =  "https://stage.enrichbeauty.com/rest/V1/"
        #elseif RELEASE
        print("RELEASE")
        // BaseUrl = "https://prod.enrichsalon.co.in/rest/V1/"
        BaseUrl = "https://www.enrichbeauty.com/rest/V1/"
        
        #endif
        
        return BaseUrl
    }
    
    func createUrl(endPoint: ConstantAPINames) -> String {
        
        return getBaseUrl() + "" + endPoint.rawValue
        
        var  BaseUrl = "http://beautyandbling.enrichsalon.com:8080/enrich"  // This is now Live
        #if DEVELOPMENT
        //BaseUrl = "http://172.52.10.52:8001/enrich" // Local
        BaseUrl = "https://dev.enrichbeauty.com" // Local
        
        #elseif STAGING
        // BaseUrl = "http://104.211.216.153:8080/enrich" // This in Now Public
        BaseUrl = "https://stage.enrichbeauty.com" // This in Now Public
        
        #elseif PRODUCTION
        //BaseUrl = "http://beautyandbling.enrichsalon.com:8080/enrich" // This is now Live
        BaseUrl = "https://www.enrichbeauty.com" // This is now Live
        
        #endif
        var finalEndpoint = ""
        finalEndpoint = String(format:"%@/%@",BaseUrl,endPoint.rawValue)
        print("finalEndpoint \(finalEndpoint)")        
        return finalEndpoint
    }
    
    func appLogOut()
    {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modelAdminUserIdAndPassword.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modelAdminProfile.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modelCampaignDetails.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modeInvoiceDetails.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modelRunningCampaingSelected.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.modeStoreData.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.lastLoginDate.rawValue)
        
        updateAppVersion() // This Function Will get call incase app logout is clicked
    }
    func updateAppVersion()
    {
        var  hockeyAppkey = "96755922f4cd4ab5ae3be10c324a88fc"  // Live
        #if DEVELOPMENT
        hockeyAppkey = "971c583e2cac45fd840059b51abe5dcc" // Local
        #elseif STAGING
        hockeyAppkey = "81e19ada149b4727a37347d446e480f2" // This in Now Public
        #elseif PRODUCTION
        hockeyAppkey = "96755922f4cd4ab5ae3be10c324a88fc" // This is now Live
        
        #endif
    }
}

extension APICallsManagerClass
{
    // MARK:- RefreshToken
    func refreshToken(isGetRequest: Bool, param:[String:Any],urlString:String, callback:@escaping ApiResponse)   {
        if !NetworkRechability.isConnectedToNetwork(){
            callback(ReturnErrorCode.Failure.rawValue, "Network connection error", nil)
        }
        
        self.reloginInCaseAccessTokenExpired { (errorCode, errorMsg, dictData) in
            DispatchQueue.main.async {
                if errorCode != 0
                {
                    // HANDLE ERROR
                    if let msg = errorMsg
                    {
                        print("ErrorMessage: \(msg)")
                    }
                    
                    self.appLogOut()
                    var appDelegate:AppDelegate {
                        return UIApplication.shared.delegate as! AppDelegate
                    }
                    appDelegate.appLaunch()
                    
                    let alert = UIAlertController(title: "We're Sorry!", message:"Session has expired. Please contact to admin for re-login.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }else // Success
                {
                    if  let data = GlobalFunctions.shared.jsonToNSData(json: dictData as AnyObject)
                    {
                        UserDefaultUtility.shared.saveModelObjectToSharedPreference(data: data, strKey: UserDefaultKeys.modelAdminProfile)
                    }
                    // Call previous API
                    if(isGetRequest)
                    {
                        self.getAPICall(urlString:urlString,callback: callback)
                    }else
                    {
                        let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.adminLogin)
                        if(urlString == urlEndpoint)
                        {
                            self.postAPICall(params: param, isHeader: false,  urlString: urlString, callback: callback)
                        }else{
                            self.postAPICall(params: param, isHeader: true,  urlString: urlString, callback: callback)
                        }
                    }
                }
            }
            
        }
    }
    
    func reloginInCaseAccessTokenExpired(callback:@escaping ApiResponse)   {
        
        //        if let userDetailsObj = UserDefaults.standard.value(forKey: UserDefaultKeys.modelAdminProfile.rawValue) as? [String : Any] {
        if let userDetailsObj:ModelAdminProfile = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let accesstoken = userDetailsObj.access_token, !accesstoken.isEmpty, let refreshToken = userDetailsObj.refresh_token, !refreshToken.isEmpty
        {
            var userDetails = userDetailsObj
            print("userDetails 1 : \(userDetails)")
            
            let params : [String: Any] = [
                "access_token": accesstoken, // \(userDetails["username"]!)",
                "refresh_token": refreshToken, //\(userDetails["password"]!)",
                "is_custom" : true,
                "user_type" : 2
                //            "client_id": "client",
                //            "client_secret": "enrich@2018",
                //            "grant_type":"password"
            ]
            
            let urlEndpoint = APICallsManagerClass.shared.createUrl(endPoint: ConstantAPINames.tokenRefresh)// ConstantAPINames.adminLogin)
            
            APICallsManagerClass.shared.postAPICall(params: params, isHeader: true, urlString: urlEndpoint) { (errorCode, errorMsg, dictData) in
                // Save to User Default Admin ServerData
                //{"message":"Token generated successfully","success":true,"data":{"access_token":"dh9gjd18ic7vyfckrg1s0uayysusnc4r"}}
                
                if let dictObj = dictData, let status = dictObj["success"] as? Bool, status == true, let dataObj = dictObj["data"] as? [String : String] {
                    print("dataObj : \(dataObj)")
                    //userDetails["access_token"] = dataObj["access_token"]
                    
                    userDetails.access_token = dataObj["access_token"]
                    
                    //                            UserDefaults.standard.set(userDetails, forKey: UserDefaultKeys.modelAdminProfile.rawValue)
                    //                                                       UserDefaults.standard.synchronize()
                    //
                    //                                                       print("userDetails 2 : \(userDetails)")
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(userDetails) {
                        if let json = String(data: encoded, encoding: .utf8) {
                            print(json)
                        }
                        
                        let decoder = JSONDecoder()
                        if let decoded = try? decoder.decode(ModelAdminProfile.self, from: encoded) {
                            print(decoded.username ?? "")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        callback(ReturnErrorCode.Success.rawValue, "", dictData)
                    }
                    return
                    
                } else {
                    DispatchQueue.main.async {
                        
                        callback(ReturnErrorCode.Failure.rawValue, "Something went wrong, Please try after sometime", nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    
                    callback(errorCode, errorMsg, dictData)
                }
                return
            }
        }
        DispatchQueue.main.async {
            
            callback(ReturnErrorCode.Failure.rawValue, "", nil)
        }
    }
    
    
}
