//
//  ViewController.swift
//  Geographic atlas
//
//  Created by Жансая Шакуали on 12.05.2023.
//

import UIKit

final class CountriesListСontroller: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            CountryListItemCell.self,
            forCellReuseIdentifier: CountryListItemCell.reuseIdentifier
        )
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let viewModel: CountriesListViewModelProtocol
    
    init(viewModel: CountriesListViewModelProtocol) {
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
        fetchCountries()
    }
    
    private func prepareLayout() {
        title = C.screenTitle
        view.backgroundColor = .white
        
        setupTableView()
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchCountries() {
        activityIndicator.startAnimating()
        viewModel.fetchCountries()
    }
    
    private func setupSubscription() {
        viewModel.countriesFetched = { [weak self] message in
            self?.activityIndicator.stopAnimating()
            if let message {
                self?.showErrorAlert(with: message, actionButton: "Retry", actionCompletion: { [weak self] in
                    self?.fetchCountries()
                })
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CountriesListСontroller: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CountryListItemCell.reuseIdentifier,
                for: indexPath
            ) as? CountryListItemCell
        else {
            return UITableViewCell()
        }
        
        let item = viewModel.countryItem(for: indexPath.section, at: indexPath.row)
        cell.set(item: item)
        
        cell.expandCompletion = { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        cell.learnMoreCompletion = { [weak self] in
            let viewModel = CountryDetailsViewModel(countryCode: item.countryCode)
            let vc = CountryDetailsViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleOfContinent(for: section)
    }
}

private extension CountriesListСontroller {
    enum C {
        static let screenTitle = "World countries"
    }
}
