//
//  ConstantStrings.swift
//  EnrichDraw
//
//  Modified on 6/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation

extension String {
    var localized: String {
        let strFinal = NSLocalizedString(self, comment: "")
        return (strFinal == self) ? "" : strFinal
    }
    
    func relatedStrings(_ gameType1 : Any) -> String {
        var strFinal = ""
        if let gameType = gameType1 as? SelectedGame{
            switch gameType {
            case .spinWheel :
                strFinal = self.localized
            case .scratchCard :
                strFinal = "\(self)-scratchCard".localized
            case .dice :
                strFinal = "\(self)-dice".localized
            case .cards :
                strFinal = "\(self)-cards".localized
            case .casino :
                strFinal = "\(self)-casino".localized
            }
        }
        strFinal = strFinal.isEmpty ? self.localized : strFinal
        return strFinal
    }

}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

