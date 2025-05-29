//
//  Card.swift
//  Concentration-myself-3
//
//  Created by James Liu on 2025/5/13.
//

struct Card: Hashable{

    var isFaceUp = false
    var isMatch = false
    var identifier:Int
    var mismatchCount = 0
    
    static var identifierCount = 0
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(identifier)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    
    init() {
        identifier = Card.identifierCount
        Card.identifierCount += 1
    }
    
}
