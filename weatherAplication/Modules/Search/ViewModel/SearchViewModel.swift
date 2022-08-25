import Foundation
import UIKit

class SearchViewModel {

    var delegate: SearchViewModelDelegate?
    let apiClient = APIClient.sharedInstance

    var APIrequestFlag: Bool = false
    var cityInfoArray: [CityInfo] = []
    let delay = 0.5

    func cityChosen(cityInfo: CityInfo) {
        delegate?.cityChosen(cityInfo: cityInfo)
    }

    @objc
    func loadCityNames(sender: UITextField) {
        if APIrequestFlag != true {
            APIrequestFlag = true
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard let cityName = sender.text else {
                    self.APIrequestFlag = false
                    return }
                self.apiClient.searchCities(searchTerm: cityName, completion: { [weak self] cityInfo -> Void in
                    self?.cityInfoArray = []
                    self?.cityInfoArray = cityInfo
                    self?.APIrequestFlag = false
                    self?.delegate?.cityNamesLaoded(cityNames: cityInfo)
                }, failure: { weatherError in
                    let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.APIrequestFlag = false
                    self.delegate?.cityNamesLoadingError(alert: alert)
                })
            }
        }
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
