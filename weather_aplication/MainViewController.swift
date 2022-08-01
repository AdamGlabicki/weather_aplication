import SnapKit
import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let kSideMargin: CGFloat = 10
    private let kTopMargin: CGFloat = 20
    private let kBottomMargin: CGFloat = 15
    private let cityLabel = UILabel()
    private let weatherTableView = UITableView()
    private let cityString: String = "Warszawa"
    private let cellReuseIdentifier = "cell"
    private let hoursStringArray: [String] = ["8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00","19:00","20:00"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return hoursStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "\(hoursStringArray[indexPath.row])"
      return cell
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
        weatherTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func setupConstraints() {
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(kTopMargin)
            make.leftMargin.equalToSuperview()
            make.rightMargin.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
    }
}
    
