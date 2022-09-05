import SnapKit
import UIKit

class HomeView: UIView {
    let kLogoWidth: CGFloat = 250
    let kLogoHeight: CGFloat = 250
    let kSideMargin: CGFloat = 10
    let kTopMargin: CGFloat = 20
    let kBottomMargin: CGFloat = 15
    let kTableBottomMargin: CGFloat = 50
    let aplicationImage = R.image.weather_symbol()
    let logoImageView = UIImageView()
    let aplicationNameLabel = UILabel()
    let searchButton = SearchButton()
    let aplicationNameString: String = "MyWeather"
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
        aplicationNameLabelSetup()
        lastCityNamesTableViewSetup()
        self.addSubview(searchButton)
    }

    private func aplicationNameLabelSetup() {
        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        self.addSubview(aplicationNameLabel)
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
            make.topMargin.equalToSuperview().offset(kTopMargin)
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
            make.bottom.equalTo(searchButton.snp.bottom).offset(-kTableBottomMargin)
        }

        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
            make.bottomMargin.equalToSuperview().offset(-kBottomMargin).priority(.required)
        }

    }
}
