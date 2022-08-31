import Foundation

protocol HomeViewModelContract {
    var delegate: HomeViewModelDelegate? { get set }
    var lastSearches: [CityInfo] { get set }

    func viewAppear()
    func proceedButtonPressed()
    func cellPressed(cityInfo: CityInfo)
}

class HomeViewModel: HomeViewModelContract {

    var delegate: HomeViewModelDelegate?
    var lastSearches: [CityInfo] = []
    let lastSearchesKey = "lastSearchesKey"

    init() {
        viewAppear()
    }

    func viewAppear() {
        if let data = UserDefaults.standard.data(forKey: lastSearchesKey) {
            do {
                lastSearches = try PropertyListDecoder().decode([CityInfo].self, from: data)
            } catch {
                self.delegate?.showAlert(description: error.localizedDescription)
            }
        }
        lastSearches = Array(Set(lastSearches))
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
}
