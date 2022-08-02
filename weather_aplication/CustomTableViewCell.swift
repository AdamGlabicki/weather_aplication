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
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(pressureLabel)
        addSubview(windSpeedLabel)
    }
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        hourLabel.clipsToBounds = true
        hourLabel.snp.makeConstraints { make in
            make.leftMargin.equalToSuperview()
        }
        temperatureLabel.clipsToBounds = true
        temperatureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(hourLabel.snp.right).offset(kSideMargin)
        }
        pressureLabel.clipsToBounds = true
        pressureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(temperatureLabel.snp.right).offset(kSideMargin)
        }
        windSpeedLabel.clipsToBounds = true
        windSpeedLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(pressureLabel.snp.right).offset(kSideMargin)
        }
    }
}
