//
//  WeatherController.swift
//  WeatherApp
//
//  Created by Prateek on 27/03/23.
//

import UIKit

struct Constant {
    static let url = "https://api.openweathermap.org/data/2.5/weather"
    static let apiKey = "0ba57e90a28fe70c01dbe8975b73e12a"
}


class WeatherController: UITableViewController {
    
    
    var weatherInfo = [Weather]()  {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onGetResponse = { [weak self] response in
                self?.weatherInfo = response
        }
        viewModel.onGetError = { [weak self] error in
            self?.updateUI()
        }
        
        //Call this method on search button
        
        addSearchView()
    }
    
    private func addSearchView() {
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search City"
        self.navigationItem.searchController = search
    }
    
    private func updateUI() {
        let alert = UIAlertController(title: "", message: "Data not found", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.city ?? ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)

        let modle = weatherInfo[indexPath.row]
        
        cell.textLabel?.text = modle.description

        return cell
    }

}

extension WeatherController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        weatherInfo = []
    }
}

extension WeatherController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchCity = searchBar.text,!searchCity.isEmpty else {
            weatherInfo = []
            return
        }
        viewModel.loadWeatherData(for: searchCity)
    }

}

