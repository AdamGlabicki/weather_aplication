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
    private let sunImage = UIImage(named: "sun.max.fill.png")
    private let cloudAndSunImage = UIImage(named: "cloud.sun.fill.png")
    private let cloudImage = UIImage(named: "cloud.fill.png")
    private let snowImage = UIImage(named: "cloud.snow.fill.png")
    private let rainImage = UIImage(named: "cloud.rain.fill.png")
    private let heavyRainImage = UIImage(named: "cloud.heavyrain.fill.png")
    private let drizzleImage = UIImage(named: "cloud.drizzle.fill.png")
    private let boltImage = UIImage(named: "cloud.bolt.fill.png")
    
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
        stackView.axis = .horizontal
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
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
        }
    }
    
    func setupData(cellData: WeatherData) {
        self.hourLabel.text = cellData.hour
        self.temperatureLabel.text = "\(cellData.temperature)"
        self.pressureLabel.text = "\(cellData.pressure)"
        self.windSpeedLabel.text = "\(cellData.windSpeed)"
        self.weatherImageView.image = choseImage(weatherCode: cellData.weatherCode)
    }
    
    func choseImage(weatherCode: Int) -> UIImage? {
        switch weatherCode {
        case 0:
            return sunImage
        case 1:
            return cloudAndSunImage
        case 2:
            return cloudAndSunImage
        case 3:
            return cloudImage
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
            return sunImage
        }
    }
}
