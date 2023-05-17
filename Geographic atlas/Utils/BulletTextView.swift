//
//  BulletTextView.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import UIKit

final class BulletTextView: UIView {

    private var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }()
    
    private var bulletImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        // TODO: Make correct inset
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = .Foreground.secondary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, and subtitles: [String]) {
        titleLabel.text = title
        
        subtitles.forEach { subtitle in
            let label = createSubtitleLabel(with: subtitle)
            vStack.addArrangedSubview(label)
        }
    }
}

private extension BulletTextView {
    func prepareLayout() {
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [bulletImageView, vStack].forEach { hStack.addArrangedSubview($0) }
        
        vStack.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            bulletImageView.heightAnchor.constraint(equalToConstant: 10),
            bulletImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func createSubtitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        label.font = .systemFont(ofSize: 20)
        return label
    }
}
