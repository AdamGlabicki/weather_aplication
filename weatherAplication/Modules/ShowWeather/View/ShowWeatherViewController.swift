import SnapKit
import UIKit

class ShowWeatherViewController: UIViewController {
    private let kSideMargin = 10
    private let kTopMargin = 20
    private let kBottomMargin = 5
    private let kHeaderHeight: CGFloat = 50

    private let longitude: Double
    private let latitude: Double

    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()

    private let apiClient = APIClient.sharedInstance
    private var viewModel = ShowWeatherViewModel()

    init(data: CityInfo) {
        latitude = data.latitude
        longitude = data.longitude
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.getWeather(data: data)
        cityLabel.text = data.city

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        view.backgroundColor = .lightGray

        cityLabel.textAlignment = .center
        view.addSubview(cityLabel)

        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.backgroundColor = .white
        view.addSubview(weatherTableView)
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.centerX.equalToSuperview()
        }

        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
    }
}

extension ShowWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getWeatherDataArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.setupData(cellData: viewModel.getWeatherDataArray()[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = WeatherDataHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight), date: viewModel.getDate())
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}

extension ShowWeatherViewController: ShowWeatherDelegate {
    func weatherLoaded(weatherInfo: [WeatherData], date: String) {
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }

    func wetherLoadingError(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

protocol ShowWeatherViewModelContract {
    func getWeatherDataArray() -> [WeatherData]
    func getDate() -> String
}
