import SnapKit
import UIKit

class ShowWeatherViewController: UIViewController{
    private let kSideMargin = 10
    private let kTopMargin = 20
    private let kBottomMargin = 5
    private let kElementsToShow: Int = 24
    private let kHeaderHeight: CGFloat = 50
    
    private let longitude: Double
    private let latitude: Double
    
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    
    private var date = String()
    
    private var dataArray: [WeatherData] = []
    private var urlString: String {
       let url =  "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,surface_pressure,weathercode,windspeed_10m"
        return url
    }
    
    func makeURLRequest() {
        guard let queryURL =  URL(string:urlString) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: queryURL, completionHandler: { [weak self] data, response, error -> Void in
            
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(OpenMeteoJSONDecoded.self, from: data)
                        self?.takeDataFromJson(jsonResult: jsonResult)
                        DispatchQueue.main.async {
                            self?.weatherTableView.reloadData()
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
            
        }).resume()
    }
    
    func takeDataFromJson(jsonResult: OpenMeteoJSONDecoded) {
        let kElementsCount = kElementsToShow
        let kCharsToDrop = 11
        var dataArray2: [WeatherData] = []
        if jsonResult.hourly.time.count >= kElementsToShow,
           jsonResult.hourly.temperature2M.count >= kElementsToShow,
           jsonResult.hourly.surfacePressure.count >= kElementsToShow,
           jsonResult.hourly.windspeed10M.count >= kElementsToShow,
           jsonResult.hourly.weathercode.count >= kElementsToShow {
            date = String(jsonResult.hourly.time[0].prefix(kCharsToDrop - 1))
            for data in 0...(kElementsCount - 1) {
                dataArray2.append(WeatherData(hour: String(jsonResult.hourly.time[data].dropFirst(kCharsToDrop)), temperature: jsonResult.hourly.temperature2M[data], pressure: jsonResult.hourly.surfacePressure[data], windSpeed: jsonResult.hourly.windspeed10M[data], weatherCode: jsonResult.hourly.weathercode[data]))
            }
            dataArray = dataArray2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        makeURLRequest()
    }
    
    init(city: String, longitude: Double, latitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: nil, bundle: nil)
        cityLabel.text = city
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        view.backgroundColor = .lightGray
        
        cityLabel.textAlignment = .center
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
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
            make.centerX.equalToSuperview()
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
    }
}

extension ShowWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.setupData(cellData: dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight))
        let dateLabel = UILabel()
        let hourLabel = UILabel()
        let temperatureLabel = UILabel()
        let pressureLabel = UILabel()
        let windSpeedLabel = UILabel()
        let weatherLabel = UILabel()
        let stackView = UIStackView()
        
        headerView.backgroundColor = .white
        
        dateLabel.text = date
        hourLabel.text = "hour"
        temperatureLabel.text = "[C]"
        pressureLabel.text = "[hPa]"
        windSpeedLabel.text = "[km/h]"
        weatherLabel.text = "weather"
        
        headerView.addSubview(dateLabel)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(pressureLabel)
        stackView.addArrangedSubview(windSpeedLabel)
        stackView.addArrangedSubview(weatherLabel)
        headerView.addSubview(stackView)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kSideMargin)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.equalToSuperview().offset(kSideMargin)
            make.right.equalToSuperview().offset(-kSideMargin)
            make.bottom.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}
