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
    private let proceedButton = UIButton()
    private let aplicationNameString: String = "MyWeather"
    private let buttonString: String = R.string.localizable.button_string()
    private let lastCityNamesTable = UITableView()

    private var viewModel: HomeViewModelContract

    init() {
        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.delegate = self
        proceedButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc
    func buttonPressed() {
        viewModel.proceedButtonPressed()
    }

    func setupView() {
        view.backgroundColor = .blue

        logoImageView.image = aplicationImage
        view.addSubview(logoImageView)

        aplicationNameLabel.text = aplicationNameString
        aplicationNameLabel.textColor = .white
        aplicationNameLabel.textAlignment = .center
        aplicationNameLabel.backgroundColor = .black
        view.addSubview(aplicationNameLabel)

        lastCityNamesTable.dataSource = self
        lastCityNamesTable.delegate = self
        lastCityNamesTable.backgroundColor = .blue
        view.addSubview(lastCityNamesTable)
        lastCityNamesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        proceedButton.setTitle(buttonString, for: .normal)
        proceedButton.setTitleColor(.red, for: .normal)
        proceedButton.backgroundColor = .yellow
        view.addSubview(proceedButton)
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

        lastCityNamesTable.snp.makeConstraints { make in
            make.top.equalTo(aplicationNameLabel.snp.bottom).offset(kTopMargin)
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(proceedButton.snp.bottom).offset(-kTableBottomMargin)
        }

        proceedButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(kSideMargin)
            make.right.equalTo(view.snp.rightMargin).offset(-kSideMargin)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-kBottomMargin).priority(.required)
        }

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.textColor = .yellow
        cell.backgroundColor = .blue
        let lastCity = UserDefaults.standard.string(forKey: "lastCityName")
        cell.textLabel?.text = lastCity
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityInfoToSend = CityInfo(city: UserDefaults.standard.string(forKey: "lastCityName") ?? "", latitude: UserDefaults.standard.double(forKey: "lastCityLatitude"), longitude: UserDefaults.standard.double(forKey: "lastCityLongitude"))
        showWeather(cityInfo: cityInfoToSend)
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
}
