import UIKit

struct Metadata: Decodable {
    let currentOffset: Int?
    let totalCount: Int?

    init(currentOffset: Int?, totalCount: Int?) {
        self.currentOffset = currentOffset
        self.totalCount = totalCount
    }
}
