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
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(pressureLabel)
        addSubview(windSpeedLabel)
    }
    override func layoutIfNeeded() {
        setupConstraints()
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
}
