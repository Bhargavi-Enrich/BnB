//
//  ExtensionBundle.swift
//  EnrichDraw
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//
//How to use
//Bundle.main.releaseVersionNumber
//Bundle.main.buildVersionNumber


import Foundation
import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
