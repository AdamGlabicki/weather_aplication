import SnapKit
import UIKit

class HourlyWeatherViewController: UIViewController{
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    private let cityString: String = "Warszawa"
    private let cellReuseIdentifier = "cell"
    private var dataArray: [CellData] = []
    
    func createDataArray() {
        dataArray.append(CellData(hour: "10:00", temperature: 20, pressure: 1024, windSpeed: 12))   //1
        dataArray.append(CellData(hour: "11:00", temperature: 21, pressure: 1010, windSpeed: 11))   //2
        dataArray.append(CellData(hour: "12:00", temperature: 25, pressure: 1012, windSpeed: 10))   //3
        dataArray.append(CellData(hour: "13:00", temperature: 18, pressure: 1030, windSpeed: 21))   //4
        dataArray.append(CellData(hour: "14:00", temperature: 22, pressure: 1008, windSpeed: 22))   //5
        dataArray.append(CellData(hour: "15:00", temperature: 24, pressure: 1015, windSpeed: 23))   //6
        dataArray.append(CellData(hour: "16:00", temperature: 19, pressure: 1019, windSpeed: 25))   //7
        dataArray.append(CellData(hour: "17:00", temperature: 25, pressure: 1017, windSpeed: 34))   //8
        dataArray.append(CellData(hour: "18:00", temperature: 27, pressure: 1014, windSpeed: 32))   //9
        dataArray.append(CellData(hour: "19:00", temperature: 30, pressure: 1009, windSpeed: 14))   //10
        dataArray.append(CellData(hour: "20:00", temperature: 31, pressure: 1011, windSpeed: 15))   //11
        dataArray.append(CellData(hour: "21:00", temperature: 32, pressure: 1012, windSpeed: 16))   //12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataArray()
        setupView()
        setupConstraints()
        
    }
    
    func setupView() {
        view.backgroundColor = .lightGray
        
        cityLabel.textAlignment = .center
        cityLabel.text = cityString
        view.addSubview(cityLabel)
        
        weatherTableView.dataSource = self
        weatherTableView.delegate  = self
        weatherTableView.backgroundColor = .white
        view.addSubview(weatherTableView)
        weatherTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leftMargin.equalToSuperview().offset(kSideMargin)
            make.rightMargin.equalToSuperview().offset(-kSideMargin)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
    }
}

extension HourlyWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? CustomTableViewCell else {fatalError("Unble to create cell")}
        cell.hourLabel.text = dataArray[indexPath.row].hour
        cell.temperatureLabel.text = "\(dataArray[indexPath.row].temperature)C"
        cell.pressureLabel.text = "\(dataArray[indexPath.row].pressure)hPa"
        cell.windSpeedLabel.text = "\(dataArray[indexPath.row].windSpeed)km/h"
        return cell
    }
}

struct CellData {
    lazy var hour = String()
    lazy var temperature = Int()
    lazy var pressure = Int()
    lazy var windSpeed = Int()
}

class CustomTableViewCell: UITableViewCell {
    private let kSideMargin: CGFloat = 20
    lazy var hourLabel = UILabel()
    lazy var temperatureLabel = UILabel()
    lazy var pressureLabel = UILabel()
    lazy var windSpeedLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(pressureLabel)
        addSubview(windSpeedLabel)
    }
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        hourLabel.clipsToBounds = true
        hourLabel.snp.makeConstraints { make in
            make.leftMargin.equalToSuperview()
        }
        temperatureLabel.clipsToBounds = true
        temperatureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(hourLabel.snp.right).offset(kSideMargin)
        }
        pressureLabel.clipsToBounds = true
        pressureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(temperatureLabel.snp.right).offset(kSideMargin)
        }
        windSpeedLabel.clipsToBounds = true
        windSpeedLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(pressureLabel.snp.right).offset(kSideMargin)
        }
    }
}
