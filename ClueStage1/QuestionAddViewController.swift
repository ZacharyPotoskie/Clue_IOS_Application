//
//  SecondSecondViewController.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 8/30/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

class QuestionAddViewController: UIViewController {
    
    //player chooser stuff
    @IBOutlet var askertellerButtonList: [UIButton]!

    //respone chooser stuff
    @IBOutlet var responseButtonList: [UIButton]!
    
    //CARD CHOOSER STUFF
    //weapon button and picker button outlets
    @IBOutlet weak var weaponButton: UIButton!
    @IBOutlet var weaponPickerButtonList: [UIButton]!
    
    //suspect button and picker button outlets
    @IBOutlet weak var suspectButton: UIButton!
    @IBOutlet var suspectPickerButtonList: [UIButton]!
    
    //room button and picker button outlets
    @IBOutlet weak var roomButton: UIButton!
    @IBOutlet var roomPickerButtonList: [UIButton]!
    
    //main buttons list
    var mainButtonList: [UIButton] = []
    //mini buttons list
    var cardPickerButtonList: [[UIButton]?] = []
    //mini button states list
    var cardPickerStateList: [Bool] = []
    
    //boolean variables that correspond to whether the card pickers are open (true) or closed (false).
    var suspectPickerState: Bool = false
    var weaponPickerState: Bool = false
    var roomPickerState: Bool = false
    
    var askerCounter: Int = -1
    var tellerCounter: Int = -1
    var primaryResponseCounter: Int = -1
    var secondaryResponseCounter: Int = -1
    
    //colors
    let lightBlueCol = UIColor(red: 10/255.0, green: 95/255.0, blue: 200/255.0, alpha: 1.0)
    let themeBlueCol = UIColor(red: 72/255.0, green: 172/255.0, blue: 247/255.0, alpha: 1.0)
    let darkBlueCol = UIColor(red: 0/255.0, green: 95/255.0, blue: 133/255.0, alpha: 1.0)
    
    var playerList: [String] = []
    var questionList: [String] = ["", "", "", "", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainButtonList = [suspectButton, weaponButton, roomButton]
        cardPickerButtonList = [suspectPickerButtonList, weaponPickerButtonList, roomPickerButtonList]
        cardPickerStateList = [suspectPickerState, weaponPickerState, roomPickerState]
        
        let refreshAddQuestionButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(refreshAddQuestionButtonTapped))
        self.navigationItem.leftBarButtonItem = refreshAddQuestionButton
        refreshAddQuestionButton.isEnabled = true
        
