//
//  ExtensionNavigation.swift
//  EnrichDraw
//
//  Modified on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func popToVC(ofKind kind: AnyClass) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: false)
                    break
                }
            }
        }
    }
}
