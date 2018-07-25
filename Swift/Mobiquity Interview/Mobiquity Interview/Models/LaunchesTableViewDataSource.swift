//
//  LaunchesTableViewDataSource.swift
//  Mobiquity Interview
//
//  Created by Brett Ohland on 7/25/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

import UIKit
import LaunchKit

protocol LaunchesTableViewDataSourceDelegate {
    func launchesTableViewDataSource(_ ltvds: LaunchesTableViewDataSource, didUpdateLaunches: Bool, error: Error?)
}

class LaunchesTableViewDataSource: NSObject {
    var tableView: UITableView
    var delegate: LaunchesTableViewDataSourceDelegate?
    
    var launches: [LaunchKit.Launch] = [] {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    init(tableView: UITableView, delegate: LaunchesTableViewDataSourceDelegate?) {
        self.tableView = tableView
        self.delegate = delegate
    }
    
}

extension LaunchesTableViewDataSource {
    
    func updateLaunches() {
        
        let completion = { (launches: [LaunchKit.Launch], error: Error?) in
            self.hideSpinner()
            
            switch (launches.count, error) {
                
            case (_, .some(let error)):
                self.delegate?.launchesTableViewDataSource(self, didUpdateLaunches: false, error: error)
                
            case (_, .none):
                self.launches = launches
                self.delegate?.launchesTableViewDataSource(self, didUpdateLaunches: true, error: nil)
            }
    
        }

        LaunchKit.API.getLaunches(completion)
        
    }
    
    func showSpinner() {
        OperationQueue.main.addOperation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideSpinner() {
        OperationQueue.main.addOperation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

extension LaunchesTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell")
        let dataSource = launches[indexPath.row]
        cell?.textLabel?.text = dataSource.name
        cell?.detailTextLabel?.text = dataSource.windowstart
        assert(cell != nil, "Dequeued a nil cell, bad identifier?")
        return cell ?? UITableViewCell()
    }
}


