//
//  SwipeInteractionController.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation
import UIKit

enum EdgeInteractionControllerEvent {
    case transitionStarted
}

class EdgeInteractionController: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Custom types
    enum Defaults {
        /**
            Determines how much width of the screen in percents should be passed by upcoming screen for transition to be considered as completed
         */
        static var completePercent: CGFloat {
            get {
                return 0.4
            }
        }
        /**
            Determines how much width of the screen in points should be passed by upcoming screen for transition to be considered as completed
         */
        static var completePoints: CGFloat {
            get {
                UIScreen.main.bounds.size.width * completePercent
            }
        }
    }
    
    // MARK: - Closures
    
    var onEvent: ((EdgeInteractionControllerEvent) -> Void)?
    
    // MARK: - Proporties
    /**
        Determines is edge transition should be available
     */
    var isSwipeEnabled = true {
        didSet {
            prepareGestureRecognizer()
        }
    }
    
    /**
     Transition's progress
     */
    private(set) var progress: CGFloat = 0
    
    /**
     Translation for interactive view
     */
    private(set) var translation: CGPoint = .zero
    
    /**
     Returns is transition currently is being in progress
     */
    private(set) var isInteractionInProgress = false
    
    /**
     If `true` transition should be considered as complited
     */
    private var shouldCompleteTransition = false
    
    /**
     `UIViewController` wich initiates transition
     */
    private let rootViewController: UIViewController
    
    /**
     Edge that should receive user interaction
     */
    private let edge: UIRectEdge
    
    private lazy var edgeGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture =  UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreen(gesture:)))
        gesture.edges = edge
        return gesture
    }()
    
    init(viewController: UIViewController, edge: UIRectEdge = .left) {
        self.rootViewController = viewController
        self.edge = edge
        super.init()
        self.prepareGestureRecognizer()
    }
    
    // MARK: - Private funcs
    private func prepareGestureRecognizer() {
        switch isSwipeEnabled {
        case true:
            if let gstrs = rootViewController.view.gestureRecognizers {
                guard !gstrs.contains(edgeGesture) else {
                    return
                }
            }
            rootViewController.view.addGestureRecognizer(edgeGesture)
        case false:
            rootViewController.view.removeGestureRecognizer(edgeGesture)
        }
    }
    
    @objc
    private func handleScreen(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let superView = gesture.view?.superview else { return }
        let translation = gesture.translation(in: superView)
        var progress = (translation.x / Defaults.completePoints)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        self.progress = progress
        self.translation = translation
        
        switch gesture.state {
        case .possible:
            return
        case .began:
            isInteractionInProgress = true
            rootViewController.dismiss(animated: true, completion: nil)
            onEvent?(.transitionStarted)
            Logger.log(message: "began")
        case .changed:
            shouldCompleteTransition = progress >= 0.4
            update(progress)
            Logger.log(message: "changed: progress: \(progress) translation: \(translation)")
        case .ended:
            isInteractionInProgress = false
            self.progress = 0
            self.translation = .zero
            shouldCompleteTransition ? finish() : cancel()
            Logger.log(message: "ended")
        case .cancelled:
            isInteractionInProgress = false
            self.progress = 0
            self.translation = .zero
            if let gv = gesture.view {
                gesture.setTranslation(.zero, in: gv)
            }
            cancel()
        case .failed:
            isInteractionInProgress = false
            self.progress = 0
            self.translation = .zero
            if let gv = gesture.view {
                gesture.setTranslation(.zero, in: gv)
            }
            cancel()
        @unknown default:
            return
        }
    }
    
}
