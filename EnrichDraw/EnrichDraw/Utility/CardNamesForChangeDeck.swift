//
//  CardNamesForChangeDeck.swift
//  EnrichDraw
//
//  Created by Rahul on 18/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


enum CardDeckType : Int {
    case zodiac = 0
    case planets
    case gemstones
}

class CardNamesForChangeDeck: NSObject {
    
    static let shared = CardNamesForChangeDeck()
//    private var intSelectedCard : CardDeckType = .zodiac
    var intLastSelected = 1

    func getRandomCardDeck() -> [String] {
//        if let intSelect = CardDeckType.init(rawValue: Int.random(in: 0...2)){
//            intSelectedCard = intSelect
//        }
//        return sendArrayOfRandomCards()
        var arrCards : [String] = []
        intLastSelected = intLastSelected + 1
        intLastSelected = (intLastSelected == 13) ? 1 : intLastSelected
        let selectCardsIndex = intLastSelected
        for _ in 0...5{
            arrCards.append("ImgCards\(selectCardsIndex)")
        }
        return arrCards
    }
    
//    func sendArrayOfRandomCards() -> [String] {
        // Get random numbers unique
//        let getRandom = randomSequenceGenerator(min: 1, max: 10)
//        for _ in 0...6{
//            print("randomSequenceGenerator = \(getRandom())")
//        }
        
//        var arrCards : [String] = []
//        switch intSelectedCard {
//        case .zodiac:
//            let selectCardsIndex = Int.random(in: 1...12)
//            for _ in 0...5{
//                arrCards.append("ImgCards\(selectCardsIndex)")
//            }
//
//        case .planets:
//            let selectCardsIndex = Int.random(in: 1...6)
//            for index in 0...5{
//                arrCards.append("ImgCards\(selectCardsIndex)")
//            }
//
//        case .gemstones:
//            let selectCardsIndex = Int.random(in: 1...3)
//            for index in 0...5{
//                arrCards.append("ImgZodiac\(selectCardsIndex)")
//            }
//
//        default:
//            break
//        }
//        return arrCards
//    }
    
//    private func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
//        var numbers: [Int] = []
//        return {
//            if numbers.isEmpty {
//                numbers = Array(min ... max)
//            }
//
//            let index = Int(arc4random_uniform(UInt32(numbers.count)))
//            return numbers.remove(at: index)
//        }
//    }
}
