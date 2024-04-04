//
//  RMSearchViewController.swift
//  RickMorty
//
//  Created by Amine CHATATE on 27/1/2024.
//

import UIKit

class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var endpoint: RMEndpoint {
                switch self {
                    case .character: return .character
                    case .episode: return .episode
                    case .location: return .location
                }
            }
            
            var searchresultInputType: Any.Type {
                switch self {
                    case .character: return RMGetAllCharactersResponse.self
                    case .episode: return RMGetAllEpisodesResponse.self
                    case .location: return RMGetAllLocationsResponse.self
                }
            }
            
            var title: String {
                switch self {
                
                case .character:
                    return "Search Character"
                case .episode:
                    return "Search Episode"
                case .location:
                    return "Search Location"
                }
            }
        }
        let type: `Type`
    }
    
    private let viewModel: RMSearchViewViewModel
    private let searchView: RMSearchView
    
    init(config: Config) {
        self.viewModel = RMSearchViewViewModel(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        view.addSubviews(searchView)
        addConstraint()
        searchView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "search", style: .done, target: self, action: #selector(didTapExecuteSearch))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    private func addConstraint(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }

    @objc
    private func didTapExecuteSearch(){
        viewModel.executeSearch()
    }
}


extension RMSearchViewController: RMSearchViewDelegate {
      
    func rmSearchView(_ inputView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        let vc = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
    
    func rmSearchView(_ searchResultView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
