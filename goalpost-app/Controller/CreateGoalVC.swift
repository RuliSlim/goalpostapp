//
//  CreateGoalVC.swift
//  goalpost-app
//
//  Created by Ruli on 04/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {
    @IBOutlet weak var inputGoal: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shortTerm: UIButton!
    @IBOutlet weak var longTerm: UIButton!
    @IBOutlet weak var typeButtons: UIStackView!
    
    private(set) public var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this simple method for attach button to keyboard. but it will diasppear when theres no keyboard
        // inputGoal.inputAccessoryView = nextButton
        view.bindToKeyboard()
        nextButton.bindToKeyboard()
        typeButtons.bindToKeyboard()
        
        // simple method choose beetween 2 buttons
        shortTerm.addTarget(self, action: #selector(choosedType(_:)), for: .touchDown)
        longTerm.addTarget(self, action: #selector(choosedType(_:)), for: .touchDown)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        //        goBack()
        
        // just for testing keyboard
        inputGoal.resignFirstResponder()
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
        default:
            shortTerm.backgroundColor = tempColor
            shortTerm.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
    }
}
