import SnapKit
import UIKit

class SearchView: UIView {
    private let kTopMargin = 20

    let cityNameTextField: UITextField = {
        let cityNameTextField = UITextField()
        cityNameTextField.placeholder = R.string.localizable.text_field_placeholder()
        cityNameTextField.textAlignment = .center
        return cityNameTextField
    }()

    let cityNamesTableView = UITableView()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .white
        addSubview(cityNameTextField)
        setupCollectionView()
    }

    func setupCollectionView() {
        cityNamesTableView.backgroundColor = .white
        addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {
        cityNameTextField.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(kTopMargin)
            make.left.right.equalToSuperview()
        }

        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextField.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
