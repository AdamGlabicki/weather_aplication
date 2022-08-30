import Foundation

protocol HomeViewModelContract {
    var delegate: HomeViewModelDelegate? { get set }
    var lastSearches: [CityInfo] { get set }

    func proceedButtonPressed()
}

class HomeViewModel: HomeViewModelContract {

    var delegate: HomeViewModelDelegate?
    var lastSearches: [CityInfo]

    init() {
        if let data = UserDefaults.standard.data(forKey: "test1") {
            do {
                lastSearches = try PropertyListDecoder().decode([CityInfo].self, from: data)
            } catch {
                lastSearches = []
                self.delegate?.showAlert(description: error.localizedDescription)
            }
        } else {
            lastSearches = []
        }
        lastSearches = Array(Set(lastSearches))
    }

    @objc
    func proceedButtonPressed() {
        delegate?.openSearchViewController()
    }

}

protocol HomeViewModelDelegate: AnyObject {
    func openSearchViewController()
    func showWeather(cityInfo: CityInfo)
    func showAlert(description: String)
}
