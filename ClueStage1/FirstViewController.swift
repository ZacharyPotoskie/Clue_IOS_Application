//
//  FirstViewController.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 8/28/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

struct cardData {
    var cardsHave: Set<String>
    var cardsNull: Set<String>
    var cardsMust: Set<Set<String>>
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    var myCards = [String]()
    
    @IBOutlet weak var player1field: UITextField!
    @IBOutlet weak var player2field: UITextField!
    
    @IBOutlet var cardCheckbuttonCollection: [UIButton]!
    
    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.player1field.delegate = self
        self.player2field.delegate = self
        
        //create and configure the "done" nav control button
        let finishSetupButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishSetupButtonTapped))
        self.navigationItem.rightBarButtonItem = finishSetupButton
        finishSetupButton.isEnabled = false
        
        //create and configure the "refresh" nav control button
        let refreshSetupButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshSetupButtonTapped))
        self.navigationItem.leftBarButtonItem = refreshSetupButton
        refreshSetupButton.isEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //chill for now
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //nothing rn
    }
    
    //function called when a card checkbox is tapped
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        //either add or deletes the tapped card to the myCards array
        if myCards.count < 6 {
            if sender.isSelected {
                sender.isSelected = false
                myCards = myCards.filter { $0 != constants.allCardsList[sender.tag]}
            } else {
                sender.isSelected = true
                myCards.append(constants.allCardsList[sender.tag])
            }
        }
        else if myCards.count == 6 {
            if sender.isSelected == true {
                sender.isSelected = false
                myCards = myCards.filter { $0 != constants.allCardsList[sender.tag]}
            }
        }
        //either enables or disables the "done" button depending on the size and content of the textfields and buttons
        if myCards.count < 6 || player1field.text!.isEmpty || player2field.text!.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else if myCards.count == 6 && (!player1field.text!.isEmpty && !player2field.text!.isEmpty) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    //function called when a textfield is exited
    func textFieldDidEndEditing(_ textField: UITextField) {
        //either enables or disables the "done" button depending on the size and content of the textfields and buttons
        if myCards.count < 6 || textField.text!.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else if myCards.count == 6 && !textField.text!.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    //function that runs when the "done" button is tapped
    @objc func finishSetupButtonTapped() {
        //allow access to global variables
        let tabbar = tabBarController as! baseViewController
        
        //update global variable: playerList
        tabbar.playerList = ["Zack", player1field.text!, player2field.text!]
        
        //update global variable: playerCardData
        
        switchKey(&tabbar.playerCardData, fromKey: "player0", toKey: tabbar.playerList[0])
        switchKey(&tabbar.playerCardData, fromKey: "player1", toKey: tabbar.playerList[1])
        switchKey(&tabbar.playerCardData, fromKey: "player2", toKey: tabbar.playerList[2])
        
        tabbar.playerCardData["Zack"]?.cardsHave = Set(myCards)
        tabbar.playerCardData["Zack"]?.cardsNull = (constants.allCardsSet).subtracting(Set(myCards))
        tabbar.playerCardData[tabbar.playerList[1]]?.cardsNull = Set(myCards)
        tabbar.playerCardData[tabbar.playerList[2]]?.cardsNull = Set(myCards)
        
        //disable refresh button
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        //change the global variable: questionAddButtonState to enable question add button (in question tab)
        tabbar.questionAddButtonState = true
    }
    
    //function that runs when the "refresh" button is tapped
    @objc func refreshSetupButtonTapped() {
        player1field.text = ""
        player2field.text = ""
        for button in cardCheckbuttonCollection {
            button.isSelected = false
        myCards = [String]()
        }
    }
    
    //functions that deal with the text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        player1field.resignFirstResponder()
        player2field.resignFirstResponder()
        return true
    }
    
}


