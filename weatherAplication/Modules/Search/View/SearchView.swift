import SnapKit
import UIKit

class SearchView: UIView {
    private let kTopMargin = 20

    internal let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = R.string.localizable.text_field_placeholder()
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()

    internal let cityNamesTableView = UITableView()
    private var viewModel: SearchViewModelContract

    init(viewModelContract: SearchViewModelContract) {
        self.viewModel = viewModelContract
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = .white
        self.addSubview(cityNameTextField)
        setupCollectionView()
    }

    func setupCollectionView() {
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate = self
        cityNamesTableView.backgroundColor = .white
        self.addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {
        cityNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextField.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = viewModel.cityInfoArray[indexPath.row].city
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellPressed(index: indexPath.row)
    }
}
