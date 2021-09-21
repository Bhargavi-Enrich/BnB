////
////  EN_Service_AzureBlob.swift
////  EnrichDraw
////
////  Modified on 11/23/18.
////  Copyright © 2018 Apple. All rights reserved.
////
//
//import Foundation
//import UIKit
//import AVKit
//
let gUDKeyImagesVideosData = "keyUDImagesVideosData"
//
//class EN_Service_GetAzureData {
//
//    var delegate : delegateAzureCallBack? // Delegate object (of EN_VC_Setting only) of controller.
//    var dataAccount : AZSCloudStorageAccount?
//    var blobClient : AZSCloudBlobClient?
//    var blobContainer : AZSCloudBlobContainer?
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var indexBlob = -1 // Index used to iterate blobs list for downloading data
//    var arrBlobs : [AZSCloudBlockBlob] = [] // Contains blobs list
//    let group = DispatchGroup()
//    var isInSync = false // Used to check downloding is in process or not
//
//    static let sharedInstance = EN_Service_GetAzureData()
//
//    private init(){
//        setUpFunction()
//    }
//
//    func setUpFunction()
//    {
//        do{
//
//            dataAccount = try AZSCloudStorageAccount.init(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=bnbmedia;AccountKey=QBvhQl7uw2IwQQ0S7gsNpy07qg76RskTDEeLf99FsUrmy2TBhMrHSGzO/+UaPsp0827WwM9En7sKi5LxMsxd8Q==;EndpointSuffix=core.windows.net")
//            blobClient = dataAccount!.getBlobClient()
//
//            #if DEVELOPMENT
//            blobContainer = blobClient!.containerReference(fromName: "bnbimages")
//            #elseif STAGING
//            blobContainer = blobClient!.containerReference(fromName: "bnbimages")
//
//            #elseif PRODUCTION
//            blobContainer = blobClient!.containerReference(fromName: "bnbproduction")
//
//            #endif
//        }catch _
//        {
//            //            Print(error)
//        }
//    }
//
//    // MARK:- CALL AZURE CONTAINER TO GET BLOBS
//    func azureConnection()
//    {
//        self.indexBlob = -1
//        isInSync = true
//
//        if !NetworkRechability.isConnectedToNetwork(){
//            if self.delegate != nil{
//                self.delegate!.showError(errorMsg: "Network connection error")
//            }
//            return
//        }
//
//        blobContainer!.listBlobsSegmented(with: nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: .all, maxResults: -1) { (error, result) in
//
//            if((error) != nil){
//                DispatchQueue.main.async {
//                    if self.delegate != nil
//                    {
//                        self.delegate!.showError(errorMsg: "Error while getting blob")
//                    }
//                    print("error ", error as Any)
//                }
//            }else{
//
//                // DELETE DATA IF NOT PRESENT IN SERVER
//                self.deleteLocalData(arrBlobs : (result?.blobs as! [AZSCloudBlockBlob]))
//
//                // RELOAD BLOBS LIST
//                if((result?.blobs?.count ?? 0)  > 0)
//                {
//                    self.arrBlobs = result?.blobs as! [AZSCloudBlockBlob]
//                    self.indexBlob =  self.indexBlob + 1
//                    self.downloadBlobs()
//                }
//            }
//
//            self.group.notify(queue: DispatchQueue.main) {
//                print("IN self.group.leave()")
//                // Refresh UI on controller
//                DispatchQueue.main.async {
//
//                    self.isInSync = false
//
//                    self.appDelegate.gListOfImages = self.appDelegate.gListOfImages.sorted { $0.name! < $1.name! }
//
//                    let encoder = JSONEncoder()
//                    if let encoded = try? encoder.encode(self.appDelegate.gListOfImages) {
//                        let defaults = UserDefaults.standard
//                        defaults.set(encoded, forKey: gUDKeyImagesVideosData)
//                    }
//
//                    if self.delegate != nil
//                    {
//                        self.delegate!.refreshData()
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK:- DOWNLOAD BLOBS ONE BY ONE AND SAVE INTO DOCUMENT DIRECTORY
//    func downloadBlobs()
//    {
//        if(self.indexBlob < arrBlobs.count)
//        {
//            self.group.enter()
//            //             DispatchQueue.global(qos: .background).async{
//            let model : AZSCloudBlockBlob = self.arrBlobs[self.indexBlob]
//            self.getImageOrVideo(model :model, group: self.group)
//            //            }
//        }
//    }
//
//    func getImageOrVideo(model : AZSCloudBlockBlob, group : DispatchGroup)
//    {
//        // Get single blob details
//        let blockBlob = blobContainer!.blockBlobReference(fromName: model.blobName)
//        let result = self.appDelegate.gListOfImages
//
//        let flagResponseModels = self.isLastModifiedUpdated(model: model)
//
//        if(result.count == 0 || flagResponseModels.isNewModel || flagResponseModels.isUpdatedModel)
//        {
//            blockBlob.downloadToData(completionHandler: { (error, data) in
//
//                if((error) != nil)
//                {
//                    DispatchQueue.main.async {
//                        if self.delegate != nil
//                        {
//                            self.delegate!.showError(errorMsg: "Error while downloading data")
//                        }
//                        print("error ", error as Any)
//                    }
//
//                    self.indexBlob =  self.indexBlob + 1
//                    self.downloadBlobs()
//                    group.leave()
//                }else
//                {
//                    // **************** Save data in document directory
//                    let strName = model.blobName
//                    // create URL for your image
//                    let fileURL = GlobalFunctions.shared.getImageDirectoryURL(strName:strName )
//
//                    DispatchQueue.global(qos: .background).async{
//
//                        print("fileURL ", fileURL)
//                        do {
//                            try data!.write(to: fileURL)
//                            print("Data Added Successfully")
//                        } catch {
//                            print(error)
//                        }
//
//                        if(!model.properties.contentType!.containsIgnoreCase("image"))
//                        {
//                            let imageData = UIImageJPEGRepresentation(self.thumbnailForVideo(videoURL: fileURL), 0.5)
//                            let strThumbImageName = String(format:"%@_image.jpeg",strName.components(separatedBy: ".").first!)
////
//                            // Save video Image
//                            let strFileNameObj = GlobalFunctions.shared.getImageDirectoryURL(strName: strThumbImageName)
//                            print("strFileName : ",strFileNameObj.absoluteString)
//
//                            do {
//                                try  imageData?.write(to: strFileNameObj)
//                                print("Thumbnail Image data Added Successfully")
//                            } catch {
//                                print(error)
//                            }
//
//                            DispatchQueue.main.async {
//                                if self.delegate != nil
//                                {
//                                    self.delegate!.refresh()
//                                }
//                            }
//                        }
//
//                        self.indexBlob =  self.indexBlob + 1
//                        self.downloadBlobs()
//                        group.leave()
//                    }
//
//                    // Save image in documentry
//                    if(model.properties.contentType!.containsIgnoreCase("image"))
//                    {
//                        // Save image
//                        _ = UIImage.init(data: data!)
//                        self.saveImageCacheData(model: model, imagePath: strName, flagResponseModels: flagResponseModels)
//                    }else
//                    {
//                        let strThumbImageName = String(format:"%@_image.jpeg",strName.components(separatedBy: ".").first!)
//                        self.saveImageCacheData(model: model, imagePath: strThumbImageName, flagResponseModels: flagResponseModels)
//                    }
//                }
//            })
//        }else
//        {
//            self.indexBlob =  self.indexBlob + 1
//            self.downloadBlobs()
//            group.leave()
//        }
//    }
//
//    // MARK: CHECK BLOB MODIFIED OR NEW ONE
//    func isLastModifiedUpdated(model : AZSCloudBlockBlob) -> (isNewModel : Bool, isUpdatedModel : Bool)
//    {
//        print("isLastModifiedUpdated")
//        var isModelPresent = true
//
//        for (_,modelOld) in appDelegate.gListOfImages.enumerated(){
//            if(model.blobName == modelOld.name) {
//                isModelPresent = true
//                if(model.properties.lastModified! != modelOld.lastModified!){
//                    return (false, true)
//                }
//                return (false, false)
//            }else{
//                isModelPresent = false
//            }
//        }
//
//        if(isModelPresent == false){
//            return (true, false)
//        }
//
//        return (true, false)
//    }
//
//    // MARK: UPDATE MODEL/APPDELEGATE ARRAY DATA
//    func saveImageCacheData(model : AZSCloudBlockBlob, imagePath: String, flagResponseModels : (isNewModel : Bool, isUpdatedModel : Bool))
//    {
//        // Save image
//        let strName = model.blobName
//
//        // create URL for your image
//        //        let fileURL = GlobalFunctions.shared.getImageDirectoryURL(strName:strName )
//
//        // Save image in delegate
//        if(flagResponseModels.isUpdatedModel)
//        {
//            for (index,modelData) in appDelegate.gListOfImages.enumerated()
//            {
//                if(model.blobName == modelData.name)
//                {
//                    print("Old model")
//                    self.appDelegate.gListOfImages.insert(ModelAzureData.init(name: strName, contentType: model.properties.contentType, lastModified: model.properties.lastModified, filePath: strName, imagePath:imagePath), at: index)
//                }
//            }
//        }else
//        {
//            print("isNewModel")
//
//            self.appDelegate.gListOfImages.append(ModelAzureData.init(name: strName, contentType: model.properties.contentType, lastModified: model.properties.lastModified, filePath: strName, imagePath:imagePath))
//        }
//    }
//
//    // SAVE THUMBNAIL FOR VIDEO
//    func thumbnailForVideo(videoURL : URL) -> UIImage
//    {
//        do {
//            let asset = AVURLAsset(url: videoURL , options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//        }
//
//        return UIImage()
//    }
//
//    func clearDiskCache() {
//        let fileManager = FileManager.default
//        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        guard let filePaths = try? fileManager.contentsOfDirectory(at: myDocuments, includingPropertiesForKeys: nil, options: []) else { return }
//        for filePath in filePaths {
//            print("filePath : ",filePath)
//            try? fileManager.removeItem(at: filePath)
//        }
//    }
//
//    // DELETE LOCAL DATA FROM MODEL AND DOCUMENT DIRECTORY
//    func deleteLocalData(arrBlobs : [AZSCloudBlockBlob]?)
//    {
//        print("Prev appDelegate.gListOfImages %d: %@ ",appDelegate.gListOfImages.count,appDelegate.gListOfImages)
//
//        if(arrBlobs?.count == 0)
//        {
//            appDelegate.gListOfImages = []
//            self.clearDiskCache()
//        }else if((arrBlobs ?? []).count > 0)
//        {
//            var arrDeletedIndex : [Int] = []
//            for (index,model) in appDelegate.gListOfImages.enumerated()
//            {
//                let result = arrBlobs?.filter({ (blob) -> Bool in
//                    if(model.name == blob.blobName)
//                    {
//                        return true
//                    }
//                    return false
//                })
//
//                if(result?.count == 0)
//                {
//                    do
//                    {
//                        let imgURL = GlobalFunctions.shared.getImageDirectoryURL(strName: model.filePath ?? "").absoluteString.replacingOccurrences(of: "file:///", with: "/")
//                        let fileURL = GlobalFunctions.shared.getImageDirectoryURL(strName: model.imagePath ?? "").absoluteString.replacingOccurrences(of: "file:///", with: "/")
//
//                        try FileManager.default.removeItem(atPath: imgURL)
//                        try FileManager.default.removeItem(atPath: fileURL)
//                    } catch let error {
//                        print("*** Error while removeItem: \(error.localizedDescription)")
//                    }
//                    print("index %d ",index)
//                    arrDeletedIndex.append(index)
//                }
//            }
//
//            for indexObj in arrDeletedIndex.reversed()
//            {
//                appDelegate.gListOfImages.remove(at: indexObj)
//            }
//
//            print("After appDelegate.gListOfImages %d: %@ ",appDelegate.gListOfImages.count,appDelegate.gListOfImages)
//        }
//    }
//}
