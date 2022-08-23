import UIKit

extension HomeViewController {

    @objc
    func proceedButtonPressed() {
        let nextViewController = SearchViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }

}
