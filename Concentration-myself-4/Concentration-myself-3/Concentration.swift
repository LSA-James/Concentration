//
//  Concentration.swift
//  Concentration-myself-3
//
//  Created by James Liu on 2025/5/13.
//

struct Concentration{
    
    var Cards = [Card]()
    var oneAndOnlyFaceUpCard:Int?{
        get{
            let faceUpIndices = Cards.indices.filter{ Cards[$0].isFaceUp }
            return faceUpIndices.count == 1 ? faceUpIndices.first : nil
        }
        set{
            for index in Cards.indices {
                Cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var flipCount = 0
    var score = 0


    mutating func chooseCard(choosedIndex:Int){
        assert(Cards.indices.contains(choosedIndex) , "Concentration.chooseCard(at: \(choosedIndex)): chosen index")
        if !Cards[choosedIndex].isMatch{
            if let index = oneAndOnlyFaceUpCard, index != choosedIndex{
                Cards[choosedIndex].isFaceUp = true
                if Cards[index] == Cards[choosedIndex] {
                    Cards[index].isMatch = true
                    Cards[choosedIndex].isMatch = true
                    score += 2
                }else{
                    Cards[index].mismatchCount += 1
                    Cards[choosedIndex].mismatchCount += 1
                    if Cards[index].mismatchCount > 1 { score -= 1 }
                    if Cards[choosedIndex].mismatchCount > 1 { score -= 1 }
                }
            }else{
                oneAndOnlyFaceUpCard = choosedIndex
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCard:Int) {
        Card.identifierCount = 0
        for _ in 1...numberOfPairsOfCard {
            let card = Card()
            Cards += [card, card]
        }
        Cards.shuffle()
    }
}
