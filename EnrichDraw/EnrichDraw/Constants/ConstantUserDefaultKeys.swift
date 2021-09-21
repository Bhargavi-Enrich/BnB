//
//  ConstantUserDefaultKeys.swift
//
//  Modified on 29/12/2017.

//

import Foundation
public enum UserDefaultKeys: String{
    
    case modelAdminProfile = "ModelAdminProfile" // Contains Accesstoken, Refresh token
    case modelAdminUserIdAndPassword = "ModelAdminUserIdAndPassword" // Contains Admin loged in User Name,Password
    //case modelCampaignDetails = "ModelCampaignDetails" // Contains Campaign Details, Wheels Details
    case modelCampaignDetails = "ModelRunningCampaignListData" // Contains Campaign Details, Wheels Details

    case modeInvoiceDetails = "ModeInvoiceDetails" // Contains Campaign Details, Wheels Details
    case modeStoreData = "ModeStoreData" // Contains Store Details
    case modelRunningCampaingSelected = "modelRunningCampaingSelected" // Contains CampaignSelected

    case lastLoginDate = "lastLoginDate" // Last login date
}


