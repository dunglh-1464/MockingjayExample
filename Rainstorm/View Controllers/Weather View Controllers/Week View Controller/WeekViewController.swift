//
//  WeekViewController.swift
//  Rainstorm
//
//  Created by Bart Jacobs on 06/06/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit

protocol WeekViewControllerDelegate: class {
    func controllerDidRefresh(_ controller: WeekViewController)
}

final class WeekViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: WeekViewControllerDelegate?
    
    // MARK: -
    
    var viewModel: WeekViewModel? {
        didSet {
            // Hide Refresh Control
            refreshControl.endRefreshing()
            
            if let viewModel = viewModel {
                // Setup View Model
                setupViewModel(with: viewModel)
            }
        }
    }

    // MARK: -
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.dataSource = self
            tableView.separatorInset = .zero
            tableView.estimatedRowHeight = 44.0
            tableView.showsVerticalScrollIndicator = false
            tableView.rowHeight = UITableViewAutomaticDimension
            
            // Set Refresh Control
            tableView.refreshControl = refreshControl
        }
    }

    // MARK: -
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }

    // MARK: -
    
    private lazy var refreshControl: UIRefreshControl = {
        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        
        // Configure Refresh Control
        refreshControl.tintColor = UIColor.Rainstorm.baseTintColor
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        return refreshControl
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        // Configure View
        view.backgroundColor = .white
    }

    // MARK: - Actions
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        // Notify Delegate
        delegate?.controllerDidRefresh(self)
    }
    
    // MARK: - Helper Methods
    
    private func setupViewModel(with viewModel: WeekViewModel) {
        // Hide Activity Indicator View
        activityIndicatorView.stopAnimating()
        
        // Update Table View
        tableView.reloadData()
        tableView.isHidden = false
    }
    
}

extension WeekViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfDays ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayTableViewCell.reuseIdentifier, for: indexPath) as? WeekDayTableViewCell else {
            fatalError("Unable to Dequeue Week Day Table View Cell")
        }
        
        guard let viewModel = viewModel else {
            fatalError("No View Model Present")
        }
        
        // Configure Cell
        cell.configure(with: viewModel.viewModel(for: indexPath.row))
        
        return cell
    }

}
