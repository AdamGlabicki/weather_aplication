import UIKit

extension SearchViewController {

    func cityChosen(index: Int) {
        let cityInfoToSend = cityInfosArray[index]
        let nextViewController = ShowWeatherViewController(data: cityInfoToSend)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

}
