import Foundation

protocol HomeViewModelContract {
    var delegate: HomeViewModelDelegate? { get set }

    func proceedButtonPressed()
}

class HomeViewModel: HomeViewModelContract {

    var delegate: HomeViewModelDelegate?

    @objc
    func proceedButtonPressed() {
        delegate?.openSearchViewController()
    }

}

protocol HomeViewModelDelegate: AnyObject {
    func openSearchViewController()
    func showWeather(cityInfo: CityInfo)
}
