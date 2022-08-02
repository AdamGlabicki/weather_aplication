import SnapKit
import UIKit

class SearchViewController: UIViewController {
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    
    private let url = "https://nominatim.openstreetmap.org/search?city="
    
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
        cell.textLabel?.text = "temporary string"
        return cell
    }
}
