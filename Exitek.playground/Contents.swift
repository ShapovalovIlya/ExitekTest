import Foundation

// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
}

class MobileController: MobileStorage {
    
    var mobileStorage: Set<Mobile> = []
    
    enum MobileError: Error {
        case alreadyExists
        case notFound
    }
    
    func getAll() -> Set<Mobile> {
        return mobileStorage
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        
        for mobile in mobileStorage {
            if mobile.imei == imei {
                return mobile
            } else {
                return nil
            }
        }
        return nil
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        // Chek storage for duplicate
        if mobileStorage.contains(mobile) {
            // If mobile is duplicate throw error
            throw MobileError.alreadyExists
        } else {
            // If mobile is new add to set
            mobileStorage.insert(mobile)
            return mobile
        }
    }
    
    func delete(_ product: Mobile) throws {
        // Chek product to exist in storage
        if mobileStorage.contains(product) {
            // If product is new throw error
            throw MobileError.notFound
        } else {
            // If storage containts product, remove it
            mobileStorage.remove(product)
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        if mobileStorage.contains(product){
            return true
        }
        return false
    }
    
}

let mobileExample = MobileController()

let mobileOne = Mobile(imei: "someImei1", model: "iPhone5")
let mobileTwo = Mobile(imei: "someImei2", model: "iPhone6")
let mobileThree = Mobile(imei: "someImei3", model: "iPhone 7")

// Saving new entity
do {
    try mobileExample.save(mobileOne)
    let mobileTwoSaved = try mobileExample.save(mobileTwo)
    try mobileExample.save(mobileThree)
    // Check .save() method output
    print(mobileTwoSaved)
} catch {
    print(error)
}

// Check .exists() method output
let mobileOneExists = mobileExample.exists(mobileOne)
print(mobileOneExists)

// Check .save() method for duplicate error
let mobileOneCopy = mobileOne

do {
    try mobileExample.save(mobileOneCopy)
} catch {
    print(error)
}

// Check .findByImei() method
let mobileThreeImei = mobileThree.imei

if let mobileFoundByImei = mobileExample.findByImei(mobileThreeImei) {
    print(mobileFoundByImei)
} else {
    print(".findByImei() does not work!")
}

//let someMobileImei = "1234564"
//let finderError = mobileExample.findByImei(someMobileImei)
//print(finderError)

// Check .getAll() method
let anotherMobileStorage = mobileExample.getAll()
print(anotherMobileStorage)







