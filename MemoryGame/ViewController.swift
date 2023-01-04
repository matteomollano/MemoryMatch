//
//  ViewController.swift
//  MemoryGame
//
//  Created by Matteo Mollano on 5/9/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var lblMovesLeft: UILabel!
    
    @IBOutlet weak var lblMovesMade: UILabel!
    
    // represents the number of buttons pressed during the memory game
    // used to increment MovesMade label when 2 buttons are pressed
    var numButtonPresses: Int = 0
    
    // this is an array that stores the sender tags of the recently pressed buttons
    var recentButtons: [Int] = []
    
    // this is an array that stores the actual previously pressed buttons
    var buttonArray: [UIButton] = []
    
    // this is an array to store all of the buttons pressed during the game
    var allButtons: [UIButton] = []
    
    // used for debugging purposes; used to simply print the 2D-array in the terminal just once
    var number = 0
    
    // instance of the MemoryGame class used for the game
    var Game: MemoryGame = MemoryGame()
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        // used for debugging purposes as mentioned above
        if number == 0 {
            Game.printPopulatedArray()
        }
        
        number += 1
        
        var newLabel: String
        var image: UIImage
        
        numButtonPresses += 1
        
        if let movesString = lblMovesMade.text, let movesLeftString = lblMovesLeft.text {
            if numButtonPresses == 2 {
                // update MovesMade label
                var movesMade: Int = Int(movesString)!
                movesMade = movesMade + 1
                lblMovesMade.text = String(movesMade)
                
                // update MovesLeft label
                var movesLeft: Int = Int(movesLeftString)!
                movesLeft = movesLeft - 1
                lblMovesLeft.text = String(movesLeft)
                
                // reset the number of buttons pressed to get the next two buttons
                numButtonPresses = 0
            }
        }
        
        if let label = sender.titleLabel!.text {
            newLabel = label
        }
        else {
            newLabel = " "
        }
        
        if newLabel != " " && Game.emojiArray[sender.tag].hasMatched == false { // if hasMatched == true, the image should not be set back to the wolf
            image = (UIImage(named: "Wolf.jpeg") as UIImage?)!
            newLabel = " "
            sender.setBackgroundImage(image, for: UIControl.State.normal)
            sender.setTitle(newLabel, for: UIControl.State.normal)
        }
        else {
            image = (UIImage(named: "Empty.jpeg") as UIImage?)!
            // newLabel = Game.emojiArray[sender.tag].emojiSymbol // used to add emojis from 2D-Array to each corresponding button
            newLabel = Game.getEmoji(tag: sender.tag) // same as above
            sender.setBackgroundImage(image, for: UIControl.State.normal)
            sender.setTitle(newLabel, for: UIControl.State.normal)
        }
        
        // add the sender tag of pressed button to recentButtons array
        recentButtons.append(sender.tag)
        
        // create a variable called button that will save the currently pressed button
        let button = sender.self
        // append this button to the buttonArray
        buttonArray.append(button)
        // append this button to the allButtons array
        allButtons.append(button)
        
        if recentButtons.count == 2 && buttonArray.count == 2 { // check the two previously pressed buttons
            let sendertag1 = recentButtons[0]
            let sendertag2 = recentButtons[1]
    
            if (Game.isMatch(tag1: sendertag1, tag2: sendertag2)) { // if the emojis at the two previously pressed buttons are the same
                let newImage = (UIImage(named: "Empty.jpeg") as UIImage?)!
                
                for button in buttonArray {
                    button.setBackgroundImage(newImage, for: UIControl.State.normal)
                }
                
            } else { // if the emojis of the two previously pressed buttons are different
                // set the background image of the two previously pressed buttons back to the wolf img
                let newImage = (UIImage(named: "Wolf.jpeg") as UIImage?)!
                
                for button in buttonArray {
                    let seconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds){ // used to add a delay before cards are flipped
                        button.setBackgroundImage(newImage, for: UIControl.State.normal)
                    }
                }
                
                for button in buttonArray {
                    let seconds = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds){ // used to add a delay before emojis are removed when cards are flipped
                        button.setTitle(" ", for: UIControl.State.normal)
                    }
                }
            }
            
            // reset the arrays so that they can store the next two pressed buttons
            recentButtons.removeAll()
            buttonArray.removeAll()
        }
        
        // sender.setTitle(newLabel, for: UIControl.State.normal)
        
        // sender.setBackgroundImage(image, for: UIControl.State.normal)
        
        // Code checking for win condition
        let numMovesLeft: Int = Int(lblMovesLeft.text!)!
        
        if numMovesLeft == 0 {
            
            if (Game.isWin()) {
                let myAlert = UIAlertController(title: "Congrats", message: "You Win!", preferredStyle: UIAlertController.Style.alert)
                // myAlert.addAction(UIAlertAction(title: "Play Again!", style: UIAlertAction.Style.default, handler: nil))
                myAlert.addAction(UIAlertAction(title: "Play Again!", style: UIAlertAction.Style.default, handler: {action in updateGame()}))
                self.present(myAlert, animated: true, completion: nil)
                // updateGame()
            }
            else { // game loss
                let myAlert = UIAlertController(title: "Sorry", message: "You lose.", preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: {action in updateGame()}))
                self.present(myAlert, animated: true, completion: nil)
                // updateGame()
            }
        }
        
        else if numMovesLeft > 0 {
            if (Game.isWin()) {
                let myAlert = UIAlertController(title: "Congrats", message: "You Win!", preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "Play Again!", style: UIAlertAction.Style.default, handler: {action in updateGame()}))
                self.present(myAlert, animated: true, completion: nil)
                // updateGame()
            }
        }
        
        func updateGame() {
            lblMovesLeft.text = "20"
            lblMovesMade.text = "0"
            
            let newImage = (UIImage(named: "Wolf.jpeg") as UIImage?)!
            
            for button in allButtons {
                button.setBackgroundImage(newImage, for: UIControl.State.normal)
            }
            
            for button in allButtons {
                button.setTitle(" ", for: UIControl.State.normal)
            }
            
            Game.playAgain()
            number = 0
        }
    }
}

