//
//  ViewControll.swift
//  goalpost-app
//
//  Created by Ruli on 04/07/20.
//  Copyright © 2020 Ruli. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentNext(_ viewControllerTarget: UIViewController) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromBottom
        transition.duration = 0.5
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerTarget, animated: false, completion: nil)
    }
    
    func goBack() {
        let transition = CATransition()
        transition.type = .fade
        transition.subtype = .fromTop
        transition.duration = 0.5
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
