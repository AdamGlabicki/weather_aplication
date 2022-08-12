import UIKit

struct Link: Decodable {
    let rel: String?
    let href: String?

    init(rel: String?, href: String?) {
        self.rel = rel
        self.href = href
    }
}
