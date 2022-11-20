//
//  TalkTableAdapter.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import UIKit

final class TalkTableAdapter: NSObject {
    private enum Constants {
        static let identifier = "BasicCell"
    }
    
    private var items = [ConnectedUser]()
    private weak var tableView: UITableView?
    
    func setup(for tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        self.tableView = tableView
    }
    
    func updateItems(_ items: [ConnectedUser]) {
        self.items = items
        tableView?.reloadData()
    }
}

extension TalkTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        let formattedDistance = String(format: "%.2f", item.distance)
        cell.textLabel?.text = "\(item.name), distance: \(formattedDistance) m"
        return cell
    }
}
