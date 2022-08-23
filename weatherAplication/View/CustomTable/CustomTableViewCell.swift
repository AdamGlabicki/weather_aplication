import SnapKit
import UIKit

class CustomTableViewCell: UITableViewCell {
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
    internal let sunImage = UIImage(systemName: "sun.max.fill")
    internal let cloudImage = UIImage(systemName: "cloud.fill")
    internal let cloudAndSunConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])
    internal let precipitationConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), .blue])
    internal let boltConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])

    enum WeatherCodes: Int {
        case sun = 0
        case cloudAndSun = 1
        case bigCloudAndSun = 2
        case cloud = 3
        case smallDrizzle = 51
        case drizzle = 53
        case bigDrizzle = 55
        case freezingDrizzle = 56
        case freezingBigDrizzle = 57
        case smallRain = 61
        case rain = 63
        case freezingRain = 66
        case heavyRain = 65
        case bigHeavyRain = 67
        case freezingSmallHeavyRain = 80
        case freezingHeavyRain = 81
        case freezingBigHeavyRain = 82
        case smallSnow = 71
        case snow = 73
        case bigSnow = 75
        case heavySnow = 77
        case freezingSmallSnow = 85
        case freezingSnow = 86
        case smallStorm = 95
        case storm = 96
        case heavyStorm = 99
    }

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
        weatherImageView.image = chosenImage(weatherCode: WeatherCodes(rawValue: cellData.weatherCode) ?? WeatherCodes.sun)
    }

}
