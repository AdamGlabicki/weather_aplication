import SnapKit
import UIKit


class CustomTableViewCell: UITableViewCell {
    private let kSideMargin: CGFloat = 20
    lazy var hourLabel = UILabel()
    lazy var temperatureLabel = UILabel()
    lazy var pressureLabel = UILabel()
    lazy var windSpeedLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutIfNeeded() {
        setupView()
        setupConstraints()
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
    
    func setupData(cellData: CellData) {
        self.hourLabel.text = cellData.hour
        self.temperatureLabel.text = "\(cellData.temperature)C"
        self.pressureLabel.text = "\(cellData.pressure)hPa"
        self.windSpeedLabel.text = "\(cellData.windSpeed)km/h"
    }
}
