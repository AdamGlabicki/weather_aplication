import Foundation
import UIKit

class SearchViewModel {

    var delegate: SearchViewModelDelegate?
    let apiClient = APIClient.sharedInstance

    var cityInfoArray: [CityInfo] = []

    func cityChosen(cityInfo: CityInfo) {
        delegate?.cityChosen(cityInfo: cityInfo)
    }

    @objc
    func loadCityNames(sender: UITextField) {
        guard let cityName = sender.text else { return }
        apiClient.searchCities(searchTerm: cityName, completion: { [weak self] cityInfo -> Void in
            self?.cityInfoArray = []
            self?.cityInfoArray = cityInfo
            self?.delegate?.cityNamesLaoded(cityNames: cityInfo)
        }, failure: { weatherError in
            let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.delegate?.cityNamesLoadingError(alert: alert)
        })
    }

}

protocol SearchViewModelDelegate: AnyObject {
    func cityChosen(cityInfo: CityInfo)
    func cityNamesLaoded(cityNames: [CityInfo])
    func cityNamesLoadingError(alert: UIAlertController)
}

extension SearchViewModel: SearchViewModelContract {
    func getCityInfoArray() -> [CityInfo] {
        return cityInfoArray
    }

}
