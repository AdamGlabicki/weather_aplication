import Foundation

protocol HomeViewModelContract {
    var delegate: HomeViewModelDelegate? { get set }
    var lastSearches: [CityInfo] { get set }

    func viewWillAppear()
    func proceedButtonPressed()
    func cellPressed(cityInfo: CityInfo)
}

class HomeViewModel: HomeViewModelContract {

    var delegate: HomeViewModelDelegate?
    var lastSearches: [CityInfo] = []
    let recentCities = StorageService.sharedInstance

    init() {
        viewWillAppear()
    }

    func viewWillAppear() {
        lastSearches = recentCities.getCitiesInfo(failure: { [weak self] error -> Void in
            self?.delegate?.showAlert(description: error.localizedDescription)
        })
        delegate?.refreshCityNamesTable()
    }

    @objc
    func proceedButtonPressed() {
        delegate?.openSearchViewController()
    }

    func cellPressed(cityInfo: CityInfo) {
        delegate?.showWeather(cityInfo: cityInfo)
    }

}

protocol HomeViewModelDelegate: AnyObject {
    func openSearchViewController()
    func showWeather(cityInfo: CityInfo)
    func showAlert(description: String)
    func refreshCityNamesTable()
}