        let submitQuestionButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submitQuestionButtonTapped))
        self.navigationItem.rightBarButtonItem = submitQuestionButton
        submitQuestionButton.isEnabled = true
        
        let s:CGFloat = (UIScreen.main.nativeBounds.width + 72) / 8
        let sy: CGFloat = (s * sqrt(3)) / 2
        let sx: CGFloat = (s / 2)
        
        //configure asker teller buttons
        let tabbar = tabBarController as! baseViewController
        playerList = tabbar.playerList
        for button in askertellerButtonList {
            button.frame.size.width = 72
            button.frame.size.height = 72
            button.layer.cornerRadius = 36
            button.backgroundColor = lightBlueCol
            if button == askertellerButtonList[0] {
                button.center.y = view.center.y - sy
                button.center.x = view.center.x - sx
            }
            else if button == askertellerButtonList[1] {
                button.center.y = view.center.y - sy
                button.center.x = view.center.x + sx
            }
        }
        //configure response buttons
        for button in responseButtonList {
            button.frame.size.width = 72
            button.frame.size.height = 72
            button.layer.cornerRadius = 36
            button.backgroundColor = lightBlueCol
            if button == responseButtonList[0] {
                button.center.y = view.center.y + sy
                button.center.x = view.center.x - sx
            }
            else if button == responseButtonList[1] {
                button.center.y = view.center.y + sy
                button.center.x = view.center.x + sx
            }
        }
        
        
        //configure the main buttons
        for button in mainButtonList {
            button.frame.size.width = 72
            button.frame.size.height = 72
            button.layer.cornerRadius = 36
            button.backgroundColor = lightBlueCol
            if button == suspectButton {
                button.center.y = view.center.y
                button.center.x = view.center.x - s
            }
            else if button == weaponButton {
                button.center.y = view.center.y
                button.center.x = view.center.x
            }
            else if button == roomButton {
                button.center.y = view.center.y
                button.center.x = view.center.x + s
            }
        }
            
        //configure the mini weapon icon buttons
        for buttonList in cardPickerButtonList {
            for button in buttonList! {
                button.frame.size.width = 72
                button.frame.size.height = 72
                button.layer.cornerRadius = 36
                if suspectPickerButtonList.contains(button) {
                    //chill
                }
                else {
                    button.backgroundColor = themeBlueCol
                }
                button.alpha = 0
                button.center.x = view.center.x
                button.center.y = view.center.y
            }
        }
    }
    
    @objc func refreshAddQuestionButtonTapped() {
        performSegue(withIdentifier: "submitQuestionSegue", sender: self)
    }
    
    @objc func submitQuestionButtonTapped() {
        if !questionList[0].isEmpty && !questionList[1].isEmpty && !questionList[2].isEmpty && !questionList[3].isEmpty && !questionList[4].isEmpty && !questionList[5].isEmpty && !questionList[6].isEmpty {
            if questionList[0] != questionList[1] {
                let tabbar = tabBarController as! baseViewController
                tabbar.questionList.insert(questionList, at: 0)
                performSegue(withIdentifier: "submitQuestionSegue", sender: self)
                print(questionList)
            }
            else {
                print("asker is the responder")
            }
        }
        else {
            print("missing something")
        }
    }

    
    //important function...
    func hideshowOtherElements (action: String) {
        if action == "hide" {
            UIView.animate(withDuration: 0.5) {
                for button in self.mainButtonList{
                    button.alpha = 0
                }
                for button in self.askertellerButtonList {
                    button.alpha = 0
                }
                for button in self.responseButtonList {
                    button.alpha = 0
                }
            }
        }
        else if action == "show" {
            UIView.animate(withDuration: 0.5) {
                for button in self.mainButtonList {
                    button.alpha = 1
                }
                for button in self.askertellerButtonList {
                    button.alpha = 1
                }
                for button in self.responseButtonList {
                    button.alpha = 1
                }
            }
        }
    }

    //player picker functions
    @IBAction func askertellerButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            sender.backgroundColor = self.themeBlueCol
        }
        if sender.tag == 0 {
            if askerCounter == -1 || askerCounter == 2 {
                askerCounter = 0
                sender.setTitle(playerList[0], for: .normal)
            }
            else if askerCounter == 0 {
                askerCounter = 1
                sender.setTitle(playerList[1], for: .normal)
            }
            else if askerCounter == 1 {
                askerCounter = 2
                sender.setTitle(playerList[2], for: .normal)
            }
            questionList[0] = sender.currentTitle!
        }
        else if sender.tag == 1 {
            if tellerCounter == -1 || tellerCounter == 2 {
                tellerCounter = 0
                sender.setTitle(playerList[0], for: .normal)
            }
            else if tellerCounter == 0 {
                tellerCounter = 1
                sender.setTitle(playerList[1], for: .normal)
            }
            else if tellerCounter == 1 {
                tellerCounter = 2
                sender.setTitle(playerList[2], for: .normal)
            }
            questionList[1] = sender.currentTitle!
        }
    }
    
    @IBAction func responseButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            sender.backgroundColor = self.themeBlueCol
        }
        if sender.tag == 0 {
            if primaryResponseCounter == -1 || primaryResponseCounter == 3 {
                primaryResponseCounter = 0
                sender.setTitle("Suspect", for: .normal)
            }
            else if primaryResponseCounter == 0 {
                primaryResponseCounter = 1
                sender.setTitle("Weapon", for: .normal)
            }
            else if primaryResponseCounter == 1 {
                primaryResponseCounter = 2
                sender.setTitle("Room", for: .normal)
            }
            else if primaryResponseCounter == 2 {
                primaryResponseCounter = 3
                sender.setTitle("No", for: .normal)
            }
            questionList[5] = sender.currentTitle!
        }
        else if sender.tag == 1 {
            if secondaryResponseCounter == -1 || secondaryResponseCounter == 2 {
                secondaryResponseCounter = 0
                sender.setTitle("Yes", for: .normal)
            }
            else if secondaryResponseCounter == 0 {
                secondaryResponseCounter = 1
                sender.setTitle("No", for: .normal)
            }
            else if secondaryResponseCounter == 1 {
                secondaryResponseCounter = 2
                sender.setTitle("Maybe", for: .normal)
            }
            questionList[6] = sender.currentTitle!
        }
    }
    
    
    //card picker functions...
    func changeCardPicker (action: String, mainButton: UIButton, miniButtonList: [UIButton]) {
        let c = view.center
        let n: Int = miniButtonList.count
        let d: CGFloat = 80
        let a: CGFloat = CGFloat.pi * 2 / CGFloat(n)
        let r: CGFloat = d / sqrt(2*(1-cos(a)))
        
        if mainButton == suspectButton && miniButtonList == suspectPickerButtonList {
            mainButton.setImage(UIImage(named: "s-40"), for: .normal)
        }
        else if mainButton == weaponButton && miniButtonList == weaponPickerButtonList {
            mainButton.setImage(UIImage(named: "w-40"), for: .normal)
        }
        else if mainButton == roomButton && miniButtonList == roomPickerButtonList {
            mainButton.setImage(UIImage(named: "r-40"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.5) {
            var p: Int = 0
            for button in miniButtonList {
                if action == "hide" {
                    button.center.x = c.x
                    button.center.y = c.y
                    button.alpha = 0
                }
                else if action == "show" {
                    let t = a * CGFloat(p)
                    let x = cos(t) * r + c.x
                    let y = sin(t) * r + c.y
                    button.center.x = x
                    button.center.y = y
                    button.alpha = 1
                    p = p + 1
                }
            }
        }
    }
    
    @IBAction func cardMainButtonTapped(_ sender: UIButton) {
        cardPickerStateList[sender.tag] = true
        changeCardPicker(action: "show", mainButton: mainButtonList[sender.tag], miniButtonList: cardPickerButtonList[sender.tag]!)
        hideshowOtherElements (action: "hide")
    }
    
    @IBAction func cardPickerButtonTapped(_ sender: UIButton) {
        hideshowOtherElements (action: "show")
        if suspectPickerButtonList.contains(sender) {
            questionList[2] = constants.allCardsList[sender.tag]
            cardPickerStateList[0] = false
            changeCardPicker(action: "hide", mainButton: suspectButton, miniButtonList: suspectPickerButtonList)
            UIView.animate(withDuration: 0.5) {
                self.suspectButton.backgroundColor = self.themeBlueCol
                self.suspectButton.setImage(sender.currentImage, for: .normal)
            }
        }
        else if weaponPickerButtonList.contains(sender) {
            questionList[3] = constants.allCardsList[sender.tag]
            cardPickerStateList[1] = false
            changeCardPicker(action: "hide", mainButton: weaponButton, miniButtonList: weaponPickerButtonList)
            UIView.animate(withDuration: 0.5) {
                self.weaponButton.backgroundColor = self.themeBlueCol
                self.weaponButton.setImage(sender.currentImage, for: .normal)
            }
        }
        else if roomPickerButtonList.contains(sender) {
            questionList[4] = constants.allCardsList[sender.tag]
            cardPickerStateList[2] = false
            changeCardPicker(action: "hide", mainButton: roomButton, miniButtonList: roomPickerButtonList)
            UIView.animate(withDuration: 0.5) {
                self.roomButton.backgroundColor = self.themeBlueCol
                self.roomButton.setImage(sender.currentImage, for: .normal)
            }
        }
    }
}
