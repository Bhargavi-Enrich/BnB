//
//  ModelCampaignDetails.swift
//  EnrichDraw
//

//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct ModelCampaignDetails : Codable {
    let campaignDetails : CampaignDetails?
    var campaignSpinDetailsViews : [CampaignSpinDetailsViews]?
    var balanceCount:Int?// This is not in use From 9 OCT 2018 but still declared so that existing app on stores will not crash
    var serviceBalance:Int? // This count will decide to send customer on Spin Screen or not. Incase customer spin count is less than serviceBalance he is  eligible for spin
    var productBalance:Int? // This count will decide to send customer on Spin Screen or not. Incase customer spin count is less than productBalance he is  eligible for spin
    var minReward:Int?
    var maxReward:Int?
}
struct CampaignDetails : Codable {
    let campaignId : Int?
    let campaignName : String?
    let campaignType : String?
    let status : String?
    let startDate : String?
    let endDate : String?
    let campaignThreshold : Int?
}
struct CampaignSpinDetailsViews : Codable {
    let campaignId : Int?
    let campaignRewardId: Int?
    let rewardName : String?
    let rewardValue : String?
    let type : String?
    var count : Int?
    var balance:Int?
}
