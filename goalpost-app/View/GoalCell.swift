//
//  GoalCell.swift
//  goalpost-app
//
//  Created by Ruli on 03/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit

@IBDesignable
class GoalCell: UITableViewCell {
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(goalDescription: String, goalType: GoalType, goalTarget: Int32, goalProgress: Int32) {
        self.goalDescription.text = goalDescription
        self.goalType.text = goalType.rawValue
        self.goalProgress.text = String(goalProgress)
    }
}
