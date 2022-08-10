import SnapKit
import UIKit

struct CellData {
    let hour: String
    let temperature: Double
    let pressure: Double
    let windSpeed: Double
}

class ShowWeatherViewController: UIViewController{
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    
    private var longitude: Double = 0
    private var latitude: Double = 0
    
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    
    private var dataArray: [CellData] = []
    
    func getCityName() {
        guard let queryURL =  URL(string:"https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,surface_pressure,windspeed_10m") else { return }
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
                        self?.decodeJson(jsonResult: jsonResult)
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
    
    func decodeJson(jsonResult: OpenMeteoJSON) {
        let datas = jsonResult.hourly.time.count
        for data in 0...(datas-1) {
            dataArray.append(CellData(hour: String(jsonResult.hourly.time[data].dropFirst(5)), temperature: jsonResult.hourly.temperature2M[data], pressure: jsonResult.hourly.surfacePressure[data], windSpeed: jsonResult.hourly.windspeed10M[data]))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        getCityName()
    }
    
    init(city: String, longitude: Double, latitude: Double) {
        super.init(nibName: nil, bundle: nil)
        self.cityLabel.text = city
        self.longitude = longitude
        self.latitude = latitude
        dataArray = []
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
      return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? CustomTableViewCell else {fatalError("Unble to create cell")}
        cell.setupData(cellData: dataArray[indexPath.row])
        return cell
    }
}
