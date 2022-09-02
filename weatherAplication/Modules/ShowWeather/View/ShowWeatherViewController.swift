import SnapKit
import UIKit

class ShowWeatherViewController: UIViewController {
    private var viewModel: ShowWeatherViewModelContract
    private var showWeatherView: ShowWeatherView

    init(data: CityInfo) {
        viewModel = ShowWeatherViewModel(data: data)
        showWeatherView = ShowWeatherView(viewModelContract: viewModel)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        showWeatherView.cityLabel.text = viewModel.cityName

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(showWeatherView)
        showWeatherView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
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
        let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default))
        self.present(alert, animated: true)
    }
}
