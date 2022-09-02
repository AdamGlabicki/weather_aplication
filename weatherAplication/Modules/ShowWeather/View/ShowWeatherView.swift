import SnapKit
import UIKit

class ShowWeatherView: UIView {
    private let kSideMargin = 10
    private let kTopMargin = 20
    private let kBottomMargin = 5
    private let kHeaderHeight: CGFloat = 50

    internal let cityLabel = UILabel()
    internal let weatherTableView = UITableView()
    private var viewModel: ShowWeatherViewModelContract

    init(viewModelContract: ShowWeatherViewModelContract) {
        self.viewModel = viewModelContract
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = .lightGray

        cityLabel.textAlignment = .center
        self.addSubview(cityLabel)

        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.backgroundColor = .white
        self.addSubview(weatherTableView)
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupConstraints() {

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.right.equalToSuperview().inset(kSideMargin)
            make.centerX.equalToSuperview()
        }

        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ShowWeatherView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? WeatherTableViewCell else { return UITableViewCell() }
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
