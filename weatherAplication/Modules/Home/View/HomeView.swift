import SnapKit
import UIKit

class HomeView: UIView {
    let kLogoWidth: CGFloat = 250
    let kLogoHeight: CGFloat = 250
    let kSideMargin: CGFloat = 10
    let kTopMargin: CGFloat = 40
    let kBottomMargin: CGFloat = 15
    let kTableBottomMargin: CGFloat = 30
    let aplicationImage = R.image.weather_symbol()
    let logoImageView = UIImageView()
    let aplicationNameLabel = CustomLabel(text: R.string.localizable.my_weather(), textColor: .white, textAlignment: .center, backgroundColor: .black)
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
        self.backgroundColor = .blue
        logoImageView.image = aplicationImage
        self.addSubview(logoImageView)
        self.addSubview(aplicationNameLabel)
        lastCityNamesTableViewSetup()
        self.addSubview(searchButton)
    }

    private func lastCityNamesTableViewSetup() {
        lastCityNamesTableView.backgroundColor = .cyan
        self.addSubview(lastCityNamesTableView)
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
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
        }

        lastCityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(aplicationNameLabel.snp.bottom).offset(kTopMargin)
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
            make.bottom.equalTo(searchButton.snp.top).offset(-kTableBottomMargin)
        }

        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
            make.bottomMargin.equalToSuperview().offset(-kBottomMargin)
        }

    }
}
