import SnapKit
import UIKit

class ShowWeatherViewController: UIViewController {
    private let kHeaderHeight: CGFloat = 50

    private var viewModel: ShowWeatherViewModelContract
    private var showWeatherView = ShowWeatherView()

    init(data: CityInfo) {
        viewModel = ShowWeatherViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        showWeatherView.weatherTableView.delegate = self
        showWeatherView.weatherTableView.dataSource = self
    }

    override func loadView() {
       view = showWeatherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showWeatherView.cityLabel.text = viewModel.cityName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ShowWeatherViewController: ShowWeatherDelegate {
    func weatherLoaded(weatherInfo: [WeatherData], date: String) {
        DispatchQueue.main.async {
            self.showWeatherView.weatherTableView.reloadData()
        }
    }

    func showAlert(description: String) {
        showCustomAlert(description: description)
    }
}

extension ShowWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.kCellIdentifier, for: indexPath as IndexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.setupData(cellData: viewModel.weatherDataArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = WeatherDataHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight), date: viewModel.dateString)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}
