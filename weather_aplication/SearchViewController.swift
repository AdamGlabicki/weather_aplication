import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    
    private let urlString = "https://nominatim.openstreetmap.org/search?city="

    private let cityNameTextfield = UITextField()
    private let cityNamesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupConstraints()
        cityNameTextfield.addTarget(self, action: #selector(loadCityNames), for: .editingChanged)
    }
    
    @objc func loadCityNames() {
        callAPI()
    }
    
    func callAPI() {
        guard let cityName = cityNameTextfield.text else {
            return
        }
            guard let url = URL(string: "\(urlString)\(cityName)") else {
                return
            }
        
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in
            
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    print(string)
                }
            }
            task.resume()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        cityNameTextfield.placeholder = "city name"
        cityNameTextfield.textAlignment = .center
        view.addSubview(cityNameTextfield)
        
        cityNamesTableView.dataSource = self
        cityNamesTableView.delegate  = self
        cityNamesTableView.backgroundColor = .white
        view.addSubview(cityNamesTableView)
        cityNamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        cityNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leftMargin.rightMargin.equalToSuperview()
        }
        
        cityNamesTableView.snp.makeConstraints { make in
            make.top.equalTo(cityNameTextfield.snp.bottom).offset(kTopMargin)
            make.leftMargin.rightMargin.bottomMargin.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1 // to change
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = ""
        return cell
    }
}
