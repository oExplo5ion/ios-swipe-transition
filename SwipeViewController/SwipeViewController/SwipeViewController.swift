//
//  SwipeViewController.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation
import UIKit

fileprivate enum Defaults {
    /**
        Determines how much width of the screen in percents should be passed by upcoming screen for transition to be considered as completed
     */
    static var completePercent: CGFloat {
        get {
            UIScreen.main.bounds.size.width * 0.4
        }
    }
}

class SwipeViewController: UIViewController {
    
    // MARK: - Proporties
    var interactor: EdgeInteractionController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    // MARK: - Private funcs
    open func presentMenu() {}
    
    private func prepare() {
        interactor = EdgeInteractionController(viewController: self)
        interactor?.onEvent = { event in
            switch event {
            case .transitionStarted:
                self.presentMenu()
            }
        }
    }
}

extension SwipeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return SwipeAnimationController(interactionController: interactor, type: .dissmis)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let interactor = self.interactor else { return nil }
        return SwipeAnimationController(interactionController: interactor, type: .present)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let anim = animator as? SwipeAnimationController else { return nil }
        guard anim.interactionController.isInteractionInProgress else { return nil }
        return anim.interactionController
    }
    
}
