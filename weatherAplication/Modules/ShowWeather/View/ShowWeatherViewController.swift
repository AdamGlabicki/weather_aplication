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

    private var dateString = String()

    private var dataArray: [WeatherData] = []
    private let apiClient = APIClient.sharedInstance

    init(data: CityInfo) {
        latitude = data.latitude
        longitude = data.longitude
        super.init(nibName: nil, bundle: nil)
        cityLabel.text = data.city
        apiClient.searchWeather(latitude: latitude, longitude: longitude, completion: { [weak self] weatherInfo, date -> Void in
            self?.dataArray = []
            self?.dateString = ""
            self?.dateString = date
                self?.dataArray = weatherInfo
                DispatchQueue.main.async {
                    self?.weatherTableView.reloadData()
                }
            }, failure: { weatherError in
                let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            })
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
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.setupData(cellData: dataArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = WeatherDataHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight), date: dateString)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}