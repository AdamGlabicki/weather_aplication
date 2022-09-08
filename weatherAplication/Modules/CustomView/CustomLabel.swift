import UIKit

class CustomLabel: UILabel {
    init(text: String = R.string.localizable.my_weather(),
         textColor: UIColor = .white,
         textAlignment: NSTextAlignment = .center,
         backgroundColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
