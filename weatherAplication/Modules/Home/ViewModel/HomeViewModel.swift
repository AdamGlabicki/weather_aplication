import Foundation

class HomeViewModel {

    var delegate: HomeViewModelDelegate?

    @objc
    func proceedButtonPressed() {
        delegate?.openSearchViewController()
    }

}

protocol HomeViewModelDelegate: AnyObject {
    func openSearchViewController()
}
