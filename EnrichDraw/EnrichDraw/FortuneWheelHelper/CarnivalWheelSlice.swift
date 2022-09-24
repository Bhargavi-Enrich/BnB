//
//  CarnivalWheelSlice.swift
//  TTFortuneWheelSample
//
//  Created by Efraim Budusan on 11/1/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import Foundation
//import TTFortuneWheel

public enum Style {
    case darkRed
    case lightRed
    
    case darkYellow
    case lightYellow
    
    case darkGreen
    case lightGreen
    
    case darkAqua
    case lightAqua
    
    case darkOrange
    case lightOrange
    
    case darkRoyalBlue
    case lightRoyalBlue
    
    case darkBlue
    case lightBlue
    
    case darkViolet
    case lightViolet
    
    case darkPink
    case lightPink
    
    case darkBlack
    case lightRedRol
    
    case greenrichDark
    case greenrichLight
    
    case red22
    case white22
    
    public var backgroundColor: UIColor {
        switch self {
            case .darkRed: return TTUtils.uiColor(from:0xF2574C)
            case .lightRed: return TTUtils.uiColor(from:0xFF928A)
            
            case .darkYellow: return TTUtils.uiColor(from:0xEF8B38)
            case .lightYellow: return TTUtils.uiColor(from:0xF8CC46)
            
            case .darkGreen: return TTUtils.uiColor(from:0x9FDB61)
            case .lightGreen: return TTUtils.uiColor(from:0xD9FFAC)
            
            case .darkAqua: return TTUtils.uiColor(from:0x51D1B5)
            case .lightAqua: return TTUtils.uiColor(from:0xA0E1D3)
            
            case .darkOrange: return TTUtils.uiColor(from:0xFF9436)
            case .lightOrange: return TTUtils.uiColor(from:0xFFB473)
            
            case .darkRoyalBlue: return TTUtils.uiColor(from:0x6586DD)
            case .lightRoyalBlue: return TTUtils.uiColor(from:0x93ABEC)
            
            case .darkBlue: return TTUtils.uiColor(from:0x5CC3F9)
            case .lightBlue: return TTUtils.uiColor(from:0xC2E7FF)
            
            case .darkViolet: return TTUtils.uiColor(from:0x8A91F4)
            case .lightViolet: return TTUtils.uiColor(from:0xC1C5F9)
            
            case .darkPink: return TTUtils.uiColor(from:0xFF9AAB)
            case .lightPink: return TTUtils.uiColor(from:0xFFC0CB)
            
            case .darkBlack: return TTUtils.uiColor(from:0xFE1D02)
            case .lightRedRol: return TTUtils.uiColor(from:0x373A3B)
            
            case .greenrichDark: return TTUtils.uiColor(from:0x517030)
            case .greenrichLight: return TTUtils.uiColor(from:0x709c41)
            
            case .red22: return UIColor.red
            case .white22: return UIColor.white

        }
    }
}
public class CarnivalWheelSlice: FortuneWheelSliceProtocol {

    let fontsize : CGFloat = 28
    let fontName : String = FontName.BodoniModa28ptBold
    public var rewardName: String
    public var degree: CGFloat = 0.0
    // New Added
    public var rewardValue: String
    public var rewardType: String
    public var rewardCount: Int = 0
    public var campaignRewardId: Int = 0
    
    public var fontColor: UIColor {
        if self.style == .red22 {
            return UIColor.white
        }
        else if self.style == .white22 {
            return UIColor.black
        }
        return UIColor.black
    }
    
    public var offsetFromExterior:CGFloat {
        return 10.0
    }
    
