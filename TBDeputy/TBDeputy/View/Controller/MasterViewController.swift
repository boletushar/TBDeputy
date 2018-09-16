//
//  MasterViewController.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    let locationProvider = LocationProvider.shared
    let viewModel = ShiftViewModel.shared
    
    let toastMsgDuration:Double = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        // Left navigation bar button to show Map view of all shifts
        let showMapView = UIBarButtonItem(title: "Map view", style: .plain, target: self, action: #selector(showMapViewClicked(_:)))
        navigationItem.leftBarButtonItem = showMapView

        // Right navigation bar button to "Start new / End current" shift
        let startORStopShiftButton = UIBarButtonItem(title: "Start shift", style: .plain, target: self, action: #selector(startOREndShiftButtonClicked(_:)))
        navigationItem.rightBarButtonItem = startORStopShiftButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Request for permission to access location services
        locationProvider.requestUserPermission()
        locationProvider.startUpdatingLocations()
        
        // Fetch all shifts for user if unavailabel online then use device stored data
        getAllShifts(isFetchingAfterEndShift: false)
    }
    
    func getAllShifts(isFetchingAfterEndShift: Bool) {
        
        let spinner = UIViewController.displaySpinner(onView: self.view)
        viewModel.getAllShifts { (status) in
            
            UIViewController.removeSpinner(spinner: spinner)
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                let currentShift = self.viewModel.shifts[0]
                if let end = currentShift.end, end.isEmpty {
                    self.navigationItem.rightBarButtonItem?.title = "End shift"
                }
                
                if status {
                    if isFetchingAfterEndShift {
                        self.navigationItem.rightBarButtonItem?.title = "Start shift"
                        AlertError.showToastMessage(msg: "Shift finished", for: self.toastMsgDuration)
                    }
                } else {
                    AlertError.showMessage(title: "Error", msg: "Unable to fetch the shifts. Loading from local storage")
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func showMapViewClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "showMaView", sender: self)
    }

    @objc
    func startOREndShiftButtonClicked(_ sender: Any) {
        
        if !CLLocationManager.locationServicesEnabled() {
            
            AlertError.showMessage(title: "Location Error", msg: "Please enable location services to use application functionality.")
            return
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let lat = "\(locationProvider.location.latitude)"
        let long = "\(locationProvider.location.longitude)"
        
        let barButton = sender as! UIBarButtonItem
        
        let spinner = UIViewController.displaySpinner(onView: self.view)
        if barButton.title == "Start shift" {
            
            let newShift = ShiftInfo.init(startTime: Formatter.iso8601.string(from: Date()), latitude: lat, longitude: long)
            self.viewModel.shifts.insert(newShift, at: 0)
            
            viewModel.postShiftInfo(info: newShift) { (status) in
                
                UIViewController.removeSpinner(spinner: spinner)
                DispatchQueue.main.async {
                    if status {
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                        barButton.title = "End shift"
                        AlertError.showToastMessage(msg: "New shift started", for: self.toastMsgDuration)
                    } else {
                        AlertError.showMessage(title: "Error", msg: "Unable to start new shift. Please try after some time")
                    }
                }
            }
        } else {
            
            viewModel.shifts[0].updateShiftEnd(endTime: Formatter.iso8601.string(from: Date()), latitude: lat, longitude: long)
        
            viewModel.postShiftInfo(info: viewModel.shifts[0]) { (status) in
                
                UIViewController.removeSpinner(spinner: spinner)
                DispatchQueue.main.async {
                    if status {
                        // Refresh shifts data once user finishes current shift
                        self.getAllShifts(isFetchingAfterEndShift: true)
                    } else {
                        // If shift end api fails reset it back to ongoing shift and display error
                        self.viewModel.shifts[0].updateShiftEnd(endTime: "", latitude: "0.00000", longitude: "0.00000")
                        AlertError.showMessage(title: "Error", msg: "Unable to end shift. Please try after some time")
                    }
                }
            }
        }
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = viewModel.shifts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.shiftInfo = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if segue.identifier == "showMaView" {
            
            let controller = segue.destination as! MapViewController
            controller.shifts = viewModel.shifts
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shifts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shiftInfoCell", for: indexPath) as! ShiftInfoTableViewCell
        let object = viewModel.shifts[indexPath.row]
        cell.set(data: object, index: indexPath.row)
        return cell
    }
}

