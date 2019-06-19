//
//  NavigationController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 17/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push,
            let animationControllerLoadable = toVC as? UIViewControllerAnimationControllerLoadable,
            let animationController = animationControllerLoadable.presentingAnimationController {
            return animationController
        } else if operation == .pop,
            let animationControllerLoadable = fromVC as? UIViewControllerAnimationControllerLoadable,
            let animationController = animationControllerLoadable.dismissingAnimationController {
            return animationController
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactionControllerLoadable = animationController as? UIViewControllerIntractionControllerLoadable {
            return interactionControllerLoadable.interactionController
        }
        
        return nil
    }
}

protocol UIViewControllerAnimationControllerLoadable {
    var presentingAnimationController: UIViewControllerAnimatedTransitioning? { get }
    var dismissingAnimationController: UIViewControllerAnimatedTransitioning? { get }
}

protocol UIViewControllerIntractionControllerLoadable {
    var interactionController: UIViewControllerInteractiveTransitioning? { get }
}
