//
//  ThirdViewControllViewController.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 8/28/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

class ThirdViewControllViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    var questionList = [[String]]()
    var murderCards = Set<String> ()
    var safeSuspects = Set<String> ()
    var safeWeapons = Set<String> ()
    var safeRooms = Set<String> ()
    
    let numberOfColumn:CGFloat = 4
    let firstColumnWidth:CGFloat = 120
    let standardColumnWidth:CGFloat = 40
    let standardCellHeight:CGFloat = 40
    let numberOfCells:Int = 88
    var cellColorList: [UIColor] = Array(repeating: UIColor.gray, count: 88)
    
    func findOtherPlayer(asker: String, responder: String) -> String {
        let tabbar = tabBarController as! baseViewController
        let questionPlayers: [String] = [asker, responder]
        let otherPlayerList: [String] = tabbar.playerList.filter{item in !questionPlayers.contains(item)}
        return otherPlayerList[0]
    }
    
    func reevaluteMurderCards () {
        let tabbar = tabBarController as! baseViewController
        murderCards = (tabbar.playerCardData[tabbar.playerList[0]]?.cardsNull)!.intersection((tabbar.playerCardData[tabbar.playerList[1]]?.cardsNull)!.intersection((tabbar.playerCardData[tabbar.playerList[2]]?.cardsNull)!))
        safeSuspects = ((tabbar.playerCardData[tabbar.playerList[0]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[1]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[2]]?.cardsHave)!))).intersection(constants.allSuspectsSet)
        safeWeapons = ((tabbar.playerCardData[tabbar.playerList[0]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[1]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[2]]?.cardsHave)!))).intersection(constants.allWeaponsSet)
        safeRooms = ((tabbar.playerCardData[tabbar.playerList[0]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[1]]?.cardsHave)!.union((tabbar.playerCardData[tabbar.playerList[2]]?.cardsHave)!))).intersection(constants.allRoomsSet)
        var safeCards: [Set<String>] = [safeSuspects, safeWeapons, safeRooms]
        var allCards: [Set<String>] = [constants.allSuspectsSet, constants.allWeaponsSet, constants.allRoomsSet]
        for number in 0..<3 {
            for card in allCards[number] {
                if number == 0 || number == 1 {
                    if safeCards[number].contains(card) == false && (safeCards[number].count == 5) {
                        self.murderCards.insert(card)
                    }
                }
                else if number == 2 {
                    if safeCards[number].contains(card) == false && (safeCards[number].count == 9) {
                        self.murderCards.insert(card)
                    }
                }
            }
        }
    }
    
    func evaluateQuestionList () {
        let tabbar = tabBarController as! baseViewController
        if tabbar.playerList.count == 3 {
            murderCards = Set<String> ()
            let tabbar = tabBarController as! baseViewController
            questionList = tabbar.questionList
            for question in questionList {
                let questionCardSet: Set<String> = [question[2], question[3], question[4]]
                let otherPlayer = findOtherPlayer(asker: question[0], responder: question[1])
                if question[0] == "Zack" {
                    if question[5] == "No" {
                        for card in questionCardSet {
                            tabbar.playerCardData[question[1]]?.cardsNull.insert(card)
                        }
                        if question[6] == "No" {
                            for card in questionCardSet {
                                tabbar.playerCardData[otherPlayer]?.cardsNull.insert(card)
                            }
                        }
                        else if question[6] == "Yes" {
                            tabbar.playerCardData[otherPlayer]?.cardsMust.insert(questionCardSet)
                        }
                    }
                    else if question[5] == "Suspect" {
                        tabbar.playerCardData[question[1]]?.cardsHave.insert(question[2])
                        tabbar.playerCardData[otherPlayer]?.cardsNull.insert(question[2])
                    }
                    else if question[5] == "Weapon" {
                        tabbar.playerCardData[question[1]]?.cardsHave.insert(question[3])
                        tabbar.playerCardData[otherPlayer]?.cardsNull.insert(question[3])
                    }
                    else if question[5] == "Room" {
                        tabbar.playerCardData[question[1]]?.cardsHave.insert(question[4])
                        tabbar.playerCardData[otherPlayer]?.cardsNull.insert(question[4])
                    }
                }
                else {
                    if question[5] == "No" {
                        for card in questionCardSet {
                            tabbar.playerCardData[question[1]]?.cardsNull.insert(card)
                        }
                        if question[6] == "No" {
                            tabbar.playerCardData[question[0]]?.cardsMust.insert(questionCardSet)
                        }
                        if question[6] == "Yes" {
                            print("you got one, keep it a secret though")
                        }
                    }
                    else {
                        if question[1] == "Zack" {
                            print("you showed somebody something, make sure the other person doesn't know")
                        }
                        else {
                            tabbar.playerCardData[otherPlayer]?.cardsMust.insert(questionCardSet)
                        }
                    }
                }
            }
            reevaluteMurderCards()
            var mustCards_evalloop_count = 15
            while (mustCards_evalloop_count > 0) {
                for player in tabbar.playerList{
                    for mustSet in (tabbar.playerCardData[player]?.cardsMust)! {
                        for nullCard in (tabbar.playerCardData[player]?.cardsNull)! {
                            if mustSet.contains(nullCard) {
                                var newMustSet = mustSet
                                newMustSet.remove(nullCard)
                                tabbar.playerCardData[player]?.cardsMust.remove(mustSet)
                                tabbar.playerCardData[player]?.cardsMust.insert(newMustSet)
                            }
                        }
                        for haveCard in (tabbar.playerCardData[player]?.cardsHave)! {
                            if mustSet.contains(haveCard) {
                                tabbar.playerCardData[player]?.cardsMust.remove(mustSet)
                            }
                        }
                        for knownCard in murderCards {
                            if mustSet.contains(knownCard) {
                                var newMustSet = mustSet
                                newMustSet.remove(knownCard)
                                tabbar.playerCardData[player]?.cardsMust.remove(mustSet)
                                tabbar.playerCardData[player]?.cardsMust.insert(newMustSet)
                            }
                        }
                        if mustSet.count == 1 {
                            for lastCard in mustSet {
                                tabbar.playerCardData[player]?.cardsHave.insert(lastCard)
                            }
                            tabbar.playerCardData[player]?.cardsMust.remove(mustSet)
                        }
                    }
                }
                reevaluteMurderCards()
                mustCards_evalloop_count -= 1
            }
        }
    }
    
    func adjustCellColorList () {
        let tabbar = tabBarController as! baseViewController
        let colorList: [UIColor] = [UIColor(red: 126/256, green: 222/256, blue: 87/256, alpha: 1), UIColor(red: 244/256, green: 82/256, blue: 80/256, alpha: 1), UIColor(red: 248/256, green: 208/256, blue: 60/256, alpha: 1)]
        for number in 0..<21 {
            for player in tabbar.playerList {
                if (tabbar.playerCardData[player]?.cardsHave.contains((constants.allCardsList)[number]))! {
                    cellColorList[4 * (number + 1) + 1 + tabbar.playerList.index(of: player)!] = colorList[0]
                }
                if (tabbar.playerCardData[player]?.cardsNull.contains((constants.allCardsList)[number]))! {
                    cellColorList[4 * (number + 1) + 1 + tabbar.playerList.index(of: player)!] = colorList[1]
                }
                for set in (tabbar.playerCardData[player]?.cardsMust)! {
                    if set.contains((constants.allCardsList)[number]) {
                        cellColorList[4 * (number + 1) + 1 + tabbar.playerList.index(of: player)!] = colorList[2]
                    }
                }
            }
        }
        for number in 0..<88 {
            if number % 4 == 0 {
                cellColorList[number] = UIColor.white
            }
            if number < 4 {
                cellColorList[number] = UIColor.white
            }
        }
        for card in murderCards {
            for number in 1..<4 {
                cellColorList[number + (4 * (1 + constants.allCardsList.index(of: card)!))] = UIColor.blue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        evaluateQuestionList()
        for number in 0..<numberOfCells {
            cellColorList[number] = UIColor(red: 200/256, green: 200/256, blue: 200/256, alpha: 1)
        }
        adjustCellColorList()
        self.dataCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 89
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        
        if indexPath.item >= 88 {
            cell.myLabel.text = ""
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 0
        }
        else {
            if indexPath.item % 4 == 0 {
                if indexPath.item >= 4 {
                    cell.myLabel.text = constants.allCardsList[(indexPath.item / 4) - 1]
                    cell.layer.borderWidth = 1
                    cell.layer.borderColor = UIColor.black.cgColor
                }
            }
            else {
                cell.myLabel.text = ""
                cell.layer.borderWidth = 0
            }
            for number in 0..<numberOfCells {
                if indexPath.item == number {
                    cell.backgroundColor = cellColorList[number]
                }
            }
            let tabbar = tabBarController as! baseViewController
            if tabbar.playerList.count == 3 {
                if indexPath.item < 4 && indexPath.item > 0 {
                    let someString: String = tabbar.playerList[indexPath.item - 1]
                    cell.myLabel.text = String(someString.prefix(1))
                }
            }
            else {
                //something
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 4 == 0 {
            return CGSize(width: firstColumnWidth, height: standardCellHeight)
        }
        else {
            return CGSize(width: standardColumnWidth, height: standardCellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidthPadding:CGFloat = (collectionView.frame.size.width - firstColumnWidth - (numberOfColumn * standardColumnWidth)) / 5
        let cellHeightPadding:CGFloat = 10
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }
}
