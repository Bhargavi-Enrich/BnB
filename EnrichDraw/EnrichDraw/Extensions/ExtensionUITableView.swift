//
//  ExtensionUITableView.swift
//  EnrichSalon
//
//  Created by Apple on 15/05/19.
//  
//
// How to use
/*
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if things.count == 0 {
 self.tableView.setEmptyMessage("My Message")
 } else {
 self.tableView.restore()
 }
 
 return things.count
 }
*/
import UIKit
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Montserrat-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 24.0 : 16.0)!
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
       // self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
}
