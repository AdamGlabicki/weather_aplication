import Foundation

protocol SearchViewModelContract {
    var delegate: SearchViewModelDelegate? { get set }
    var cityInfoArray: [CityInfo] { get }

    func textChanged(searchTerm: String)
    func cellPressed(index: Int)
}

class SearchViewModel: SearchViewModelContract {

    var delegate: SearchViewModelDelegate?
    let apiClient = APIClient.sharedInstance
    let storageService = StorageService.sharedInstance

    var debounceTimer: Timer?

    var APIRequestFlag: Bool = false
    var cityInfoArray: [CityInfo] = []
    let delay = 0.5

    func textChanged(searchTerm: String) {
        validate(searchTerm: searchTerm)
    }

    func loadCityNames(searchTerm: String) {
        if searchTerm.isEmpty {
                cityInfoArray = []
                delegate?.reloadCityNames()
        } else {
            apiClient.searchCities(searchTerm: searchTerm, completion: { [weak self] cityInfo -> Void in
                self?.cityInfoArray = cityInfo
                self?.delegate?.reloadCityNames()
            }, failure: { weatherError in
                self.delegate?.showAlert(description: weatherError.localizedDescription)
            })
        }

    }

    func cellPressed(index: Int) {
        let cityInfo = cityInfoArray[index]
        storageService.addRecentlySearchedCity(cityInfo: cityInfo, failure: { [weak self] error -> Void in
            self?.delegate?.showAlert(description: error.localizedDescription)
        })
        delegate?.showWeather(cityInfo: cityInfo)
    }

    func validate(searchTerm: String) {
        if searchTerm.isEmpty {
            cityInfoArray = []
            delegate?.reloadCityNames()
        }
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { _ in
            self.loadCityNames(searchTerm: searchTerm)
        })
    }
}

protocol SearchViewModelDelegate: AnyObject {
    func showWeather(cityInfo: CityInfo)
    func reloadCityNames()
    func showAlert(description: String)
}
