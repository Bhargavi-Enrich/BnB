//
//  ModelOrderDetails.swift
//  EnrichDraw
//
//  Created by Harshal on 07/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum MyProductOrdersModuleModel {
  // MARK: Use cases

  enum GetMyOrders {
    struct Request: Codable {
        let is_custom: Bool = true
        let platform: String = "mobile"
        let limit: Int64?
        let page: Int?

    }
    struct Response: Codable {
        let status: Bool?
        let message: String?
        let data: MyOrdersData?
    }
    struct MyOrdersData: Codable {
        let orders: [Orders]?
        let total_number: Int64?
        let current_page: Int?
        let cancellation_reasons: [CancellationReason]?
    }
    struct CancellationReason: Codable {
        let reason_id: String?
        let reason_code: String?
        let reason_type: String?
        let reason: String?
        let created_at: String?
    }

    struct Orders: Codable {
        let order_id: String?
        let increment_id: String?
        let created_at: String?
        let updated_at: String?
        let order_status: String?
        let grand_total: String?
        let first_name: String?
        let last_name: String?
        let payment_code: String?
        let payment_method: String?
        let salon_id: String?
        let address: Address?
        let totals: Totals?
        let tracking_numbers: [Tracking_numbers]?
       // let items: [OrderItems]?
       // let total_segments: [ConfirmOrder.FetchingShippingInformation.Total_segments]?
        let greenrich: Greenrich?
    }
    
    struct Greenrich: Codable {
        let invoice_amount: Int64?
        let invoice_number: String?
        let applicable_campaigns: [ModelRunningCampaignListData]?
        let spin_details: [SpinDetails]?
    }
    
    struct SpinDetails: Codable {
        let customer_name: String?
        let customer_id: AnyCodable?
        let invoice_number: String?
        let amount: Double?
        let no_of_spins: Int?
        let remaining_spins: Int?
        let remaining_invoice_amount: Double?
        let remaining_trials: Int?
        let is_trial_enable: Int?
        let trial_display_name: String?
        let no_of_trials: Int?
        let trial_reward_points: Int?
        let trial_validity: Int?
    }
    
    struct Address: Codable {
        let shipping_address: Billing_address?
        let billing_address: Billing_address?
    }
    struct Billing_address: Codable {
        let first_name: String?
        let last_name: String?
        let email: String?
        let company: String?
        let street: [String]?
        let city: String?
        let region_id: Int?
        let region: Region?
        let region_code: String?
        let postcode: String?
        let country_id: String?
        let telephone: String?
        let fax: String?
    }
    struct Region: Codable {
        let region_code: String?
        let region: String?
        let region_id: Int?
    }
    struct Totals: Codable {
        let subtotal: Double?
        let discount: Double?
        let discount_description: String?
        let reward_discount: Double?
        let package_discount: Double?
        let giftcard_discount: Double?
        let wallet_payment: Double?
        let shipping_amount: Double?
        let grand_total: Double?
        let cgst_amount: Double?
        let sgst_amount: Double?
        let igst_amount: Double?
        let ugst_amount: Double?
        let shipping_cgst_amount: Double?
        let shipping_sgst_amount: Double?
        let shipping_igst_amount: Double?
        let shipping_ugst_amount: Double?
        let taxable_amount: Double?
        let technician_charge: Double?
        let tax_note: String?

    }
    struct Tracking_numbers: Codable {
        let carrier_code: String?
        let title: String?
        let tracking_number: String?
        let track_status: Bool?
        let track_data: [TrackingData]?
        let track_url: String?

    }
    struct TrackingData: Codable {
        let title: String?
        let time: String?
        let location: String?
        let instructions: String?

    }

//    struct OrderItems: Codable {
//        let order_id: String?
//        let item_id: String?
//        let product_id: String?
//        let sku: String?
//        let name: String?
//        let image: String?
//        let price: Double?
//        let special_price: AnyCodable?
//        let qty: Int?
//        let created_at: String?
//        let updated_at: String?
//        let order_item_status: String?
//        let type_of_service: String?
//        let product_type: String?
//        let membership_group_id: Int64?
//        let gender: [String]?
//        let salon_data: [LocationModule.Something.SalonParamModel]?
//        let type_id: String?
//        let configurable_item_options: [ProductDetailsModule.AddBulkProductMine.Configurable_item_options]?
//        let bundle_option: [ProductDetailsModule.AddBulkProductMine.Bundle_options]?
//        let product_attribute_options: [ProductDetailsModule.GetAllCartsItemCustomer.ProductAttributeOption]?
//        //let extension_attributes: Extension_attributes?
//    }

  }

}
