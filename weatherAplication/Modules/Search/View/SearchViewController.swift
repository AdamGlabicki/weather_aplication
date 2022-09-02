import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private var viewModel: SearchViewModelContract
    private var searchView: SearchView

    init() {
        viewModel = SearchViewModel()
        searchView = SearchView(viewModelContract: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        searchView.cityNameTextField.addTarget(self, action: #selector (textChanged), for: .editingChanged)
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
        let alert = UIAlertController(title: R.string.localizable.error(), message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.oK(), style: .default))
        self.present(alert, animated: true)
    }
}
