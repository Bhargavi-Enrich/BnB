//
//  ErrorCodeHandlerClass.swift
//  AlmofireClassManager
//
//  Created by Mugdha Mundhe on 8/20/18.
//  Copyright © 2018 ezest. All rights reserved.
//

import UIKit

class ErrorCodeHandlerClass: NSObject {
    
    static let shared = ErrorCodeHandlerClass()
    
    func checkErrorCodes(error : Error?) -> String?{
        
        if let errorObj = error
        {
            return errorObj.localizedDescription
        }
        
        return nil
    }

}
