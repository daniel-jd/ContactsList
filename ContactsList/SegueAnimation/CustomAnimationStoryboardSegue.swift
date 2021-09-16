//
//  CustomAnimationStoryboardSegue.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 16.09.2021.
//

import UIKit

class CustomAnimationStoryboardSegue: UIStoryboardSegue {

    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
    }
}

extension CustomAnimationStoryboardSegue: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Present!!!")
        return CustomPresenterAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("Dismiss!!!")
        return CustomDismissAnimator()
    }
}
