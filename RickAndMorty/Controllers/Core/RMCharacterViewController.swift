//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 27/07/26.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            pathComponent: ["1"],
            queryParameters: [
                URLQueryItem(name: "email", value: "test@test.com"),
                URLQueryItem(name: "password", value: "12345")
            ]
        )
        
    }
}
