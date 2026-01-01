import Foundation

// MARK: - Registration Request Model
struct RegistrationRequest: Codable {
    let name: String
    let nameUpper: String
    let phoneNo: String
    let whatsappNo: String
    let countryCode: String
    let email: String
    let gender: String
    let age: String
    let ageUnit: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case nameUpper = "NameUpper"
        case phoneNo = "PhoneNo"
        case whatsappNo = "WhatsappNo"
        case countryCode = "CountryCode"
        case email = "Email"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
    }
}

// MARK: - Registration Response Model
struct RegistrationResponse: Codable {
    let d: DoctorResponseData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Try to decode 'd', but make it optional in case structure is different
        // If decoding fails, set d to nil instead of throwing
        if container.contains(.d) {
            d = try? container.decode(DoctorResponseData.self, forKey: .d)
        } else {
            d = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case d
    }
    
    // Also allow decoding directly as DoctorResponseData if no 'd' wrapper
    init(d: DoctorResponseData?) {
        self.d = d
    }
}

struct DoctorResponseData: Codable {
    let metadata: Metadata?
    let id: String?
    let name: String?
    let nameUpper: String?
    let phoneNo: String?
    let whatsappNo: String?
    let countryCode: String?
    let email: String?
    let gender: String?
    let age: String?
    let ageUnit: String?
    let practiceFrmMonth: String?
    let practiceFrmYear: String?
    
    // Note: doctorsId is only used for decoding, not stored as a separate property
    // It's decoded and stored in the 'id' property
    
    enum CodingKeys: String, CodingKey {
        case metadata = "__metadata"
        case id = "ID"
        case doctorsId = "doctors_id"  // Alternative field name used in some endpoints (handled in custom decoder)
        case name = "Name"
        case nameUpper = "NameUpper"
        case phoneNo = "PhoneNo"
        case whatsappNo = "WhatsappNo"
        case countryCode = "CountryCode"
        case email = "Email"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
        case practiceFrmMonth = "practice_frm_month"
        case practiceFrmYear = "practice_frm_year"
    }
    
