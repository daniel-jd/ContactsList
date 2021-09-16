//
//  CustomDismissAnimator.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 16.09.2021.
//

import UIKit

class CustomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let toVCFrame = transitionContext.finalFrame(for: toViewController)
        let fromVCFrame = transitionContext.initialFrame(for: fromViewController)

        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds

        toViewController.view.frame = toVCFrame.offsetBy(dx: 0, dy: -bounds.size.height)

        containerView.addSubview(toViewController.view)
//        fromViewController.modalPresentationStyle = .fullScreen

        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.transitionCurlDown],
        animations: {
            fromViewController.view.frame = fromVCFrame.offsetBy(dx: 0, dy: bounds.size.height)
            toViewController.view.frame = toVCFrame
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })



    }


}
