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
        setTitle(R.string.localizable.search(), for: .normal)
        backgroundColor = .yellow
        setTitleColor(.red, for: .normal)
    }
}
