//
//  MemoryModel.swift
//  MemoryGame
//
//  Created by Matteo Mollano on 5/9/22.
//

import Foundation

struct Node {
    var emojiSymbol: String
    var hasMatched: Bool
    
    init (emojiSymbol: String, hasMatched: Bool) {
        self.emojiSymbol = emojiSymbol
        self.hasMatched = hasMatched
    }
}

class MemoryGame {
    
    init(){
        populateArray()
    }
    
    // array of random emojis for memory game
    var randomEmojis: [String] = ["😁", "🏀", "🍕", "🌎", "🌉", "🚀", "🐕", "🇮🇹", "🚗", "💎","😁", "🏀", "🍕", "🌎", "🌉", "🚀", "🐕", "🇮🇹", "🚗", "💎"]
    
    // 2D-array used for memory game
    // it is an array of Node structs
    var emojiArray: [Node] = []
    
    // function to randomly shuffle the emoji array
    // so that the emojis are inserted into the 2D-array
    // randomly when the 2D-array is populated
    func shuffleArray(){
        randomEmojis.shuffle()
    }
    
    // function to print out the randomEmojis array
    // ** for debugging purposes **
    func printArray(){
        print(randomEmojis)
    }
    
    
    // function to populate 2D-Array
    func populateArray(){
        shuffleArray()
        
        for i in 0..<randomEmojis.count{
            let emojiNode: Node = Node(emojiSymbol: randomEmojis[i], hasMatched: false)
            emojiArray.append(emojiNode)
        }
    }
    
    // function to print the populated 2D-Array
    // ** for debugging purposes **
    func printPopulatedArray(){
        print (emojiArray)
    }
    
    // function to reset the 2D-Array
    func clearArray(){
        emojiArray.removeAll()
    }
    
    // returns an emoji given a specified tag
    func getEmoji(tag: Int) -> String {
        return emojiArray[tag].emojiSymbol
    }
    
    // translates a tag number to a row and column number
    func translate(tag: Int) -> (Int, Int) {
        
        let row: Int
        
        switch tag {
            case 0...3:
                row = 1
            case 4...7:
                row = 2
            case 8...11:
                row = 3
            case 12...15:
                row = 4
            case 16...19:
                row = 5
            default:
                row = 1
        }
        
        let column: Int = tag % 4
        
        return (row, column)
    }
    
    // checks to see if two items in the emojiArray match
    func isMatch(tag1: Int, tag2: Int) -> Bool {
        let tag1emoji = getEmoji(tag: tag1)
        let tag2emoji = getEmoji(tag: tag2)
        
        if tag1emoji == tag2emoji {
            emojiArray[tag1].hasMatched = true
            emojiArray[tag2].hasMatched = true
            return true
        }
        else {
            return false
        }
    }
    
    // checks the game board for a win
    func isWin() -> Bool {
        for i in 0..<emojiArray.count{
            if emojiArray[i].hasMatched == false {
                return false
            }
        }
        
        return true
    }
    
    // allows the user to play the game with a newly shuffled board
    func playAgain(){
        clearArray()
        populateArray()
    }
}
