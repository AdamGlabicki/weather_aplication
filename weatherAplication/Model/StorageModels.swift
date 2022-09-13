import Foundation
import RealmSwift

class CityInfoObject: Object {
    @objc dynamic var city: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
}

protocol Persistable {
    associatedtype PersistedObject: Object
    func persistedObject() -> PersistedObject
    init(persistedObject: PersistedObject)
}

extension CityInfo: Persistable {

    typealias PersistedObject = CityInfoObject

    func persistedObject() -> CityInfoObject {
        let object = CityInfoObject()
        object.city = city
        object.latitude = latitude
        object.longitude = longitude
        return object
    }

    init(persistedObject: CityInfoObject) {
        city = persistedObject.city
        latitude = persistedObject.latitude
        longitude = persistedObject.longitude
    }
}
