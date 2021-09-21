//
//  UserDefaultUtility.swift
//  DAC_App
//
//  Created by Apple on 30/12/17.

//

import Foundation

class UserDefaultUtility{
    static let shared = UserDefaultUtility()
    
   
    
    func saveUserDefaultToSharedPreference(value:String, strKey :String) {
        let defaults = UserDefaults.standard
        
        // Save String value to UserDefaults
        // Using defaults.set(value: Any?, forKey: String)
        defaults.set(value, forKey: strKey)
        
    }
    
    
    // MARK: - Methods to add Model Object in User Default
    func saveModelObjectToSharedPreference(data:Data,strKey :UserDefaultKeys) {
            UserDefaults.standard.set(data, forKey: strKey.rawValue)
            UserDefaults.standard.synchronize()
    }
   
    
    func saveModelObjectToSharedPreferenceCallback(data:Data,strKey :UserDefaultKeys,_ callback: @escaping (_ success: Bool) -> Void) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(data, forKey: strKey.rawValue)
            UserDefaults.standard.synchronize()
            callback(true)
        }
    }
    
    func getModelObjectFromSharedPreference(strKey : UserDefaultKeys) -> Any {
        
        
        if self.isKeyPresentInUserDefaults(key: strKey.rawValue) == true   {
            do {
                switch strKey {
                case .modelAdminProfile :
                    let encoded = UserDefaults.standard.object(forKey: strKey.rawValue) as! Data
                    do {
                        let decoder = JSONDecoder()
                        let storedPrefs = try decoder.decode(ModelAdminProfile.self, from: encoded)
                        return storedPrefs
                        
                    }
                    catch let error {
                        #if DEBUG
                        print("parse error: \(error.localizedDescription)")
                        #endif
                        return NSNull()
                    }
                    
                case .modelCampaignDetails :
                    let encoded = UserDefaults.standard.object(forKey: strKey.rawValue) as! Data
                    do {
                        let decoder = JSONDecoder()
                        let storedPrefs = try decoder.decode(ModelRunningCampaignList.self, from: encoded)
                        return storedPrefs
                        
                    }
                    catch let error {
                        #if DEBUG
                        print("parse error: \(error.localizedDescription)")
                        #endif
                        return NSNull()
                    }
                    
                case .modeStoreData :
                    let encoded = UserDefaults.standard.object(forKey: strKey.rawValue) as! Data
                    do {
                        let decoded = try JSONSerialization.jsonObject(with: encoded, options: [])
                        return decoded
                    } catch let error as NSError {
                        print(error)
                    }
                    return [:]
                    
                case .modelAdminUserIdAndPassword:break
                
                case .modelRunningCampaingSelected:
                    let encoded = UserDefaults.standard.object(forKey: strKey.rawValue) as! Data
                    do {
                        let decoder = JSONDecoder()
                        let storedPrefs = try decoder.decode(ModelRunningCampaignListData.self, from: encoded)
                        return storedPrefs
                        
                    }
                    catch let error {
                        #if DEBUG
                        print("parse error: \(error.localizedDescription)")
                        #endif
                        return NSNull()
                    }
                    
                case .modeInvoiceDetails:break
                                        
                case .lastLoginDate: break
                }
            }
        } else {
            #if DEBUG
            print("No value in Userdefault,Either you can save value here or perform other operation")
            #endif
            return NSNull()
            
        }
        return NSNull()
        
    }
    // MARK: - Methods to add Model Object in User Default
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func removeObjectForKey(strKey :String) {
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
        
    }
    
}


