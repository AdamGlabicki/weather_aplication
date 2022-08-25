import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private let kTopMargin = 20
    internal let apiClient = APIClient.sharedInstance

    internal let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = "city name"
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()

    internal let cityNamesTableView = UITableView()

    private var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.delegate = self
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(cityNameTextField)
        setupCollectionView()
        cityNameTextField.addTarget(viewModel, action: #selector (viewModel.loadCityNames), for: .editingChanged)
    }

    func setupCollectionView() {
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate = self
        cityNamesTableView.backgroundColor = .white
        view.addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {
        cityNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextField.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCityInfoArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel.getCityInfoArray()[indexPath.row].city
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityInfoToSend = viewModel.getCityInfoArray()[indexPath.row]
        cityChosen(cityInfo: cityInfoToSend)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func cityChosen(cityInfo: CityInfo) {
        let nextViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func cityNamesLaoded(cityNames: [CityInfo]) {
        DispatchQueue.main.async {
            self.cityNamesTableView.reloadData()
        }
    }

    func cityNamesLoadingError(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

protocol SearchViewModelContract {
    func getCityInfoArray() -> [CityInfo]
}
