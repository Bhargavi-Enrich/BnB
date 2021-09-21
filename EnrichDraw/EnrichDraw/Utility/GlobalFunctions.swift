//
//  GlobalFunctions.swift
//  EnrichDraw
//
//  Modified on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
class GlobalFunctions: NSObject
{
    static let shared = GlobalFunctions()
    
    var scratchCardLastGame = 1
    var scratchCardLastLabelShow = 0
    
    let getRandonColor = { () -> String in
        let no = Int.random(in: 1...9)
        switch no {
        case 1:
            return SpinColors.clrRoyalBlue.rawValue
        case 2:
            return SpinColors.clrYellow.rawValue
        case 3:
            return SpinColors.clrGreen.rawValue
        case 4:
            return SpinColors.clrViolet.rawValue
        case 5:
            return SpinColors.clrOrange.rawValue
        case 6:
            return SpinColors.clrAqua.rawValue
        case 7:
            return SpinColors.clrRed.rawValue
        case 8:
            return SpinColors.clrSkyBlue.rawValue
        case 9:
            return SpinColors.clrPink.rawValue
        default:
            return SpinColors.clrWhite.rawValue
        }
    }


    func getGifForLanding() -> UIImage
    {
        return UIImage.gifImageWithName("landing CTA")!

    }
    
    func getCardTypeScratchOrSpin() -> (isCampainAvail : Bool ,isScatch : Bool){
      
        if let campaignRunningSelected:ModelRunningCampaignListData = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelRunningCampaingSelected) as? ModelRunningCampaignListData
        {
            // Check campain name
            if let campName = campaignRunningSelected.campaign_name  {
                // Check Scratch Card
                if campName.containsIgnoreCase("scratch"){
                    return (true, true)
                    // Check Spin wheel
                } else if campName.containsIgnoreCase("spin") {
                    return (true, false)
                    // Show randomly
                }else{
                    return (false, false)
                }
            }
        }
        return (false, false)
    }

    //MARK:- Convert from JSON to nsdata
    public func jsonToNSData(json: AnyObject) -> Data?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    func validateAlphanumeric(invoice: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: invoice)
    }
    
    func getImageDirectoryURL(strName : String) -> URL
    {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentsDirectoryURL.appendingPathComponent(String(format:"%@", strName))
        return fileURL
    }
    
    // Logout functionality time checks
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy hh:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func needToLogoutFromapp(lastDate : String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy hh:mm:ss"
        
        // Today date with time 00:00:00
        var todayDateStr =  dateFormatter.string(from: Date())
        todayDateStr = todayDateStr.components(separatedBy: " ").first ?? ""
        todayDateStr = todayDateStr + " 00:00:00"
        
        // Last saved date
        if let todayDate =  dateFormatter.date(from: todayDateStr), let dateLastEnter =  dateFormatter.date(from: lastDate){
            // today date is greater than last saved date app gets logout
            if todayDate > dateLastEnter {
                return true
            }
        }
        
        return false
    }
    
    func isUserLoggedIn() -> Bool{
        if let adminLogin:ModelAdminProfile = UserDefaultUtility.shared.getModelObjectFromSharedPreference(strKey: UserDefaultKeys.modelAdminProfile) as? ModelAdminProfile, let accesstoken = adminLogin.access_token, !accesstoken.isEmpty
               {
                return true
        }
        return false
    }
}


