import UIKit

extension SearchViewController {

    @objc
    func loadCityNames() {
        guard let cityName = cityNameTextField.text else { return }
        apiClient.searchCities(searchTerm: cityName, completion: { [weak self] cityInfo -> Void in
            self?.cityInfosArray = []
            self?.cityInfosArray = cityInfo
            DispatchQueue.main.async {
                self?.cityNamesTableView.reloadData()
            }
        }, failure: { weatherError in
            let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        })
    }

}
