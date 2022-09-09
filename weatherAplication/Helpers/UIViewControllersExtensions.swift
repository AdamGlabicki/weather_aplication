import Foundation
import UIKit

extension UIViewController {
    func showCustomAlert(description: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
            self.present(alert, animated: true)
        }
    }
}
