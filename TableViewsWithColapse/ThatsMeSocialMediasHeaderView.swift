//
//  ThatsMeSocialMediasHeaderView.swift
//  TableViewsWithColapse
//
//  Created by Chrystian Salgado on 27/04/23.
//

import UIKit

final class ThatsMeSocialMediasHeaderView: YCodedView {
    
    private lazy var colapseButton: UIButton = {
        let someView = UIButton()
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        return someView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()
    
    var didTap: ((_ id: Int)-> Void)?
    
    private let id: Int
    
    init(id: Int, title: String, image: UIImage) {
        self.id = id
        super.init(frame: .zero)
        label.text = title
        imageView.image = image
    }
    
    override func addSubviews() {
        addSubview(colapseButton)
        addSubview(label)
        addSubview(imageView)
    }
    
    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            colapseButton.topAnchor.constraint(equalTo: topAnchor),
            colapseButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            colapseButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            colapseButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func didTapOnButton() {
        didTap?(id)
    }
}
