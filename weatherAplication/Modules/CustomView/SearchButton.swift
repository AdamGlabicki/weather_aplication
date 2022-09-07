import Foundation
import UIKit

class SearchButton: UIButton {
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.setTitle(R.string.localizable.search(), for: .normal)
        self.backgroundColor = .yellow
        self.setTitleColor(.red, for: .normal)
    }
}
