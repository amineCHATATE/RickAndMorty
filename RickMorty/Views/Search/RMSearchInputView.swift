//
//  RMSearchInputView.swift
//  RickMorty
//
//  Created by Amine CHATATE on 30/3/2024.
//

import UIKit
import SwiftUI
import StoreKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

final class RMSearchInputView: UIView {

    weak var delegte: RMSearchInputViewDelegate?
    private var stackView: UIStackView?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraint()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    public func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.seachPlaceHolderText
        self.viewModel = viewModel
    }
    
    private func createOptionSelectionView(options: [RMSearchInputViewViewModel.DynamicOptions]){
        let stackView = setStackView()
        
        for index in 0..<options.count {
            let option = options[index]
            makeOptionButon(index: index, option: option, stackView: stackView)
        }
    }
    
    private func setStackView() -> UIStackView {
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        return stackView
    }
    
    private func makeOptionButon(index: Int, option: RMSearchInputViewViewModel.DynamicOptions, stackView: UIStackView){
        let button = UIButton()
        button.backgroundColor = .secondarySystemFill
        
        let attributeString = NSAttributedString(string: option.rawValue, attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        button.setAttributedTitle(attributeString, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = index
        button.layer.cornerRadius = 6
        stackView.addArrangedSubview(button)
    }
    
    @objc
    private func didTapButton(_ sender: UIButton){
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selectedOption = options[tag]
        delegte?.rmSearchInputView(self, didSelectOption: selectedOption)
    }
    
    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOptions, value: String){
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
        let allOptions = viewModel?.options,
        let index = allOptions.firstIndex(of: option)
        else { return }
        
        let button: UIButton = buttons[index]
        let attributeString = NSAttributedString(string: value.uppercased(), attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.link
        ])
        
        button.setAttributedTitle(attributeString, for: .normal)
    }
    
}

extension RMSearchInputView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegte?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegte?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
}
