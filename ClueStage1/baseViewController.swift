//
//  baseViewController.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 8/29/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

class baseViewController: UITabBarController {
    
    struct cardData {
        var cardsHave: Set<String>
        var cardsNull: Set<String>
        var cardsMust: Set<Set<String>>
    }
    
    // global boolean varariable that determines whether the question add button is enabled (true) or disabled (false). Default is false before any changes. Disallows questions to be added before the settings are setup and if the settings are being edited.
    var questionAddButtonState: Bool = false
    
    // global array variable that holds the strings of players in the game
    var playerList = [String] () // EDIT
    
    // global dictionary
    var playerCardData: [String: cardData] = ["player0":cardData(cardsHave: Set<String> (), cardsNull: Set<String> (), cardsMust: Set<Set<String>> ()), "player1":cardData(cardsHave: Set<String> (), cardsNull: Set<String> (), cardsMust: Set<Set<String>> ()), "player2":cardData(cardsHave: Set<String> (), cardsNull: Set<String> (), cardsMust: Set<Set<String>> ())]
    
    var questionList = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
