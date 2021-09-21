//
//  EN_VC_SlideShow.swift
//  DiggerSDKIntegration
//
//  Modified on 11/28/18.
//  Copyright © 2018 Apple. All rights reserved.

import UIKit
import AVKit
import AVFoundation

class EN_VC_SlideShow: UIViewController {
    
    struct Model
    {
        var type:String
        var path:Any
        
    }
    
    @IBOutlet weak var imgOut: UIImageView!
    var slideShowObj = [Any]()
    var player = AVPlayer()
    let playerViewController = CustomAVPlayerViewController()
    var indextoLoad:Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTabGesture()
        self.setData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetTabGesture OnView
    func setTabGesture()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.imgOut.addGestureRecognizer(tap)
    }
    
    // MARK: - handleTap
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        NotificationCenter.default.removeObserver(self)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
       
    }
    
    
    
    // MARK: - SetData
    func setData()
    {
        if((self.appDelegate.gListOfImages ?? []).count > 0)
        {
            self.slideShowObj = self.appDelegate.gListOfImages ?? []
            DispatchQueue.main.async {
                self.loadNextSlide(index: self.indextoLoad)
            }
        }
    }
    
    // MARK: - loadNextSlide
    func loadNextSlide(index:Int)
    {
        if let objectToLoad = self.slideShowObj[index] as? [String : Any]{
            
            if let type = objectToLoad["type"] as? String, type.containsIgnoreCase("video") {
                self.playVideo(objecttoLoad: objectToLoad)
                return
            }
            
            if let strFileId = objectToLoad["id"] as? String, let strFileURL = objectToLoad["url"] as? String,let type = objectToLoad["type"] as? String, !type.containsIgnoreCase("video") {
                
                let arrObj = strFileURL.components(separatedBy: ".")
                let finalStrForLink = strFileId + ".\(arrObj.last ?? "")"
                UIView.animate(withDuration: 0.0, animations: {
                    let newString = GlobalFunctions.shared.getImageDirectoryURL(strName: finalStrForLink).absoluteString.replacingOccurrences(of: "file:///", with: "/")
                    let image =  UIImage(contentsOfFile:newString )
                    self.imgOut.image = image
                    sleep(UInt32(3.0))
                }, completion: { finished in
                    self.indexToUpdate()
                    self.loadNextSlide(index: self.indextoLoad)
                })
            }
        }
    }
    
    // MARK: - playVideo
    
    func playVideo (objecttoLoad: [String : Any])
    {
//        let videoURL = GlobalFunctions.shared.getImageDirectoryURL(strName: objecttoLoad.filePath ?? "").absoluteString

        if let strFileId = objecttoLoad["id"] as? String, let strFileURL = objecttoLoad["url"] as? String  {
            let arrObj = strFileURL.components(separatedBy: ".")
            let finalStrForLink = strFileId + ".\(arrObj.last ?? "")"
            let videoURL = GlobalFunctions.shared.getImageDirectoryURL(strName: finalStrForLink).absoluteString

            player = AVPlayer(url:Foundation.URL(string: videoURL)!  )
            playerViewController.parentObj = self
            playerViewController.player = player
            self.playerViewController.isVideoEnd = true
            
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.present(self.playerViewController, animated: true) {
                    DispatchQueue.main.async {
                        self.playerViewController.player!.play()
                    }
                }
            }
        }
    }
    
    
    // MARK: - playerDidFinishPlaying
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.isVideoEnd = false
        if(!self.playerViewController.isBeingDismissed)
        {
            self.playerViewController.dismiss(animated: false) {
                self.indexToUpdate()
                self.loadNextSlide(index: self.indextoLoad)
            }
        }
    }
    
   
    
    // MARK: - indexToUpdate
    
    func indexToUpdate()
    {
        if( self.indextoLoad == self.slideShowObj.count - 1 )
        {
            self.indextoLoad = 0
        }
        else
        {
            self.indextoLoad = self.indextoLoad + 1
        }
    }
    
    // MARK: Helper Methods
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN))
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
