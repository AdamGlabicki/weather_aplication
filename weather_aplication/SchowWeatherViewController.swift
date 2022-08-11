import SnapKit
import UIKit

struct WeatherData {
    let hour: String
    let temperature: Double
    let pressure: Double
    let windSpeed: Double
}

class ShowWeatherViewController: UIViewController{
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kElementsToShow: Int = 24
    private let kHeaderHeight: CGFloat = 50
    
    private let longitude: Double
    private let latitude: Double
    
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    
    private var date = String()
    
    private var dataArray: [WeatherData] = []
    private var dataArray2: [WeatherData] = []
    private var urlString: String {
       let url =  "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,surface_pressure,windspeed_10m"
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
                if httpResponse.statusCode == 200 {
                    do {
                        guard let data = data else { return }
                        let jsonResult = try JSONDecoder().decode(OpenMeteoJSON.self, from: data)
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
    
    func takeDataFromJson(jsonResult: OpenMeteoJSON) {
        let elementsCount = kElementsToShow
        let kCharsToDrop = 11
        if jsonResult.hourly.time.count >= kElementsToShow && jsonResult.hourly.temperature2M.count >= kElementsToShow && jsonResult.hourly.surfacePressure.count >= kElementsToShow && jsonResult.hourly.windspeed10M.count >= kElementsToShow  {
            date = String(jsonResult.hourly.time[0].prefix(kCharsToDrop-1))
            for data in 0...(elementsCount-1) {
                dataArray.append(WeatherData(hour: String(jsonResult.hourly.time[data].dropFirst(kCharsToDrop)), temperature: jsonResult.hourly.temperature2M[data], pressure: jsonResult.hourly.surfacePressure[data], windSpeed: jsonResult.hourly.windspeed10M[data]))
            }
            dataArray2 = dataArray
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
        self.cityLabel.text = city
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
            make.centerX.equalTo(view.snp.centerX)
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
    }
}

extension ShowWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.setupData(cellData: dataArray2[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: kHeaderHeight))
        let dateLabel = UILabel()
        let hourLabel = UILabel()
        let temperatureLabel = UILabel()
        let pressureLabel = UILabel()
        let windSpeedLabel = UILabel()
        
        headerView.backgroundColor = .white
        
        dateLabel.text = date
        hourLabel.text = "hour"
        temperatureLabel.text = "        [C]"
        pressureLabel.text = "    [hPa]"
        windSpeedLabel.text = " [km/h]"
        
        headerView.addSubview(dateLabel)
        headerView.addSubview(hourLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(pressureLabel)
        headerView.addSubview(windSpeedLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        hourLabel.snp.makeConstraints { make in
            make.leftMargin.equalToSuperview()
            make.top.equalToSuperview().offset(kTopMargin)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(hourLabel.snp.right).offset(kSideMargin)
            make.top.equalToSuperview().offset(kTopMargin)
        }

        pressureLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(temperatureLabel.snp.right).offset(kSideMargin)
            make.top.equalToSuperview().offset(kTopMargin)
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.left.lessThanOrEqualTo(pressureLabel.snp.right).offset(kSideMargin)
            make.top.equalToSuperview().offset(kTopMargin)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}
