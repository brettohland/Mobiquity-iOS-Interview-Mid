//
//  LaunchesViewController.swift
//  Mobiquity Interview
//
//  Created by Brett Ohland on 7/25/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

import UIKit
import LaunchKit

class LaunchesViewController: UIViewController {

    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    static let detailsSegueIdentifier = "detailsSegue"
    
    var dataSource: LaunchesTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = LaunchesTableViewDataSource(tableView: tableView, delegate: self)
        tableView.dataSource = dataSource
        tableView.delegate = self
        title = "Loading"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLaunches()
    }
    
}

extension LaunchesViewController: LaunchesTableViewDataSourceDelegate {
    
    func launchesTableViewDataSource(_ ltvds: LaunchesTableViewDataSource, didUpdateLaunches: Bool, error: Error?) {
        
        self.enableRefresh()
        
        switch didUpdateLaunches {
        case true:
            OperationQueue.main.addOperation {
                self.title = "Upcoming \(ltvds.launches.count) Launches"
            }
        case false:
            showAlert()
            print("There was an error \(error.debugDescription)")
        }
    }
    
    func showAlert() {
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: "Sorry", message: "Coudn't update the list of launches, please try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.preferredAction = okAction
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension LaunchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: LaunchesViewController.detailsSegueIdentifier, sender: dataSource?.launches[indexPath.row])
    }
    
}

extension LaunchesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? LaunchDetailsViewController,
            let launch = sender as? LaunchKit.Launch,
            segue.identifier == LaunchesViewController.detailsSegueIdentifier
        else {
            return
        }
        vc.launch = launch
    }
    
}

extension LaunchesViewController {
    
    func updateLaunches() {
        disableRefresh()
        guard let launchesDataSource = tableView.dataSource as? LaunchesTableViewDataSource else {
            return
        }
        launchesDataSource.updateLaunches()
    }
    
    func disableRefresh() {
        OperationQueue.main.addOperation {
            self.refreshBarButtonItem.isEnabled = false
        }
    }
    
    func enableRefresh() {
        OperationQueue.main.addOperation {
            self.refreshBarButtonItem.isEnabled = true
        }
    }
    
}

extension LaunchesViewController {
    
    @IBAction func handleRefreshBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        dataSource?.updateLaunches()
    }
    
}
