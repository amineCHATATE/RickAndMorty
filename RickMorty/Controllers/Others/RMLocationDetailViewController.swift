//
//  RMLocationDetalViewController.swift
//  RickMorty
//
//  Created by Amine CHATATE on 17/3/2024.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {

    private let viewModel: RMLocationDetailViewViewModel
    private let detailView = RMLocationDetailView()
    
    init(location: RMLocation){
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Location"
        
        view.addSubview(detailView)
        setConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapSearch))
        
        detailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func setConstraints(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapSearch(){
        
    }
}


extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    
    func didFetchEpisodesDetails() {
        detailView.configure(with: viewModel)
    }
    
}


extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
