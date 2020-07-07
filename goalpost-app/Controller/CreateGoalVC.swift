//
//  CreateGoalVC.swift
//  goalpost-app
//
//  Created by Ruli on 04/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var inputGoal: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shortTerm: UIButton!
    @IBOutlet weak var longTerm: UIButton!
    @IBOutlet weak var typeButtons: UIStackView!
    @IBOutlet weak var container: UIView!
    
    private(set) public var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputGoal.delegate = self
        /* this simple method for attach button to keyboard. but it will diasppear when theres no keyboard
        // inputGoal.inputAccessoryView = nextButton
        */
        nextButton.bindToKeyboard()
        
        // simple method choose beetween 2 buttons
        shortTerm.addTarget(self, action: #selector(choosedType(_:)), for: .touchUpInside)
        longTerm.addTarget(self, action: #selector(choosedType(_:)), for: .touchUpInside)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func toTargetGoal(_ sender: UIButton) {
        guard let goalDesc = inputGoal.text, goalDesc != "What's your goal?" else { return }
        guard let goalType = self.goalType else { return }
        guard let targetGoalVC = storyboard?.instantiateViewController(withIdentifier: "TargetGoalVC") as? TargetGoalVC else { return }
        
        targetGoalVC.setGoal(goalDesc: goalDesc, goalType: goalType)
        presentingViewController?.presentSecondary(targetGoalVC)
    }
    
    @objc private func keyboardWillShow(_ sender: Any) {
        nextButton.bindToKeyboard()
    }
    
    @objc private func choosedType(_ sender: UIButton) {
        let tempColor = sender.backgroundColor
        sender.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        switch sender {
        case shortTerm:
            longTerm.backgroundColor = tempColor
            longTerm.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            goalType = .shortTerm
        default:
            shortTerm.backgroundColor = tempColor
            shortTerm.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            goalType = .longTerm
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
