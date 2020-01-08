//
//  ViewController.swift
//  LiveStyled-Test
//
//  Created by Atharva Vaidya on 1/6/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine

class EventsTableVC: UITableViewController {
    private let viewModel: EventsTableVM
    
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK:- Initializer Methods
    init?(coder: NSCoder, viewModel: EventsTableVM) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
        
        bindToDataSource()
    }
    
    required init?(coder: NSCoder) {
        let model = EventsTableModel()
        
        self.viewModel = EventsTableVM(model: model)
        
        super.init(coder: coder)
        
        bindToDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTableView()
        setupRefreshControl()
    }
    
    //MARK:- View Setup
    private func setupTableView() {
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Download Events")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    //MARK:- IBAction Methods
    @objc private func favoriteButtonPressed(_ button: FavoriteButton) {
        do {
            let favourited = !button.isOn
            try viewModel.changedFavourited(at: IndexPath(row: button.tag, section: 0), favourited: favourited)
        } catch {
            showAlert(title: "Error", message: "Could not save to database, please try again.")
        }
    }
    
    @objc func refresh() {
        viewModel.downloadAllEvents()
    }
    
    //MARK:- Binding Methods
    private func bindToDataSource() {
        viewModel.modelUpdatedPublisher
        .receive(on: RunLoop.main)
        .sink { [unowned self] _ in
            self.tableView?.reloadData()
            self.refreshControl?.endRefreshing()
        }
        .store(in: &cancellables)
    }
    
    //MARK:- Error Handling Methods
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension EventsTableVC {
    //MARK:- Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? EventTableViewCell {
            cell.eventImageView.image = viewModel.image(at: indexPath)
            cell.titleLabel.text = viewModel.title(for: indexPath)
            cell.dateLabel.text = viewModel.date(for: indexPath)
            cell.favoriteButton.isOn = viewModel.isFavorited(at: indexPath)
            cell.favoriteButton.tag = indexPath.row
            cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        }
        
        return cell
    }
}

