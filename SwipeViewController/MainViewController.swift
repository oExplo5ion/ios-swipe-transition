//
//  MainViewController.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation
import UIKit

class MainViewController: SwipeViewController {
    
    // MARK: - UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "<- Drag from left"
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override funcs
    override func presentMenu() {
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
