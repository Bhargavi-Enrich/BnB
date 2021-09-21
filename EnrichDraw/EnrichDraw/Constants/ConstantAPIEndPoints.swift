//
//  ConstantAPI.swift
//
//  Modified on 07/09/2018.

//

import Foundation

public enum ConstantAPINames: String{
    case tokenRefresh = "auth/token/refresh"
    case adminLogin = "integration/admin/token" // "oauth/token" // https://dev.enrichsalon.co.in/rest/V1/integration/admin/token
    case customerAuthentication = "enrich/invoices/validateinvoice"
    case getInvoiceDetails = "enrich/campaign/invoicedetails"
    
    case validateOtp = "enrich/otp/validateotp"
    case updateCustomerSpinDetails = "enrich/customerspindetails/"
    case getStoreRewards = "enrich/store/rewards"
    case imgVideoCalls = "enrich/store/videos?is_custom=true"
    case getStoreDetails = "enrich/store/details/"
    case getCampaignList = "enrich/store/fetchCampaignsByStoreId/"
    case getCampaignDetails = "enrich/store/fetchCampaignsById/"
    case getRecycleReward = "enrich/store/recycleRewards/"
    
    case getMyOders = "customer/mine/ordered-products"
    case getWinningDetails = "enrich/customer/winDetails"
}

