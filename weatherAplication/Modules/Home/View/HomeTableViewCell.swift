import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    static let kCellIdentifier = "cell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .cyan
        textLabel?.textColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupData(cityName: String) {
        textLabel?.text = cityName
    }
}
