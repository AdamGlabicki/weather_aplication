import Foundation

protocol HomeViewModelContract {
    var delegate: HomeViewModelDelegate? { get set }
    var lastSearches: [CityInfo] { get }

    func viewWillAppear()
    func proceedButtonPressed()
    func cellPressed(index: Int)
}

class HomeViewModel: HomeViewModelContract {

    var delegate: HomeViewModelDelegate?
    var lastSearches: [CityInfo] = []
    let storageService = StorageService.sharedInstance

    func viewWillAppear() {
        lastSearches = storageService.getCitiesInfo(failure: { [weak self] error -> Void in
            self?.delegate?.showAlert(description: error.localizedDescription)
        })
        delegate?.refreshCityNamesTable()
    }

    @objc
    func proceedButtonPressed() {
        delegate?.openSearchViewController()
    }

    func cellPressed(index: Int) {
        let cityInfo = lastSearches[index]
        delegate?.showWeather(cityInfo: cityInfo)
    }

}

protocol HomeViewModelDelegate: AnyObject {
    func openSearchViewController()
    func showWeather(cityInfo: CityInfo)
    func showAlert(description: String)
    func refreshCityNamesTable()
}
