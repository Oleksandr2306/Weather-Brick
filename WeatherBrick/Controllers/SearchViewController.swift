//
//  SearchViewController.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 13.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private lazy var cityManager = CityManager()
    private lazy var locationManager = LocationManager()
    private lazy var weatherManager = WeatherManager()
    
    private var cities: [CityObject]?
    private var filteredCities = [CityObject]()
    var callBack: ((_ city: String) -> Void)?
    private let search = UISearchController()
    private var timer: Timer!
    
    private var userCity = "Unknown"
    private var userCountry = "Unknown"
    private var userLat: Double = 0
    private var userLon: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestLocation()
        
        title = "Search"
        
        self.navigationController?.navigationBar.tintColor = .systemGray
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        navigationItem.searchController = search
        
        let queue = DispatchQueue(label: "cities")
        queue.async {
            self.cityManager.getCity { [weak self] cities in
                self?.cities = cities
            }
        }
        
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        guard let text = searchController.searchBar.text else { return }
        guard let cityList = self.cities else { return }
        var flag = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.filteredCities = cityList.filter({ (city: CityObject) in
                
                if city.name.lowercased().contains(text.lowercased()) && flag < 10 {
                    flag += 1
                    return true
                }
                return false
            })
            
            self.filteredCities.sort(by: {$0.name.count < $1.name.count})
            self.tableView.reloadData()
        })
    }
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let text = search.searchBar.text else { return 1 }
        guard text.isEmpty else { return filteredCities.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 5))
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SugestionTableViewCell
        
        if !filteredCities.isEmpty {
            cell.configure(city: filteredCities[indexPath.section].name, country: filteredCities[indexPath.section].country, latitude: filteredCities[indexPath.section].coord.lat, longitude: filteredCities[indexPath.section].coord.lon)
        } else {
            cell.configure(city: userCity, country: userCountry, latitude: userLat, longitude: userLon)
        }
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredCities.isEmpty {
            callBack?(filteredCities[indexPath.section].name)
        } else {
            callBack?(userCity)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension SearchViewController: LocationUpdateProtocol {
    func locationDidFailWithError(error: Error) {
        print(error)
        userLat = 0
        userLon = 0
        userCity = "Unknown"
        userCountry = "Unknown"
    }
    
    func locationDidUpdateToLocation(latitude: Double, longitude: Double) {
        userLat = latitude
        userLon = longitude
        weatherManager.fetchData(latitude: latitude, longitude: longitude)
    }
}

extension SearchViewController: WeatherDisplaying {
    func didUpdateData(data: WeatherData) {
        DispatchQueue.main.async {
            self.userCity = data.city
            self.userCountry = data.sys.country
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        userCity = "Unknown"
        userCountry = "Unknown"
    }
    
    
}
