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
    internal let sunImage = UIImage(systemName: "sun.max.fill")
    internal let cloudImage = UIImage(systemName: "cloud.fill")
    internal let cloudAndSunConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])
    internal let precipitationConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), .blue])
    internal let boltConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.cloudColor(), UIColor.darkYellowColor()])

    private var viewModel = ShowWeatherViewModel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        viewModel.delegate = self
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

extension WeatherTableViewCell: ShowWeatherDelegate {

    func chosenImage(weatherCode: WeatherCodes) -> UIImage? {
        let cloudAndSunImage = UIImage(systemName: "cloud.sun.fill", withConfiguration: cloudAndSunConfig)
        let snowImage = UIImage(systemName: "cloud.snow.fill", withConfiguration: precipitationConfig)
        let rainImage = UIImage(systemName: "cloud.rain.fill", withConfiguration: precipitationConfig)
        let heavyRainImage = UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: precipitationConfig)
        let drizzleImage = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: precipitationConfig)
        let boltImage = UIImage(systemName: "cloud.bolt.fill", withConfiguration: boltConfig)

        switch weatherCode {
        case .sun:
            return sunImage?.withTintColor(UIColor.darkYellowColor(), renderingMode: .alwaysOriginal)
        case .cloudAndSun:
            return cloudAndSunImage
        case .bigCloudAndSun:
            return cloudAndSunImage
        case .cloud:
            return cloudImage?.withTintColor(UIColor.cloudColor(), renderingMode: .alwaysOriginal)
        case .smallDrizzle, .drizzle, .bigDrizzle, .freezingDrizzle, .freezingBigDrizzle:
            return drizzleImage
        case .smallRain, .rain, .freezingRain:
            return rainImage
        case .heavyRain, .bigHeavyRain, .freezingSmallHeavyRain, .freezingHeavyRain, .freezingBigHeavyRain:
            return heavyRainImage
        case .smallSnow, .snow, .bigSnow, .heavySnow, .freezingSmallSnow, .freezingSnow:
            return snowImage
        case .smallStorm, .storm, .heavyStorm:
            return boltImage
        }
    }

}
