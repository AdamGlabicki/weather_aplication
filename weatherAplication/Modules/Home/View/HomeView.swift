import SnapKit
import UIKit

class HomeView: UIView {
    private let kLogoWidth: CGFloat = 250
    private let kLogoHeight: CGFloat = 250
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    private let kTableBottomMargin: CGFloat = 50
    private let aplicationImage = R.image.weather_symbol()
    private let logoImageView = UIImageView()
    private let aplicationNameLabel = UILabel()
    internal let searchButton = SearchButton()
    private let aplicationNameString: String = "MyWeather"
    internal let lastCityNamesTableView = UITableView()

    private var viewModel: HomeViewModelContract

    init(viewModelContract: HomeViewModelContract) {
        self.viewModel = viewModelContract
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

    func aplicationNameLabelSetup() {
        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        self.addSubview(aplicationNameLabel)
    }

    func lastCityNamesTableViewSetup() {
        lastCityNamesTableView.dataSource = self
        lastCityNamesTableView.delegate = self
        lastCityNamesTableView.backgroundColor = .cyan
        self.addSubview(lastCityNamesTableView)
        lastCityNamesTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalTo(self.snp.topMargin).offset(kTopMargin)
            make.centerX.equalTo(self.snp.centerX)
        }

        aplicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(kTopMargin)
            make.left.equalTo(self.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(self.snp.rightMargin).offset(-kSideMargin)
        }

        lastCityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(aplicationNameLabel.snp.bottom).offset(kTopMargin)
            make.left.equalTo(self.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(self.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(searchButton.snp.bottom).offset(-kTableBottomMargin)
        }

        searchButton.snp.makeConstraints { make in
            make.left.equalTo(self.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(self.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(self.snp.bottomMargin).offset(-kBottomMargin).priority(.required)
        }

    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lastSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.setupData(cityName: viewModel.lastSearches[indexPath.row].city)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellPressed(index: indexPath.row)
    }
}
