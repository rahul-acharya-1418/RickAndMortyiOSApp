//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import UIKit

/// Controller to show and search for location
final class RMLocationViewController: UIViewController {
    
    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    /// you can use below method as well to assign primary view
//    override func loadView() {
//        view = RMLocationView()
//    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstrains()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate(([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor ),
        ]))
    }
    
    @objc
    private func didTapSearch() {
        
    }
}
