//
//  RMSearchResultsView.swift
//  RickMorty
//
//  Created by Amine CHATATE on 30/3/2024.
//

import UIKit

final class RMNoSearchResultsView: UIView {

    private let viewModel = RMNoSearchResultsViewViewModel()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .red
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(iconImage, label)
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 90),
            iconImage.heightAnchor.constraint(equalToConstant: 90),
            iconImage.topAnchor.constraint(equalTo: topAnchor),
            iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            label.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 10),
        ])
    }
    
    private func configure(){
        self.label.text = viewModel.title
        self.iconImage.image = viewModel.image
    }
    
}
