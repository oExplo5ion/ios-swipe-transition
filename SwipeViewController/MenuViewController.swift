//
//  MenuViewController.swift
//  SwipeViewController
//
//  Created by Aleksey on 11.03.2022.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private funcs
    @objc
    private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
