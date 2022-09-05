import SnapKit
import UIKit

class ShowWeatherView: UIView {
    let kSideMargin = 10
    let kTopMargin = 20
    let kBottomMargin = 5
    let kHeaderHeight: CGFloat = 50

    let cityLabel = UILabel()
    let weatherTableView = UITableView()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = .lightGray

        cityLabel.textAlignment = .center
        self.addSubview(cityLabel)

        weatherTableView.backgroundColor = .white
        self.addSubview(weatherTableView)
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.centerX.equalToSuperview()
        }

        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
