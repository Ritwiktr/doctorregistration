import Foundation

class RegistrationData {
    static let shared = RegistrationData()
    
    var name: String = ""
    var email: String = ""
    var gender: String = "M"
    var practiceFromMonths: String = ""
    var practiceFromYears: String = ""
    var phoneNo: String = ""
    var whatsappNo: String = ""
    var countryCode: String = "IN"
    var age: String = ""
    var ageUnit: String = "Y"
    
    private init() {}
    
    func reset() {
        name = ""
        email = ""
        gender = "M"
        practiceFromMonths = ""
        practiceFromYears = ""
        phoneNo = ""
        whatsappNo = ""
        countryCode = "IN"
        age = ""
        ageUnit = "Y"
    }
}

