//
//  CustomPopUpUserData.swift
//  EnrichDraw
//
//  Modified on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
enum SelectedGame : Int {
    case spinWheel = 0
    case scratchCard
    case dice
    case cards
    case casino
}

protocol  CustomPopUpUserDataDelegate {
    func selectedActionSpinScratchCardDiceCardsCasino(selectedGame : SelectedGame)
}

class CustomPopUpUserData: UIView {
    
    open var delegate : CustomPopUpUserDataDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewWhitePopUp: UIView!
    var lastSelectedGame : SelectedGame = .spinWheel
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.viewWhitePopUp.layer.cornerRadius = 7;
        lblTitle.text = "kl_ChoiceTitle".localized
        lblDescription.text = "kl_ChoiceMsg".localized
    }
    
    @IBAction func actionClosePopUp(_ sender: Any) {
        delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: lastSelectedGame)
        self.removeFromSuperview()
    }
    
    //MARK:- IBActions
    @IBAction func actionSpinWheel(_ sender: UIButton) {
        self.removeFromSuperview()
        switch sender.tag {
        case 101: delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame.spinWheel)
        case 102: delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame.scratchCard)
        case 103: delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame.dice)
        case 104: delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame.casino)
        case 105: delegate?.selectedActionSpinScratchCardDiceCardsCasino(selectedGame: SelectedGame.cards)

        default:
            break;
        }
    }
}