    // Custom encoder to exclude doctorsId (it's only for decoding)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(nameUpper, forKey: .nameUpper)
        try container.encodeIfPresent(phoneNo, forKey: .phoneNo)
        try container.encodeIfPresent(whatsappNo, forKey: .whatsappNo)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(age, forKey: .age)
        try container.encodeIfPresent(ageUnit, forKey: .ageUnit)
        try container.encodeIfPresent(practiceFrmMonth, forKey: .practiceFrmMonth)
        try container.encodeIfPresent(practiceFrmYear, forKey: .practiceFrmYear)
        // Note: doctorsId is not encoded, it's only used for decoding
    }
    
    init(metadata: Metadata? = nil, id: String? = nil, name: String? = nil, nameUpper: String? = nil, phoneNo: String? = nil, whatsappNo: String? = nil, countryCode: String? = nil, email: String? = nil, gender: String? = nil, age: String? = nil, ageUnit: String? = nil, practiceFrmMonth: String? = nil, practiceFrmYear: String? = nil) {
        self.metadata = metadata
        self.id = id
        self.name = name
        self.nameUpper = nameUpper
        self.phoneNo = phoneNo
        self.whatsappNo = whatsappNo
        self.countryCode = countryCode
        self.email = email
        self.gender = gender
        self.age = age
        self.ageUnit = ageUnit
        self.practiceFrmMonth = practiceFrmMonth
        self.practiceFrmYear = practiceFrmYear
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all fields as optional, handling missing or null values
        metadata = try? container.decode(Metadata.self, forKey: .metadata)
        
        // Handle ID - could be "ID" (uppercase) or "doctors_id" (snake_case) depending on endpoint
        if let idValue = try? container.decode(String.self, forKey: .id) {
            id = idValue.isEmpty ? nil : idValue
        } else if let doctorsIdValue = try? container.decode(String.self, forKey: .doctorsId) {
            // Fallback to doctors_id if ID is not present
            id = doctorsIdValue.isEmpty ? nil : doctorsIdValue
        } else {
            id = nil
        }
        
        // Handle name - could be empty string or missing
        if let nameValue = try? container.decode(String.self, forKey: .name) {
            name = nameValue.isEmpty ? nil : nameValue
        } else {
            name = nil
        }
        
        // Handle nameUpper
        if let nameUpperValue = try? container.decode(String.self, forKey: .nameUpper) {
            nameUpper = nameUpperValue.isEmpty ? nil : nameUpperValue
        } else {
            nameUpper = nil
        }
        
        // Handle phoneNo
        if let phoneNoValue = try? container.decode(String.self, forKey: .phoneNo) {
            phoneNo = phoneNoValue.isEmpty ? nil : phoneNoValue
        } else {
            phoneNo = nil
        }
        
        // Handle whatsappNo
        if let whatsappNoValue = try? container.decode(String.self, forKey: .whatsappNo) {
            whatsappNo = whatsappNoValue.isEmpty ? nil : whatsappNoValue
        } else {
            whatsappNo = nil
        }
        
        // Handle countryCode
        if let countryCodeValue = try? container.decode(String.self, forKey: .countryCode) {
            countryCode = countryCodeValue.isEmpty ? nil : countryCodeValue
        } else {
            countryCode = nil
        }
        
        // Handle email
        if let emailValue = try? container.decode(String.self, forKey: .email) {
            email = emailValue.isEmpty ? nil : emailValue
        } else {
            email = nil
        }
        
        // Handle gender
        if let genderValue = try? container.decode(String.self, forKey: .gender) {
            gender = genderValue.isEmpty ? nil : genderValue
        } else {
            gender = nil
        }
        
        // Handle age
        if let ageValue = try? container.decode(String.self, forKey: .age) {
            age = ageValue.isEmpty ? nil : ageValue
        } else {
            age = nil
        }
        
        // Handle ageUnit
        if let ageUnitValue = try? container.decode(String.self, forKey: .ageUnit) {
            ageUnit = ageUnitValue.isEmpty ? nil : ageUnitValue
        } else {
            ageUnit = nil
        }
        
        // Handle practice_frm_month - could be string or number
        if let monthValue = try? container.decode(String.self, forKey: .practiceFrmMonth) {
            practiceFrmMonth = monthValue.isEmpty ? nil : monthValue
        } else if let monthInt = try? container.decode(Int.self, forKey: .practiceFrmMonth) {
            practiceFrmMonth = "\(monthInt)"
        } else {
            practiceFrmMonth = nil
        }
        
        // Handle practice_frm_year - could be string or number
        if let yearValue = try? container.decode(String.self, forKey: .practiceFrmYear) {
            practiceFrmYear = yearValue.isEmpty ? nil : yearValue
        } else if let yearInt = try? container.decode(Int.self, forKey: .practiceFrmYear) {
            practiceFrmYear = "\(yearInt)"
        } else {
            practiceFrmYear = nil
        }
    }
}

struct Metadata: Codable {
    let id: String?
    let uri: String?
    let type: String?
}

// MARK: - Doctor List Response Model
struct DoctorListResponse: Codable {
    let d: DoctorListData
}

struct DoctorListData: Codable {
    let results: [DoctorResponseData]
}

// MARK: - Doctor Model for UI
struct Doctor {
    let id: String
    let name: String
    let email: String
    let gender: String
    let practiceFromMonth: String
    let practiceFromYear: String
    
    init(from response: DoctorResponseData) {
        self.id = response.id ?? ""
        self.name = response.name ?? ""
        self.email = response.email ?? ""
        self.gender = response.gender ?? ""
        self.practiceFromMonth = response.practiceFrmMonth ?? ""
        self.practiceFromYear = response.practiceFrmYear ?? ""
    }
}

