import Foundation
import UIKit

class SearchButton: UIButton {
    private let buttonString: String = R.string.localizable.button_string()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle(buttonString, for: .normal)
        self.backgroundColor = .yellow
        self.setTitleColor(.red, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
