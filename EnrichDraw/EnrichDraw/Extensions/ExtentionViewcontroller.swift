//
//  ExtentionViewcontroller.swift
//  DAC_App
//
//  Created by Mugdha Mundhe on 12/21/17.

//

import Foundation

import UIKit

extension UIViewController {
   
    var appDelegate:AppDelegate {
            return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func showAlert( alertTitle title: String, alertMessage msg: String ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertControllerBackgroundTapped()
    {
        self.appDelegate.window?.rootViewController!.dismiss(animated: false, completion: nil)
        
    }
    
}
extension UIViewController
{
    func updateImage(imageView:UIImageView,imageData:Data,defaultImageName:String)
    {
        if imageData.count > 0 {
            let image: UIImage = UIImage(data:imageData,scale:1.0)!
            imageView.image = image
        }
        else
        {
            imageView.image = UIImage(named: defaultImageName)
        }
        
        
    }
    
    func getCopyRight()-> String{
        let copyRightText = String(format: "%@ (%@)","Copyright ® 2020 Enrich. All Rights Reserved.",Bundle.main.buildVersionNumber ?? "")
        return copyRightText
    }
    
}
