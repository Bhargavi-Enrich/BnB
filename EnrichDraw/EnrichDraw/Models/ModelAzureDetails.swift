//
//  ModelAzureDetails.swift
//  EnrichDraw
//
//  Created by Mugdha on 26/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Foundation
class ModelAzureData : Codable, Hashable {
    
    let name : String?
    let contentType : String?
    var lastModified : Date?
    var imagePath:String?
    var filePath : String?
    
    static func == (lhs: ModelAzureData, rhs: ModelAzureData) -> Bool {
        return lhs.name == rhs.name
    }
    
    var hashValue:Int {
        return 1
    }
    
    init(name: String?, contentType: String?,lastModified: Date?, filePath: String?, imagePath: String?) {
        self.name = name
        self.contentType = contentType
        self.lastModified = lastModified
        self.imagePath = imagePath
        self.filePath = filePath
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case contentType
        case lastModified
        case imagePath
        case filePath
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        contentType = try values.decode(String.self, forKey: .contentType)
        lastModified = try values.decode(Date.self, forKey: .lastModified)
        imagePath = try values.decode(String.self, forKey: .imagePath)
        filePath = try values.decode(String.self, forKey: .filePath)
    }
}
