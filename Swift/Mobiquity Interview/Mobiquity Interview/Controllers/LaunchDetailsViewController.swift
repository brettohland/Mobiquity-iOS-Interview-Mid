//
//  LaunchDetailsViewController.swift
//  Mobiquity Interview
//
//  Created by Brett Ohland on 7/25/18.
//  Copyright © 2018 New Developer Inc. All rights reserved.
//

import UIKit
import LaunchKit

class LaunchDetailsViewController: UITableViewController {
    
    enum Section: Int {
        case details = 0
        case rocket
        case missions
        case all
        
        static func section(for row: Int) -> Section {
            return Section(rawValue: row) ?? .all
        }
        
        func sectionHeaderTitle() -> String? {
            switch self {
            case .details:
                return "Launch Details"
            case .rocket:
                return "Rocket Details"
            case .missions:
                return "Mission Details"
            default:
                return nil
            }
        }
    }
    
    enum DetailsMap: Int {
        case name = 0
        case windowStart
        case windowEnd
        case net
        
        func title() -> String {
            switch self {
            case .name:
                return "Name"
            case .windowEnd:
                return "Window End"
            case .windowStart:
                return "Window Start"
            case .net:
                return "Net"
            }
        }
    }
    
    enum RocketMap: Int {
        case name = 0
        case configuration
        case family
        
        func title() -> String {
            switch self {
            case .name:
                return "Name"
            case .configuration:
                return "Configuration"
            case .family:
                return "Family Name"
            }
        }
    }

    var launch: LaunchKit.Launch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = launch.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.rawValue
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.sectionHeaderTitle()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Section.section(for: section) {
        case .details:
            return 4
        case .rocket:
            return 3
        case .missions:
            return launch.missions.count
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell")
        return setupCell(cell: cell ?? UITableViewCell(), row: indexPath.row, launch: launch, section: Section.section(for: indexPath.section))
    }
    
}

extension LaunchKit.Launch {
    
    subscript(key: LaunchDetailsViewController.DetailsMap) -> String? {
        get {
            switch key {
            case .name:
                return self.name
            case .windowEnd:
                return self.windowend
            case .windowStart:
                return self.windowstart
            case .net:
                return self.net
            }
        }
    }
    
}

extension LaunchKit.Rocket {
    
    subscript(key: LaunchDetailsViewController.RocketMap) -> String? {
        get {
            switch key {
            case .name:
                return self.name
            case .configuration:
                return self.configuration
            case .family:
                return self.familyname
            }
        }
    }
    
}

extension LaunchDetailsViewController {
    
    func setupCell(cell: UITableViewCell, row: Int, launch: LaunchKit.Launch, section: Section) -> UITableViewCell {
        
        switch section {
        case .details:
            let detailToShow = DetailsMap(rawValue: row) ?? DetailsMap.name
            cell.detailTextLabel?.text = detailToShow.title()
            cell.textLabel?.text = launch[detailToShow]
            return cell
        case .rocket:
            let rocketDetails = RocketMap(rawValue: row) ?? RocketMap.name
            cell.detailTextLabel?.text = rocketDetails.title()
            cell.textLabel?.text = launch.rocket[rocketDetails]
            return cell
        case .missions:
            cell.detailTextLabel?.text = launch.missions[row].name
            cell.textLabel?.text = launch.missions[row].description
            return cell
        case .all:
            return cell
        }
        
        
    }
    
}
