import SnapKit
import UIKit

class WeatherTableViewCell: UITableViewCell {
    private let kSideMargin: CGFloat = 10

    private let hourLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func setupView() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(pressureLabel)
        stackView.addArrangedSubview(windSpeedLabel)
        stackView.addArrangedSubview(weatherImageView)
        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(kSideMargin)
        }
    }

    func setupData(cellData: WeatherData) {
        hourLabel.text = cellData.hour
        temperatureLabel.text = "\(cellData.temperature)"
        pressureLabel.text = "\(cellData.pressure)"
        windSpeedLabel.text = "\(cellData.windSpeed)"
        weatherImageView.image = WeatherCodes(rawValue: cellData.weatherCode)?.image ?? WeatherCodes.sun.image
    }

}
