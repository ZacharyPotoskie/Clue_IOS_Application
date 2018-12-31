//
//  SecondViewController.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 8/28/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

struct Question {
    var title: String!
    var asker: String!
    var responder: String!
    var suspect: String!
    var weapon: String!
    var room: String!
    var response_primary: String!
    var response_secondary: String!
}

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var questionAddButtonState = Bool()
    @IBOutlet weak var tableView: UITableView!

    var questions: [Question] = []
        
    var t_count: Int = 0
    var lastCell: StackViewCell = StackViewCell()
    var button_tag = -1
    
    func refresh() {
        print("refreshed")
        tableView.reloadData()
    }
    
    //function that runs when app is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allow access to global variables
        let tabbar = tabBarController as! baseViewController
        
        //create and configure the left side nav control button
        let deleteQuestionButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteQuestionButtonTapped))
        self.navigationItem.leftBarButtonItem = deleteQuestionButton
        deleteQuestionButton.isEnabled = false
        
        //create and configure the right side nav control button
        let addQuestionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addQuestionButtonTapped))
        self.navigationItem.rightBarButtonItem = addQuestionButton
        addQuestionButton.isEnabled = tabbar.questionAddButtonState
        
        //make the unfilled cells look like a single cell
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        
        var questionPosition:Int = tabbar.questionList.count
        for question in tabbar.questionList {
            questions.append(Question(title: "Question \(questionPosition)", asker: question[0], responder: question[1], suspect: question[2], weapon: question[3], room: question[4], response_primary: question[5], response_secondary: question[6]))
            questionPosition -= 1
        }
        
        tableView.register(UINib(nibName: "StackViewCell", bundle: nil), forCellReuseIdentifier: "StackViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView.backgroundColor = UIColor.white
    }
    
    //function that runs when second tab is displayed
    override func viewWillAppear(_ animated: Bool) {
        let tabbar = tabBarController as! baseViewController
        let addQuestionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addQuestionButtonTapped))
        self.navigationItem.rightBarButtonItem = addQuestionButton
        addQuestionButton.isEnabled = tabbar.questionAddButtonState
    }
    
    @objc func addQuestionButtonTapped() {
        performSegue(withIdentifier: "addQuestionSegue", sender: self)
    }
    
    @objc func deleteQuestionButtonTapped(){
        print("hello")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == button_tag {
            return 246
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        if !cell.cellExists {
            cell.headerButton.setTitle(questions[indexPath.row].title!, for: .normal)
            cell.asker.text = "Asker: \(questions[indexPath.row].asker!)"
            cell.responder.text = "Responder: \(questions[indexPath.row].responder!)"
            cell.suspect.text = "Suspect: \(questions[indexPath.row].suspect!)"
            cell.weapon.text = "Weapon: \(questions[indexPath.row].weapon!)"
            cell.room.text = "Room: \(questions[indexPath.row].room!)"
            cell.primaryResponse.text = "Primary Response: \(questions[indexPath.row].response_primary!)"
            cell.secondaryResponse.text = "Secondary Response: \(questions[indexPath.row].response_secondary!)"
            cell.headerView.backgroundColor = UIColor.white
            cell.stuffView.backgroundColor = UIColor.white
            cell.headerButton.tag = t_count
            cell.headerButton.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
            t_count += 1
            cell.cellExists = true
        }
        
        UIView.animate(withDuration: 0) {
            cell.stuffView.layoutIfNeeded()
        }
        
        return cell
    }
    
    @objc func cellOpened(sender: UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = StackViewCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        }
        
        self.tableView.endUpdates()
    }
    
}







