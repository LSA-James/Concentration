//
//  ViewController.swift
//  Concentration-myself-3
//
//  Created by James Liu on 2025/5/13.
//

import UIKit


//尝试push到云端
struct ThemeData {
    var emojis: String
    let cardColor: UIColor
    let backgroundColor: UIColor
    
    init(emojis: String, cardColor: UIColor, backgroundColor: UIColor) {
        self.emojis = emojis
        self.cardColor = cardColor
        self.backgroundColor = backgroundColor
    }
    
    init() {
        emojis = "🚗🚕🚙🚌🚎🏎️🚓🚑🚒🚐🛻🚚🚛🚜"
        cardColor = UIColor.black
        backgroundColor = UIColor.white
    }
}


class ViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var CardsButton: [UIButton]!
    @IBOutlet weak var flipCountLable: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var newGameButtonLable: UIButton!
    
    // MARK: IBAction
    @IBAction func touchCard(_ sender: UIButton) {
        if  let touchCardIndex = CardsButton.firstIndex(of: sender) {
            game.chooseCard(choosedIndex: touchCardIndex)
            updateTheView()
        }else{
            print("this UIButton is not in CardsButton")
        }
    }
    @IBAction func newGameButtonPressed(_ sender: Any) {
        game = Concentration(numberOfPairsOfCard: numberOfPairsOfCards)
        setCurrentTheme()
        updateTheView()
    }
    
    
    // MARK: Variable
    var numberOfPairsOfCards: Int{ return CardsButton.count/2 }
    var currentTheme: ThemeData = ThemeData()
    var emojiLinkWithCard = [Card:String]()
    var allTheTheme: [String: ThemeData] = [
        "CarTheme": ThemeData(emojis: "🚗🚕🚙🚌🚎🏎️🚓🚑🚒🚐🛻🚚🚛🚜", cardColor: UIColor.black, backgroundColor: UIColor.white),
        "AnimalTheme": ThemeData(emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮", cardColor: UIColor.black, backgroundColor: UIColor.green),
        "FruitTheme": ThemeData(emojis: "🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑", cardColor: UIColor.black, backgroundColor: UIColor.white),
        "SportTheme": ThemeData(emojis: "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏸🥅🏒", cardColor: UIColor.cyan, backgroundColor: UIColor.brown),
        "FaceTheme": ThemeData(emojis: "😀😃😄😁😆😅😂🤣☺️😊😇🙂", cardColor: UIColor.yellow, backgroundColor: UIColor.gray),
        "NationTheme": ThemeData(emojis: "🇹🇼🇯🇵🏳️🏴🏁🚩🏳️‍🌈🇱🇷🎌🇨🇦🇳🇵🇬🇪", cardColor: UIColor.red, backgroundColor: UIColor.black)
    ]
    lazy var game = Concentration(numberOfPairsOfCard: numberOfPairsOfCards)
    
    
    // MARK: Function
    func getRandomTheme(from ThemePool:[String: ThemeData])->ThemeData{
        guard let randomTheme = ThemePool.randomElement()?.value else{
            fatalError("⚠️ allTheTheme is empty! You must define at least one theme.")
        }
        return randomTheme
    }
    
    func setCurrentTheme() {
        currentTheme = getRandomTheme(from: allTheTheme)
        emojiLinkWithCard.removeAll()
        
        let defaultFont: UIFont = UIFont.systemFont(ofSize: 30)

        let flipCountLableAttributes:[NSAttributedString.Key: Any] = [
            .strokeColor : currentTheme.cardColor,
            .strokeWidth : 5.0,
            .font : UIFont(name: "System", size: 25) ?? defaultFont
        ]
        let scoreLableAtributes:[NSAttributedString.Key: Any] = [
            .strokeColor : currentTheme.cardColor,
            .strokeWidth : 5.0,
            .font : UIFont(name: "System", size: 25) ?? defaultFont
        ]
        let newGameButtonLableAttributes:[NSAttributedString.Key: Any] = [
            .strokeColor : currentTheme.cardColor,
            .strokeWidth : 5.0,
            .font : UIFont(name: "System", size: 30) ?? defaultFont
        ]
        
        let flipCountLableAttributesText        = NSAttributedString(string: "Flips: 0", attributes: flipCountLableAttributes)
        let scoreLableAtributesText             = NSAttributedString(string: "Score: 0", attributes: scoreLableAtributes)
        let newGameButtonLableAttributesText    = NSAttributedString(string: "New Game", attributes: newGameButtonLableAttributes)
        
        flipCountLable.attributedText =  flipCountLableAttributesText
        scoreLable.attributedText = scoreLableAtributesText
        newGameButtonLable.setAttributedTitle(newGameButtonLableAttributesText, for: UIControl.State.normal)
        self.view.backgroundColor = currentTheme.backgroundColor
        for index in CardsButton.indices {
            CardsButton[index].backgroundColor = currentTheme.cardColor
        }
    }
    
    func updateTheView(){
        for index in CardsButton.indices {
            if game.Cards[index].isFaceUp{
                CardsButton[index].setTitle(emoji(for: game.Cards[index]), for: UIControl.State.normal)
            }else{
                CardsButton[index].setTitle("", for: UIControl.State.normal)
                if game.Cards[index].isMatch {
                    CardsButton[index].backgroundColor = currentTheme.backgroundColor
                }
            }
        }
        flipCountLable.text = "Flip: \(game.flipCount)"
        scoreLable.text = "Score: \(game.score)"
    }

    func emoji(for card:Card)->String{
        if emojiLinkWithCard[card] == nil, currentTheme.emojis.count > 0 {
            let randomIndex = currentTheme.emojis.index(currentTheme.emojis.startIndex, offsetBy: currentTheme.emojis.count.arc4random)
            emojiLinkWithCard[card] = String(currentTheme.emojis.remove(at:randomIndex))
        }
        return emojiLinkWithCard[card] ?? "?"
    }
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentTheme()
    }
}

// MARK: Extention
extension Int{
    var arc4random: Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