    public var backgroundColor: UIColor? {
        switch self.style {
        case .darkRed: return TTUtils.uiColor(from:0xF2574C)
        case .lightRed: return TTUtils.uiColor(from:0xFF928A)
            
        case .darkYellow: return TTUtils.uiColor(from:0xEF8B38)
        case .lightYellow: return TTUtils.uiColor(from:0xF8CC46)
            
        case .darkGreen: return TTUtils.uiColor(from:0x9FDB61)
        case .lightGreen: return TTUtils.uiColor(from:0xD9FFAC)
            
        case .darkAqua: return TTUtils.uiColor(from:0x51D1B5)
        case .lightAqua: return TTUtils.uiColor(from:0xA0E1D3)
            
        case .darkOrange: return TTUtils.uiColor(from:0xFF9436)
        case .lightOrange: return TTUtils.uiColor(from:0xFFB473)
            
        case .darkRoyalBlue: return TTUtils.uiColor(from:0x6586DD)
        case .lightRoyalBlue: return TTUtils.uiColor(from:0x93ABEC)
            
        case .darkBlue: return TTUtils.uiColor(from:0x5CC3F9)
        case .lightBlue: return TTUtils.uiColor(from:0xC2E7FF)
            
        case .darkViolet: return TTUtils.uiColor(from:0x8A91F4)
        case .lightViolet: return TTUtils.uiColor(from:0xC1C5F9)
            
        case .darkPink: return TTUtils.uiColor(from:0xFF9AAB)
        case .lightPink: return TTUtils.uiColor(from:0xFFC0CB)
        
        case .darkBlack: return TTUtils.uiColor(from:0x2A0D3A)
        case .lightRedRol: return TTUtils.uiColor(from:0x8E0416)

        case .greenrichDark: return TTUtils.uiColor(from:0x517030)
        case .greenrichLight: return TTUtils.uiColor(from:0x709c41)
            
        case .red22: return UIColor(red: 232/255, green: 39/255, blue: 33/255, alpha: 1.0)
        case .white22: return UIColor.white

        }
    }
    
    public var font: UIFont {
        
        switch style {
        case .darkRed: return UIFont(name: fontName, size: fontsize)!
        case .lightRed: return UIFont(name: fontName, size: fontsize)!

        case .darkYellow: return UIFont(name: fontName, size: fontsize)!
        case .lightYellow: return UIFont(name: fontName, size: fontsize)!

        case .darkGreen: return UIFont(name: fontName, size: fontsize)!
        case .lightGreen: return UIFont(name: fontName, size: fontsize)!

        case .darkAqua: return UIFont(name: fontName, size: fontsize)!
        case .lightAqua: return UIFont(name: fontName, size: fontsize)!

        case .darkOrange: return UIFont(name: fontName, size: fontsize)!
        case .lightOrange: return UIFont(name: fontName, size: fontsize)!
            
        case .darkRoyalBlue: return UIFont(name: fontName, size: fontsize)!
        case .lightRoyalBlue: return UIFont(name: fontName, size: fontsize)!
            
        case .darkBlue: return UIFont(name: fontName, size: fontsize)!
        case .lightBlue: return UIFont(name: fontName, size: fontsize)!
            
        case .darkViolet: return UIFont(name: fontName, size: fontsize)!
        case .lightViolet: return UIFont(name: fontName, size: fontsize)!
       
        case .darkPink: return UIFont(name: fontName, size: fontsize)!
        case .lightPink: return UIFont(name: fontName, size: fontsize)!
            
        case .darkBlack: return UIFont(name: fontName, size: fontsize)!
        case .lightRedRol: return UIFont(name: fontName, size: fontsize)!
      
        case .greenrichDark: return UIFont(name: fontName, size: fontsize)!
        case .greenrichLight: return UIFont(name: fontName, size: fontsize)!
            
        case .red22: return UIFont(name: fontName, size: fontsize)!
        case .white22: return UIFont(name: fontName, size: fontsize)!

        }
    }
    
//    public var stroke: StrokeInfo? {
////        return StrokeInfo(color: UIColor.clear, width: 1.5)
//
//        return StrokeInfo(color: UIColor(red: 253/255, green: 213/255, blue: 159/255, alpha: 1), width: 2)
//    }
    
    public var style:Style = .darkRed

    public init(rewardName:String,rewardValue:String,rewardType:String,rewardCount:Int = 0,campaignRewardId:Int = 0) {
        self.rewardName = rewardName
        self.rewardValue = rewardValue
        self.rewardType = rewardType
        self.rewardCount = rewardCount
        self.campaignRewardId = campaignRewardId
    }
    
    public convenience init(rewardName:String,rewardValue:String,rewardType:String,rewardCount:Int = 0,campaignRewardId:Int = 0, degree:CGFloat) {
        self.init(rewardName:rewardName,rewardValue:rewardValue,rewardType:rewardType,rewardCount:rewardCount,campaignRewardId:campaignRewardId)
        self.degree = degree
    }
    
}
