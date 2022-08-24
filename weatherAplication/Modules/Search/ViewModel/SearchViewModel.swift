import Foundation

class SearchViewModel {

    var delegate: SearchViewModelDelegate?

    func cityChosen(index: Int) {

        delegate?.cityChosen(index: index)

    }

    @objc
    func loadCityNames() {

        delegate?.loadCityNames()

    }

}

protocol SearchViewModelDelegate: AnyObject {
    func cityChosen(index: Int)
    func loadCityNames()
}
