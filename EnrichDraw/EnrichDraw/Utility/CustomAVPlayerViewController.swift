//
//  CustomAVPlayerViewController.swift
//  EnrichDraw
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CustomAVPlayerViewController: AVPlayerViewController {

    var parentObj:EN_VC_SlideShow?
    var isVideoEnd = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // self.showsPlaybackControls = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismissAllViews(flag: isVideoEnd)


    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
       self.dismissAllViews(flag: true)

    }
    
    func dismissAllViews(flag:Bool)
    {
        self.player?.pause()
        self.player?.replaceCurrentItem(with: nil)
        
        if !self.isBeingDismissed
        {
            self.dismiss(animated: false, completion: nil)
        }
        
        if(self.parentObj != nil && flag)
        {
            self.parentObj!.dismiss(animated: false, completion: nil)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
