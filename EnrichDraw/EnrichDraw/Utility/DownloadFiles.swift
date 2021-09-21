//
//  DownloadFiles.swift
//  EnrichSalon
//
//  Created by Mugdha Mundhe on 28/07/20.
//  Copyright © 2020 Aman Gupta. All rights reserved.
//

import UIKit
import Photos

class DownloadManager : NSObject, URLSessionDelegate {
    
    static let shared = DownloadManager()
    let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")

    func startDownload(strFilePath : String, title : String) {
        let url = URL(string: strFilePath)!
        let task = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
                    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                    let documentDirectoryPath:String = path[0]
                    print("documentDirectoryPath : \(documentDirectoryPath)")

                    let fileManager = FileManager()
                    let arrType = strFilePath.components(separatedBy: ".")
                    let strFinal = "/\(title).\(arrType.last ?? "")"
                    print("strFinal : \(strFinal)")
            
            let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat(strFinal))
                    
                    if fileManager.fileExists(atPath: destinationURLForFile.path){
                        return
                    }
                    else{
                        do {
                            try fileManager.moveItem(at: url!, to: destinationURLForFile)
                            
                            let imageData = self.thumbnailForVideo(videoURL: destinationURLForFile).jpegData(compressionQuality: 0.5)
                                let strThumbImageName = String(format:"%@_image.jpeg",title)

                                // Save video Image
                                let strFileNameObj = GlobalFunctions.shared.getImageDirectoryURL(strName: strThumbImageName)
                                print("strFileName : ",strFileNameObj.absoluteString)

                                do {
                                    try  imageData?.write(to: strFileNameObj)
                                    print("Thumbnail Image data Added Successfully")
                                } catch {
                                    print(error)
                                }

                        }catch{
                            print("An error occurred while moving file to destination url")
                        }
                    }
        })
        task.resume()
    }
    
    func thumbnailForVideo(videoURL : URL) -> UIImage
    {
        do {
            let asset = AVURLAsset(url: videoURL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail

        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }

        return UIImage()
    }

        
}


