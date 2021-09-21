//
//  ModelRunningCampaignList.swift
//  EnrichDraw
//
//  Created by Apple on 22/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ModelRunningCampaignData: Codable {
    var status : Bool?
    var message: String?
    var data : ModelRunningCampaignList?
}


struct ModelRunningCampaignList: Codable {
    var listOfCampaign: [ModelRunningCampaignListData]?
}


struct ModelRunningCampaignListData: Codable {
    var entity_id : String?
    var campaign_name : String?
    var is_active : String?
    var start_date : String?
    var end_date : String?
    var threshold : String?
    var store : String?
    var campaign_logo : Model_campaign_logo?
    var campaign_background_image : Model_campaign_logo?
    var campaign_left_background_image : Model_campaign_logo?
    var campaign_right_background_image : Model_campaign_logo?
    var term_condition : String?
    var created_at : String?
    var updated_at : String?
    var recycle_message: String?
    var date_range: String?
    var max_range: Int?
    var min_range: Int?
    var campaign_offers : [Model_campaign_offers]?

//    var id:Int64?
//    var value:String?
//    var campaignLogo:Data?
//    var campaignLeftBackground:Data?
//    var backgroundImage:Data?
//    var termsAndConditions:String?
}

struct Model_campaign_logo: Codable {
    var name:String?
    var url:String?
    var size:String?
    var previewType:String?
    var id:String?
}

struct Model_campaign_offers: Codable {
    var campaign_reward_id:String?
    var offer_type:String?
    var offer_name:String?
    var value:String?
    var weightage:String?
    var validity:String?
    var offer_used:String?
    var count:String?
    
    var tip:String?
    var trial_display_name:String?
    var trial_reward_points:Int?
    var trial_validity:Int?
}
