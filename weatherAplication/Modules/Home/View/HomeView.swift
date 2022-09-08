import SnapKit
import UIKit

class HomeView: UIView {
    let kLogoWidth = 250
    let kLogoHeight = 250
    let kSideMargin = 10
    let kTopMargin = 40
    let kBottomMargin = 15
    let kTableBottomMargin = 30

    let logoImageView = UIImageView(image: R.image.weather_symbol())
    let aplicationNameLabel = CustomLabel(text: R.string.localizable.my_weather())
    let searchButton = SearchButton()
    let lastCityNamesTableView = UITableView()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .blue
        addSubview(logoImageView)
        addSubview(aplicationNameLabel)
        lastCityNamesTableViewSetup()
        addSubview(searchButton)
    }

    private func lastCityNamesTableViewSetup() {
        lastCityNamesTableView.backgroundColor = .cyan
        addSubview(lastCityNamesTableView)
        lastCityNamesTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalToSuperview().offset(kTopMargin)
            make.centerX.equalToSuperview()
        }

        aplicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(kTopMargin)
            make.left.right.equalToSuperview().inset(kSideMargin)
        }

        lastCityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(aplicationNameLabel.snp.bottom).offset(kTopMargin)
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.bottom.equalTo(searchButton.snp.top).offset(-kTableBottomMargin)
        }

        searchButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.bottomMargin.equalToSuperview().offset(-kBottomMargin)
        }

    }
}
