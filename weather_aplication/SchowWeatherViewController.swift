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
    
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    
    private var dataArray2: [CellData] = []
    private let dataArray: [CellData] = [
        CellData(hour: "10:00", temperature: 20, pressure: 1024, windSpeed: 12),
        CellData(hour: "11:00", temperature: 21, pressure: 1010, windSpeed: 11),
        CellData(hour: "12:00", temperature: 25, pressure: 1012, windSpeed: 10),
        CellData(hour: "13:00", temperature: 18, pressure: 1030, windSpeed: 21),
        CellData(hour: "14:00", temperature: 22, pressure: 1008, windSpeed: 22),
        CellData(hour: "15:00", temperature: 24, pressure: 1015, windSpeed: 23),
        CellData(hour: "16:00", temperature: 19, pressure: 1019, windSpeed: 25),
        CellData(hour: "17:00", temperature: 25, pressure: 1017, windSpeed: 34),
        CellData(hour: "18:00", temperature: 27, pressure: 1014, windSpeed: 32),
        CellData(hour: "19:00", temperature: 30, pressure: 1009, windSpeed: 14),
        CellData(hour: "20:00", temperature: 31, pressure: 1011, windSpeed: 15),
        CellData(hour: "21:00", temperature: 32, pressure: 1012, windSpeed: 16)
    ]
    
    func getCityName() {
        guard let queryURL =  URL(string:"https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m,surface_pressure,windspeed_10m") else { return }
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
            dataArray2.append(CellData(hour: jsonResult.hourly.time[data], temperature: jsonResult.hourly.temperature2M[data], pressure: jsonResult.hourly.surfacePressure[data], windSpeed: jsonResult.hourly.windspeed10M[data]))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        getCityName()
    }
    
    init(city: String) {
        super.init(nibName: nil, bundle: nil)
        self.cityLabel.text = city
        dataArray2 = []
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? CustomTableViewCell else {fatalError("Unble to create cell")}
        cell.setupData(cellData: dataArray2[indexPath.row])
        return cell
    }
}
