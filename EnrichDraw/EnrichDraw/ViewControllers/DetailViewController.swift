//
//  DetailViewController.swift
//  EnrichDraw
//
//  Created by Apple on 22/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
 
    
    func configureView() {
        // Update the user interface for the detail item.
       /* if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }*/
        
    }
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
     // MARK: All Click Action
    @IBAction func clickTrySpin(_ sender: Any) {
         let spinWheelController = EN_VC_SpinWheel.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(spinWheelController, animated: true)
    }
    
}

