import SnapKit
import UIKit

class WeatherDataHeaderView: UIView {
    private let kSideMargin = 10

    private let dateLabel = UILabel()
    private let hourLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let weatherLabel = UILabel()
    private let stackView = UIStackView()

    init(frame: CGRect, date: String) {
        super.init(frame: frame)
        setupView(date: date)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(date: String) {
        backgroundColor = .white
        dateLabel.text = date
        hourLabel.text = R.string.localizable.hour_label()
        temperatureLabel.text = "[C]"
        pressureLabel.text = "[hPa]"
        windSpeedLabel.text = "[km/h]"
        weatherLabel.text = R.string.localizable.weather_label()

        addSubview(dateLabel)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(pressureLabel)
        stackView.addArrangedSubview(windSpeedLabel)
        stackView.addArrangedSubview(weatherLabel)
        addSubview(stackView)
    }

    func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kSideMargin)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.bottom.equalToSuperview()
        }
    }

}
