import SnapKit
import UIKit


class CustomTableViewCell: UITableViewCell {
    private let kSideMargin: CGFloat = 20
    private let hourLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let windSpeedLabel = UILabel()
    
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
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(pressureLabel)
        addSubview(windSpeedLabel)
    }
    
    func setupConstraints() {
        hourLabel.snp.makeConstraints { make in
            make.leftMargin.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(hourLabel.snp.right).offset(kSideMargin)
        }

        pressureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(temperatureLabel.snp.right).offset(kSideMargin)
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(pressureLabel.snp.right).offset(kSideMargin)
        }
    }
    
    func setupData(cellData: WeatherData) {
        self.hourLabel.text = cellData.hour
        self.temperatureLabel.text = "\(cellData.temperature)"
        self.pressureLabel.text = "\(cellData.pressure)"
        self.windSpeedLabel.text = "\(cellData.windSpeed)"
    }
}
