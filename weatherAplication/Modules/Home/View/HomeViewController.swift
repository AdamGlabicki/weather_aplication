import SnapKit
import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelContract
    private var homeView = HomeView()

    init() {
        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
        homeView.lastCityNamesTableView.dataSource = self
        homeView.lastCityNamesTableView.delegate = self
    }

    override func loadView() {
       view = homeView
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
        viewModel.delegate = self
        homeView.searchButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc
    func buttonPressed() {
        viewModel.proceedButtonPressed()
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func openSearchViewController() {
        let nextViewController = SearchViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func showWeather(cityInfo: CityInfo) {
        let showWeatherViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(showWeatherViewController, animated: true)
    }

    func showAlert(description: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
            self.present(alert, animated: true)
        }
    }

    func refreshCityNamesTable() {
        homeView.lastCityNamesTableView.reloadData()
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
