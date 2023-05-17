//
//  LabelView.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import UIKit

final class TextLabelView: UIView {
    
    private var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .top
        return stackView
    }()

    private var labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textColor = .Foreground.secondary
        return label
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textColor = .Foreground.primary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareLayout() {
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [labelView, textLabel].forEach { hStack.addArrangedSubview($0) }
    }
    
    func set(label: String, and texts: [String]) {
        if texts.isEmpty {
            textLabel.isHidden = true
            labelView.isHidden = true
        } else {
            labelView.isHidden = false
            textLabel.isHidden = false
            textLabel.text = texts.joined(separator: ", ")
            labelView.text = label
        }
    }
}
