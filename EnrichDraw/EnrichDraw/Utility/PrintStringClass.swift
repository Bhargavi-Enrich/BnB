//
//  PrintStringClass.swift
//  AlmofireClassManager
//
//  Created by Mugdha Mundhe on 8/22/18.
//  Copyright © 2018 ezest. All rights reserved.
//

import UIKit
import Foundation

var printStatus : PrintStructure = .noPrint

struct PrintStructure: OptionSet  {
    let rawValue: Int
    
    // Types: debug & prod
    static let qa = PrintStructure(rawValue: 1 << 0)
    static let debug  = PrintStructure(rawValue: 1 << 1)
    
    func category() -> String{
        switch rawValue {
        case PrintStructure.qa.rawValue:
            return "qa :"
        default:
            return "Debug :"
        }
    }
    
    // Cases
    static let noPrint: PrintStructure = []
    static let all: PrintStructure = [.qa, .debug]
}

func print(_ items: Any...){
    PrintData.print(type: printStatus, data: items)
}

func print(type: PrintStructure,data: Any) {
    PrintData.print(type: type, data: data)
}

final fileprivate class PrintData
{
    static func print(type: PrintStructure,data: Any)
    {
        if (printStatus.contains(type)) {
            Swift.print("\( String(describing: data))")
        }
    }
}
