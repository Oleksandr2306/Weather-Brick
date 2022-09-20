//
//  SearchViewController.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 13.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var suggestionsTable: UITableView!
    private lazy var cityManager = CityManager()
    
    private var cities: [CityObject]?
    private var filteredCities = [CityObject]()
    var callBack: ((_ city: String) -> Void)?
    private let search = UISearchController()
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.searchResultsUpdater = self
        suggestionsTable.delegate = self
        suggestionsTable.dataSource = self
        
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
            self.suggestionsTable.reloadData()
        })
    }
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SugestionTableViewCell
        
        cell.setCityLabel(city: filteredCities[indexPath.section].name)
        cell.setCountryLabel(country: filteredCities[indexPath.section].country)
        cell.setCoordinatesLabel(latitude: filteredCities[indexPath.section].coord.lat, longitude: filteredCities[indexPath.section].coord.lon)
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SugestionTableViewCell
        
        callBack?(cell.cityLabel.text!)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

