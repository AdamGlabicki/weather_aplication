import SnapKit
import UIKit


class CustomTableViewCell: UITableViewCell {
    private let kSideMargin: CGFloat = 10
    private let hourLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let stackView = UIStackView()
    private let sunImage = UIImage(systemName: "sun.max.fill")
    private let cloudImage = UIImage(systemName: "cloud.fill")
    private let cloudAndSunConfig = UIImage.SymbolConfiguration(paletteColors: [.init(red: 0.3, green: 0.8, blue: 0.9, alpha: 1), .init(red: 1, green: 0.7, blue: 0.2, alpha: 1)])
    private let precipitationConfig = UIImage.SymbolConfiguration(paletteColors: [.init(red: 0.3, green: 0.8, blue: 0.9, alpha: 1), .blue])
    private let boltConfig = UIImage.SymbolConfiguration(paletteColors: [.init(red: 0.3, green: 0.8, blue: 0.9, alpha: 1), .init(red: 1, green: 0.7, blue: 0.2, alpha: 1)])
    
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
        stackView.alignment = .center
        stackView.distribution = .equalCentering
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
        weatherImageView.image = chosenImage(weatherCode: cellData.weatherCode)
    }
    
    func chosenImage(weatherCode: Int) -> UIImage? {
        let cloudAndSunImage = UIImage(systemName: "cloud.sun.fill", withConfiguration: cloudAndSunConfig)
        let snowImage = UIImage(systemName: "cloud.snow.fill", withConfiguration: precipitationConfig)
        let rainImage = UIImage(systemName: "cloud.rain.fill", withConfiguration: precipitationConfig)
        let heavyRainImage = UIImage(systemName: "cloud.heavyrain.fill", withConfiguration: precipitationConfig)
        let drizzleImage = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: precipitationConfig)
        let boltImage = UIImage(systemName: "cloud.bolt.fill", withConfiguration: boltConfig)
        switch weatherCode {
        case 0:
            return sunImage?.withTintColor(.init(red: 1, green: 0.7, blue: 0.2, alpha: 1), renderingMode: .alwaysOriginal)
        case 1:
            return cloudAndSunImage
        case 2:
            return cloudAndSunImage
        case 3:
            return cloudImage?.withTintColor(.init(red: 0.3, green: 0.8, blue: 0.9, alpha: 1), renderingMode: .alwaysOriginal)
        case 51, 53, 55, 56, 57:
            return drizzleImage
        case 61, 63, 66:
            return rainImage
        case 65, 67, 80, 81, 82:
            return heavyRainImage
        case 71, 73, 75, 77, 85, 86:
            return snowImage
        case 95, 96, 99:
            return boltImage
        default:
            return sunImage?.withTintColor(.init(red: 1, green: 0.7, blue: 0.2, alpha: 1), renderingMode: .alwaysOriginal)
        }
    }
}
