import SnapKit
import UIKit

class HomeViewController: UIViewController {
    private let kLogoWidth: CGFloat = 250
    private let kLogoHeight: CGFloat = 250
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    private let kTableBottomMargin: CGFloat = 50
    private let aplicationImage = R.image.weather_symbol()
    private let logoImageView = UIImageView()
    private let aplicationNameLabel = UILabel()
    private let searchButton = SearchButton()
    private let aplicationNameString: String = "MyWeather"
    private let lastCityNamesTableView = UITableView()

    private var viewModel: HomeViewModelContract

    init() {
        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.delegate = self
        searchButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc
    func buttonPressed() {
        viewModel.proceedButtonPressed()
    }

    func setupView() {
        view.backgroundColor = .blue

        logoImageView.image = aplicationImage
        view.addSubview(logoImageView)
        aplicationNameLabelSetup()
        lastCityNamesTableViewSetup()
        view.addSubview(searchButton)
    }

    func aplicationNameLabelSetup() {
        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        view.addSubview(aplicationNameLabel)
    }

    func lastCityNamesTableViewSetup() {
        lastCityNamesTableView.dataSource = self
        lastCityNamesTableView.delegate = self
        lastCityNamesTableView.backgroundColor = .cyan
        view.addSubview(lastCityNamesTableView)
        lastCityNamesTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(kLogoWidth)
            make.height.equalTo(kLogoHeight)
            make.top.equalTo(view.snp.topMargin).offset(kTopMargin)
            make.centerX.equalTo(view.snp.centerX)
        }

        aplicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(kTopMargin)
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
        }

        lastCityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(aplicationNameLabel.snp.bottom).offset(kTopMargin)
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(searchButton.snp.bottom).offset(-kTableBottomMargin)
        }

        searchButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-kBottomMargin).priority(.required)
        }

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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

extension HomeViewController: HomeViewModelDelegate {
    func openSearchViewController() {
        let nextViewController = SearchViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func showWeather(cityInfo: CityInfo) {
        let nextViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func showAlert(description: String) {
        let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default))
        self.present(alert, animated: true)
    }

    func refreshCityNamesTable() {
        lastCityNamesTableView.reloadData()
    }
}
