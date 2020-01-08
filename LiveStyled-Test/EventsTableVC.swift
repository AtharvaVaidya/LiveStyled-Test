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
    let viewModel: EventsTableVM
    
    var cancellables: Set<AnyCancellable> = []
    
    init?(coder: NSCoder, viewModel: EventsTableVM) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        let model = EventsTableModel()
        
        self.viewModel = EventsTableVM(model: model)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        viewModel.modelUpdatedPublisher
        .receive(on: RunLoop.main)
        .sink { [unowned self] _ in
            self.tableView?.reloadData()
            self.refreshControl?.endRefreshing()
        }
        .store(in: &cancellables)
        
        addRefreshControl()
    }
    
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
            cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @IBAction func downloadButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.downloadAllEvents()
    }
    
    @objc func favoriteButtonPressed(_ button: FavoriteButton) {
        button.isOn.toggle()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.downloadAllEvents()
    }
}

