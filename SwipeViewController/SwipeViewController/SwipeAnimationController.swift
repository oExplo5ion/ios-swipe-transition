//
//  SwipeAnimationController.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation
import UIKit

fileprivate enum Defaults {
    static let transitionDuration = TimeInterval(0)
}

enum SwipeAnimationControllerType {
    case present
    case dissmis
}

class SwipeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Proporties
    let interactionController: EdgeInteractionController
    let type: SwipeAnimationControllerType
    
    // MARK: - Lifecycle
    init(interactionController: EdgeInteractionController, type: SwipeAnimationControllerType) {
        self.interactionController = interactionController
        self.type = type
        super.init()
    }
    
    // MARK: - Delegate
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Defaults.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        switch type {
        case .present:
            animatePresent(
                transitionContext: transitionContext,
                fromVC: fromVC,
                toVC: toVC
            )
        case .dissmis:
            animatedDissmis(
                transitionContext: transitionContext,
                fromVC: fromVC,
                toVC: toVC
            )
        }
    }
    
    // MARK: - Private funcs
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else { return }
        let containerView = transitionContext.containerView
        
        toVC.view.frame = containerView.frame
        containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        
        let correctFrame = CGRect(
            x: -snapshot.bounds.size.width,
            y: containerView.bounds.origin.y,
            width: containerView.bounds.size.width,
            height: containerView.bounds.size.height
        )
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .preferredFramesPerSecond60) {
                fromVC.view.frame = correctFrame
            } completion: { _ in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
    }
    
    private func animatedDissmis(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else { return }
        let containerView = transitionContext.containerView
        
        snapshot.frame = containerView.frame
        toVC.view.frame = CGRect(
            x: -containerView.bounds.size.width,
            y: containerView.bounds.origin.y,
            width: containerView.bounds.size.width,
            height: containerView.bounds.size.height
        )
        
        containerView.addSubview(snapshot)
        containerView.addSubview(toVC.view)
        
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        
        let correctFrame = CGRect(
            x: (toVC.view.center.x / 2) + interactionController.translation.x,
            y: containerView.bounds.origin.y,
            width: containerView.bounds.size.width,
            height: containerView.bounds.size.height
        )
        
        UIView.animate(
            withDuration: Defaults.transitionDuration,
            delay: 0,
            options: .allowUserInteraction) {
                toVC.view.frame = correctFrame
            } completion: { _ in
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                  toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
    }
    
}
