//
//  EmailValidation.swift
//  Modified on 07/09/2018.

//

import Foundation
class EmailValidation {
    private init(){}
    static let sharedInstance = EmailValidation()
    // MARK: -  Email Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}
