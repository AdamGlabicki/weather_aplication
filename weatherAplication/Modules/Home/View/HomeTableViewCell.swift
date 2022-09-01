import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .cyan
        self.textLabel?.textColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupData(cityName: String) {
        self.textLabel?.text = cityName
    }
}
