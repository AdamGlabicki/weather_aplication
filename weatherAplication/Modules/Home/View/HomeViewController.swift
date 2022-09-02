import SnapKit
import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelContract
    private var homeView: HomeView

    init() {
        viewModel = HomeViewModel()
        homeView = HomeView(viewModelContract: viewModel)
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
        viewModel.delegate = self
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
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
        let nextViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func showAlert(description: String) {
        let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default))
        self.present(alert, animated: true)
    }

    func refreshCityNamesTable() {
        homeView.lastCityNamesTableView.reloadData()
    }
}
