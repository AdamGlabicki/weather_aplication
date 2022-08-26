import Foundation

protocol SearchViewModelContract {
    var delegate: SearchViewModelDelegate? { get set }
    var cityInfoArray: [CityInfo] { get }

    func textChanged(searchTerm: String)
}

class SearchViewModel: SearchViewModelContract {

    var delegate: SearchViewModelDelegate?
    let apiClient = APIClient.sharedInstance

    var debounceTimer: Timer?

    var APIRequestFlag: Bool = false
    var cityInfoArray: [CityInfo] = []
    let delay = 0.5

    func cityChosen(cityInfo: CityInfo) {
        delegate?.cityChosen(cityInfo: cityInfo)
    }

    func textChanged(searchTerm: String) {
        validate(searchTerm: searchTerm)
    }

    func loadCityNames(searchTerm: String) {
        if searchTerm == "" {
                cityInfoArray = []
                delegate?.reloadCityNames()
        } else {
            self.apiClient.searchCities(searchTerm: searchTerm, completion: { [weak self] cityInfo -> Void in
                self?.cityInfoArray = []
                self?.cityInfoArray = cityInfo
                self?.delegate?.reloadCityNames()
            }, failure: { weatherError in
                self.delegate?.showAlert(description: weatherError.localizedDescription)
            })
        }

    }

    func validate(searchTerm: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { _ in
            self.loadCityNames(searchTerm: searchTerm)
        })
    }

}

protocol SearchViewModelDelegate: AnyObject {
    func cityChosen(cityInfo: CityInfo)
    func reloadCityNames()
    func showAlert(description: String)
}
