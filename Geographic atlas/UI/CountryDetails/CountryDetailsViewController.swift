//
//  CountryDetailsViewController.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 12.05.2023.
//

import UIKit
import Kingfisher

final class CountryDetailsViewController: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alpha = 0
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var mainStackVIew: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    
    private var bulletsStackVIew: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 24
        stackView.alignment = .leading
        return stackView
    }()
    
    private var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var regionBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var capitalBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var capitalCoordinatesBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var populationBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var areaBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var currencyBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private var timezonesBulletView: BulletTextView = {
        let bulletTextView = BulletTextView()
        bulletTextView.translatesAutoresizingMaskIntoConstraints = false
        return bulletTextView
    }()
    
    private let viewModel: CountryDetailsViewModelProtocol
    
    init(viewModel: CountryDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        setupSubscription()
        fetchDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = 12
    }
    
    private func prepareLayout() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        contentView.addSubview(mainStackVIew)

        NSLayoutConstraint.activate([
            mainStackVIew.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainStackVIew.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackVIew.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackVIew.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        mainStackVIew.addArrangedSubview(imageView)
        mainStackVIew.addArrangedSubview(bulletsStackVIew)
        [regionBulletView, capitalBulletView, capitalCoordinatesBulletView, populationBulletView, areaBulletView, currencyBulletView, timezonesBulletView].forEach{ bulletsStackVIew.addArrangedSubview($0) }
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchDetails() {
        activityIndicator.startAnimating()
        viewModel.fetchDetails()
    }
    
    private func setupSubscription() {
        viewModel.countryFetched = { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case let .success(countryDetails):
                self?.title = countryDetails.name
                self?.imageView.kf.setImage(with: URL(string: countryDetails.flag))
                
                if let region = countryDetails.region {
                    self?.regionBulletView.set(title: C.regionTitle, and: [region])
                    self?.regionBulletView.isHidden = false
                } else {
                    self?.regionBulletView.isHidden = true
                }
                
                if let coordinates = countryDetails.capitalCoordinates {
                    self?.capitalCoordinatesBulletView.set(title: C.capitalCooridatesTitle, and: [coordinates])
                    self?.capitalCoordinatesBulletView.isHidden = false
                } else {
                    self?.capitalCoordinatesBulletView.isHidden = true
                }
                
                if countryDetails.capital.isEmpty {
                    self?.capitalBulletView.isHidden = true
                } else {
                    self?.capitalBulletView.isHidden = false
                    self?.capitalBulletView.set(title: C.capitalTitle, and: countryDetails.capital)
                }
                
                self?.populationBulletView.set(title: C.populationTitle, and: [countryDetails.population])
                self?.areaBulletView.set(title: C.areaTitle, and: [countryDetails.area])
                
                if countryDetails.currency.isEmpty {
                    self?.currencyBulletView.isHidden = true
                } else {
                    self?.currencyBulletView.isHidden = false
                    self?.currencyBulletView.set(title: C.currencyTitle, and: countryDetails.currency)
                }
                
                self?.timezonesBulletView.set(title: C.timezonesTitle, and: countryDetails.timezones)
                
                UIView.animate(withDuration: 0.5) {
                    self?.scrollView.alpha = 1
                }
            case let .error(message):
                self?.showErrorAlert(with: message, actionButton: "Retry", actionCompletion: { [weak self] in
                    self?.fetchDetails()
                })
            }
        }
    }
}

private extension CountryDetailsViewController {
    enum C {
        static let regionTitle = "Region:"
        static let capitalTitle = "Capital:"
        static let capitalCooridatesTitle = "Capital coordinates:"
        static let populationTitle = "Population:"
        static let areaTitle = "Area:"
        static let currencyTitle = "Currency:"
        static let timezonesTitle = "Timezones:"
    }
}
