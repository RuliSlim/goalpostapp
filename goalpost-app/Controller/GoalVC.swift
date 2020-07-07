//
//  ViewController.swift
//  goalpost-app
//
//  Created by Ruli on 03/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalVC: UIViewController {
    @IBOutlet weak var welcomeMessage: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData { (completed) in
            if completed {
                if goals.count > 0 {
                    tableView.isHidden = false
                    welcomeMessage.isHidden = true
                } else {
                    tableView.isHidden = true
                    welcomeMessage.isHidden = false
                }
            }
        }
        tableView.reloadData()
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
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
}

extension GoalVC {
    func fetchData(completion: (_ complete: Bool) -> Void) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try manageContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}
