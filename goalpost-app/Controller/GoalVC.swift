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
    @IBOutlet weak var undoMessage: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    var goals: [Goal] = []
    var deletedGoal: Goal!
    var setTime: Int = 5
    var timer: Timer?
    
    var tempDesc: String!
    var tempTarget: Int32!
    var tempProgress: Int32!
    var tempType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromCoreData()
        tableView.reloadData()
    }
    
    @IBAction func createGoal(_ sender: UIButton) {
        welcomeMessage.isHidden = true
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentNext(createGoalVC)
    }
    
    @IBAction func undoGoalButton(_ sender: UIButton) {
        undoGoal { (completed) in
            if completed {
                setTime = -10
                undoMessage.isHidden = true
                fetchFromCoreData()
                tableView.reloadData()
            } else {
                print("aneh kenapa gagal siih?")
            }
        }
    }
    
    private func setUpTable() {
        let nib = UINib(nibName: "GoalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "goalCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchFromCoreData() {
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
    }
    
    @objc func countdown() {
        if setTime >= 0 {
            undoMessage.isHidden = false
            countLabel.text = String(setTime)
            setTime -= 1
        } else {
            undoMessage.isHidden = true
            timer?.invalidate()
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (deleteAction, view, complete) in
            
            // Why this is give me nil value?
            self.deletedGoal = self.goals[indexPath.row]
            self.tempDesc = self.goals[indexPath.row].goalDescription!
            self.tempType = self.goals[indexPath.row].goalType!
            self.tempTarget = self.goals[indexPath.row].goalTarget
            self.tempProgress = self.goals[indexPath.row].goalProgress
            
            self.removeGoal(atIndexPath: indexPath)
            self.fetchFromCoreData()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.timer?.invalidate()
            self.setTime = 5
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
            complete(true)
        }
        
        
        let updateAction = UIContextualAction(style: .normal, title: "UPDATE PROGRESS") { (updateAction, view, complete) in
            self.updateGoal(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        updateAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        return swipeActions
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
    
    func removeGoal(atIndexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        manageContext.delete(goals[atIndexPath.row])
        do {
            try manageContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func updateGoal(atIndexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let updatedGoal = goals[atIndexPath.row]
        
        if updatedGoal.goalProgress < updatedGoal.goalTarget {
            updatedGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try manageContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func undoGoal(completion: (_ complete: Bool) -> Void) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: manageContext)
        
        // This will give me value nill
        /*
        if let deletedGoal = deletedGoal {
            goal.goalType = deletedGoal.goalType
            goal.goalProgress = deletedGoal.goalProgress
            goal.goalDescription = deletedGoal.goalDescription
            goal.goalTarget = deletedGoal.goalTarget
        }
        */
        goal.goalProgress = tempProgress
        goal.goalDescription =  tempDesc
        goal.goalTarget = tempTarget
        goal.goalType = tempType
        
        do {
            manageContext.insert(goal)
            try manageContext.save()
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}
