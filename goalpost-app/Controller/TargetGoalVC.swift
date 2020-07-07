//
//  TargetGoalVC.swift
//  goalpost-app
//
//  Created by Ruli on 06/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit
import CoreData

class TargetGoalVC: UIViewController {
    @IBOutlet weak var targetGoal: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var goalType: GoalType!
    var goalDesc: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetGoal.inputAccessoryView = submitButton
        targetGoal.keyboardType = .numberPad
        targetGoal.addTarget(self, action: #selector(inputTarget), for: .editingChanged)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func submitGoal(_ sender: UIButton) {
        guard let targetGoal = targetGoal.text, targetGoal != "0", targetGoal != "" else { return }
        if Int(targetGoal) != nil {
            save { (completed) in
                if completed {
                    goBack()
                } else {
                    print("GAGAL SAVE")
                }
            }
        }
        
    }
    
    @objc internal func inputTarget(_ sender: UITextField) {
        submitButton.isHidden = false
    }
    
    func setGoal(goalDesc: String, goalType: GoalType) {
        self.goalType = goalType
        self.goalDesc = goalDesc
    }
    
    func save(completion: (_ finished: Bool) -> Void) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        goal.goalDescription = goalDesc
        goal.goalProgress = Int32(0)
        goal.goalType = goalType.rawValue
        goal.goalTarget = Int32(targetGoal.text!)!
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }

}
