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
    var campaign_image : Model_campaign_logo?
    var campaign_win_bnb_big_image: Model_campaign_logo?
    var campaign_win_bnb_small_image: Model_campaign_logo?
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
    var agift: String?
    var agift_name:String?
    var surprise_gift_details:[assured_gift_details]?
    
    var tip:String?
    var trial_display_name:String?
    var trial_reward_points:Int?
    var trial_validity:Int?
    
    enum CodingKeys: String, CodingKey {
        case campaign_reward_id = "campaign_reward_id"
        case offer_type = "offer_type"
        case offer_name = "offer_name"
        case value = "value"
        case weightage = "weightage"
        case offer_used = "offer_used"
        case count = "count"
        case agift = "agift"
        case agift_name = "agift_name"
        case surprise_gift_details = "assured_gift_details"
        case tip = "tip"
        case trial_display_name = "trial_display_name"
        case trial_validity = "trial_validity"
        case trial_reward_points = "trial_reward_points"
    }
}

public struct assured_gift_details: Codable {
    var id:String?
    var name:String?
    var description:String?
    var from_date:String?
    var to_date:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case from_date = "from_date"
        case to_date = "to_date"
    }
}
