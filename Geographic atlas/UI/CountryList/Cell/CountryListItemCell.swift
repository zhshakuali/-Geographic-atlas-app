//
//  CountryListItemCell.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 13.05.2023.
//

import UIKit
import Kingfisher

final class CountryListItemCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        "\(Self.self)"
    }
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private var expandableVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var headerLabelView: HeaderLabelView = {
        let headerLabelView = HeaderLabelView()
        headerLabelView.translatesAutoresizingMaskIntoConstraints = false
        return headerLabelView
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(expandAction), for: .touchUpInside)
        return button
    }()
    
    private var populationTextLabelView: TextLabelView = {
        let textLabelView = TextLabelView()
        textLabelView.translatesAutoresizingMaskIntoConstraints = false
        return textLabelView
    }()
    
    private var areaTextLabelView: TextLabelView = {
        let textLabelView = TextLabelView()
        textLabelView.translatesAutoresizingMaskIntoConstraints = false
        return textLabelView
    }()
    
    private var currenciesTextLabelView: TextLabelView = {
        let textLabelView = TextLabelView()
        textLabelView.translatesAutoresizingMaskIntoConstraints = false
        return textLabelView
    }()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(.Foreground.accentColor, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(learnMoreAction), for: .touchUpInside)
        return button
    }()
    
    private var downloadTask: DownloadTask?
    private var item: CountryItemModel?
    var learnMoreCompletion: ( () -> Void )?
    var expandCompletion: ( () -> Void )?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
        countryImage.layer.cornerRadius = 12
    }
    
    private func prepareLayout() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .Foreground.contentViewColor
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        
        containerView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        [hStack, expandableVStack].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [countryImage, headerLabelView, expandButton].forEach {
            hStack.addArrangedSubview($0)
        }
        
        [populationTextLabelView, areaTextLabelView, currenciesTextLabelView, learnMoreButton].forEach {
            expandableVStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            countryImage.heightAnchor.constraint(equalToConstant: 48),
            countryImage.widthAnchor.constraint(equalToConstant: 82),
            expandButton.heightAnchor.constraint(equalToConstant: 16),
            expandButton.widthAnchor.constraint(equalToConstant: 16),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func set(item: CountryItemModel) {
        self.item = item
        headerLabelView.set(title: item.country, subtitle: item.capital)
        populationTextLabelView.set(label: "Population:", and: [item.population])
        areaTextLabelView.set(label: "Area:", and: [item.area])
        currenciesTextLabelView.set(label: "Currencies:", and: item.currencies)
        
        let image = item.isExpanded
        ? UIImage(systemName: "chevron.up")
        : UIImage(systemName: "chevron.down")
        expandButton.setImage(image, for: .normal)
        self.expandableVStack.isHidden = !item.isExpanded
        
        countryImage.kf.setImage(with: URL(string: item.flagImageURL))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryImage.image = nil
        countryImage.kf.cancelDownloadTask()
    }
    
    @objc private func expandAction() {
        guard let item else {
            return
        }
        
        item.isExpanded.toggle()
        self.expandCompletion?()
    }
    
    @objc private func learnMoreAction() {
        learnMoreCompletion?()
    }
    
}
