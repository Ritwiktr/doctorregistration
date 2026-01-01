import Foundation

struct APIErrorResponse: Codable {
    let error: ErrorDetail?
}

struct ErrorDetail: Codable {
    let code: String?
    let message: ErrorMessage?
    let innererror: InnerError?
}

struct ErrorMessage: Codable {
    let lang: String?
    let value: String?
}

struct InnerError: Codable {
    let application: Application?
    let transactionid: String?
    let timestamp: String?
}

struct Application: Codable {
    let component_id: String?
    let service_namespace: String?
    let service_id: String?
    let service_version: String?
}

