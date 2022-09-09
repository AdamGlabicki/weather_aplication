import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private var viewModel: SearchViewModelContract
    private var searchView = SearchView()

    init() {
        viewModel = SearchViewModel()
        super.init(nibName: nil, bundle: nil)
        searchView.cityNamesTableView.dataSource = self
        searchView.cityNamesTableView.delegate = self
    }

    override func loadView() {
       view = searchView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.cityNameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        viewModel.delegate = self
    }

    @objc
    func textChanged() {
        viewModel.textChanged(searchTerm: searchView.cityNameTextField.text ?? "")
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func showWeather(cityInfo: CityInfo) {
        let nextViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func reloadCityNames() {
        DispatchQueue.main.async {
            self.searchView.cityNamesTableView.reloadData()
        }
    }

    func showAlert(description: String) {
        showCustomAlert(description: description)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.kCellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel.cityInfoArray[indexPath.row].city
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellPressed(index: indexPath.row)
    }
}
