//
//  RMCharacterViewController.swift
//  RickMorty
//
//  Created by Amine CHATATE on 10/12/2023.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    private let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        view.addSubview(characterListView)
        setConstraints()
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
