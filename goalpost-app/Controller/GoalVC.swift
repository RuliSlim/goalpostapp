//
//  ViewController.swift
//  goalpost-app
//
//  Created by Ruli on 03/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit

class GoalVC: UIViewController {
    @IBOutlet weak var welcomeMessage: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [String] = ["satu", "dua", "tiga","satu", "dua", "tiga","satu", "dua", "tiga","satu", "dua", "tiga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTable()
    }

    @IBAction func createGoal(_ sender: UIButton) {
        welcomeMessage.isHidden = true
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentNext(createGoalVC)
    }
    
    private func setUpTable() {
        let nib = UINib(nibName: "GoalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "goalCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension GoalVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else {
            return GoalCell()
        }
        
        cell.configureCell(goalDescription: "Ini nati bakal jadi deskripsi", goalType: .longTerm, goalTarget: 3, goalProgress: 1)
        return cell
    }
}
