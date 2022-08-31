import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private let kTopMargin = 20

    internal let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = R.string.localizable.text_field_placeholder()
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()

    internal let cityNamesTableView = UITableView()

    private var viewModel: SearchViewModelContract

    init() {
        viewModel = SearchViewModel()
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
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(cityNameTextField)
        setupCollectionView()
        cityNameTextField.addTarget(self, action: #selector (textChanged), for: .editingChanged)
    }

    @objc
    func textChanged() {
        viewModel.textChanged(searchTerm: cityNameTextField.text ?? "")
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
        return viewModel.cityInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel.cityInfoArray[indexPath.row].city
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityInfoToSend = viewModel.cityInfoArray[indexPath.row]
        viewModel.cellPressed(cityInfo: cityInfoToSend)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func showWeather(cityInfo: CityInfo) {
        let nextViewController = ShowWeatherViewController(data: cityInfo)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func reloadCityNames() {
        DispatchQueue.main.async {
            self.cityNamesTableView.reloadData()
        }
    }

    func showAlert(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
