import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW"
    private let listURL = "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_TEST_REGISTER_CDS/ZCDS_TEST_REGISTER"
    
    private init() {}
    
    // MARK: - Register Doctor
    func registerDoctor(request: RegistrationRequest, completion: @escaping (Result<DoctorResponseData, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("X", forHTTPHeaderField: "X-Requested-With")
        
        // Disable automatic credential handling to prevent 401 errors
        // This ensures we don't try to authenticate when the API doesn't require it
        urlRequest.httpShouldHandleCookies = false
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(request)
            urlRequest.httpBody = jsonData
            
            // Debug: Print the JSON being sent
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("=== JSON Payload Being Sent ===")
                print(jsonString)
                print("===============================")
            }
        } catch {
            print("Encoding error: \(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                let userFriendlyMessage = "Network error: \(error.localizedDescription). Please check your internet connection and try again."
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: userFriendlyMessage])))
                }
                return
            }
            
            // Check HTTP status code first
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                }
                return
            }
            
            print("📡 HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No data in response")
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
            
            // Check if response is HTML (common for 401/403 errors) BEFORE trying to decode
            if let responseString = String(data: data, encoding: .utf8) {
                if responseString.contains("<html") || responseString.contains("<!DOCTYPE") || responseString.contains("401") || responseString.contains("Not authorized") {
                    let errorMessage = "Authentication failed (401 Unauthorized). The server returned an HTML error page. Please verify the API endpoint is accessible without authentication."
                    print("❌ HTML response detected (likely 401): \(responseString.prefix(200))")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                    return
                }
                
                // Print raw response for debugging (only if it's not HTML)
                print("📄 Raw API Response (\(data.count) bytes):")
                print(responseString.prefix(1000)) // Print first 1000 chars
            }
            
            // PRIORITY 0: Check if response is HTML (common for 401/403 errors) BEFORE any JSON decoding
            if let responseString = String(data: data, encoding: .utf8) {
                if responseString.contains("<html") || responseString.contains("<!DOCTYPE") || 
                   responseString.contains("401") || responseString.contains("Not authorized") ||
                   responseString.contains("Logon failed") {
                    let errorMessage = "Authentication failed (401 Unauthorized). The server returned an HTML error page instead of JSON. This usually means the API requires authentication or the endpoint is not accessible."
                    print("❌ HTML response detected (likely 401): \(responseString.prefix(200))")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                    return
                }
            }
            
            // PRIORITY 1: Check for error response structure FIRST (regardless of HTTP status code)
            // Some APIs return 200 OK with error JSON, so we check this before attempting success decoding
            // Only try to decode as JSON if it looks like JSON (starts with {)
            if let responseString = String(data: data, encoding: .utf8),
               responseString.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("{") {
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
                   let errorMessage = errorResponse.error?.message?.value {
                    print("⚠️ API Error Response Detected: \(errorMessage)")
                    let detailedMessage = errorResponse.error?.code != nil ? "[\(errorResponse.error!.code!)] \(errorMessage)" : errorMessage
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 ? -1 : httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: detailedMessage])))
                    }
                    return
                }
            }
            
            // PRIORITY 2: Check for HTTP error status codes
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                print("⚠️ HTTP Error Status: \(httpResponse.statusCode)")
                
                // Print raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 Raw error response (\(data.count) bytes):")
                    print(responseString.prefix(500)) // Print first 500 chars
                }
                
                // Try to extract error message from response body
                var errorMessage = "Server returned error \(httpResponse.statusCode). Please try again."
                
                // Handle 401 Unauthorized specifically
                if httpResponse.statusCode == 401 {
                    errorMessage = "Authentication failed (401 Unauthorized). The server requires authentication. Please check if the API endpoint is accessible without authentication."
                }
                
                // Try to decode error response even for HTTP error codes (only if it looks like JSON)
                if let responseString = String(data: data, encoding: .utf8),
                   responseString.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("{") {
                    // Looks like JSON, try to decode
                    if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
                       let apiErrorMessage = errorResponse.error?.message?.value {
                        errorMessage = apiErrorMessage
                        if let errorCode = errorResponse.error?.code {
                            errorMessage = "[\(errorCode)] \(errorMessage)"
                        }
                    } else if responseString.contains("\"message\"") || responseString.contains("\"error\"") {
                        errorMessage = "Server error: \(httpResponse.statusCode). Please check your input and try again."
                    }
                }
                
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
                return
            }
            
            // PRIORITY 3: Success status code - try to decode as success response
            print("✅ HTTP Success Status: \(httpResponse.statusCode)")
            
            // Handle 201 Created - might have empty body or different structure
            if httpResponse.statusCode == 201 {
                print("📝 201 Created response - registration successful")
                
                // Check if response body is empty or very small
                if data.count == 0 || (data.count < 50 && String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true) {
                    print("✅ Empty response body - treating as successful registration")
                    let emptyData = DoctorResponseData()
                    DispatchQueue.main.async {
                        completion(.success(emptyData))
                    }
                    return
                }
            }
            
            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response body: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys // Use the CodingKeys we defined
                
                // Try to decode as RegistrationResponse first (with 'd' wrapper)
                var response: RegistrationResponse
                if let jsonString = String(data: data, encoding: .utf8),
                   jsonString.contains("\"d\"") {
                    // Has 'd' wrapper, decode normally
                    response = try decoder.decode(RegistrationResponse.self, from: data)
                } else {
                    // No 'd' wrapper, try to decode directly as DoctorResponseData
                    print("⚠️ Response doesn't have 'd' wrapper, trying direct decode")
                    let doctorData = try decoder.decode(DoctorResponseData.self, from: data)
                    response = RegistrationResponse(d: doctorData)
                }
                
                print("✅ Successfully decoded RegistrationResponse")
                
                if let doctorData = response.d {
                    print("✅ Doctor data found in response")
                    print("   - ID: \(doctorData.id ?? "nil")")
                    print("   - name: \(doctorData.name ?? "nil")")
                    print("   - email: \(doctorData.email ?? "nil")")
                    DispatchQueue.main.async {
                        completion(.success(doctorData))
                    }
                } else {
                    print("⚠️ Response 'd' field is nil or missing - but registration may have succeeded")
                    // For 201 Created, treat as success even without data
                    if httpResponse.statusCode == 201 {
                        print("✅ 201 Created - treating as successful registration")
                        let emptyData = DoctorResponseData()
                        DispatchQueue.main.async {
                            completion(.success(emptyData))
                        }
                    } else {
                        // For other success codes, still treat as success
                        let emptyData = DoctorResponseData()
                        DispatchQueue.main.async {
                            completion(.success(emptyData))
                        }
                    }
                }
            } catch let decodingError {
                print("❌ Decoding error: \(decodingError)")
                print("❌ Error details: \(decodingError.localizedDescription)")
                
                // Print more details about the decoding error
                if let decodingError = decodingError as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("❌ Missing key '\(key.stringValue)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .typeMismatch(let type, let context):
                        print("❌ Type mismatch for type '\(type)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .valueNotFound(let type, let context):
                        print("❌ Value not found for type '\(type)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                    case .dataCorrupted(let context):
                        print("❌ Data corrupted at path: \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) - \(context.debugDescription)")
                    @unknown default:
                        print("❌ Unknown decoding error")
                    }
                }
                
                // For 201 Created, if decoding fails, still treat as success (common for POST requests)
                if httpResponse.statusCode == 201 {
                    print("✅ 201 Created with decoding error - treating as successful registration")
                    let emptyData = DoctorResponseData()
                    DispatchQueue.main.async {
                        completion(.success(emptyData))
                    }
                    return
                }
                
                // Last resort: Try one more time to decode as error response
                // (in case the first check missed it due to JSON structure variations)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Response JSON that failed to decode: \(jsonString)")
                    
                    if jsonString.contains("\"error\"") {
                        if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
                           let errorMessage = errorResponse.error?.message?.value {
                            print("✅ Found API error in response (retry): \(errorMessage)")
                            var detailedMessage = errorMessage
                            if let errorCode = errorResponse.error?.code {
                                detailedMessage = "[\(errorCode)] \(errorMessage)"
                            }
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: detailedMessage])))
                            }
                            return
                        }
                    }
                }
                
                // Check if response is HTML (common for 401/403 errors)
                if let responseString = String(data: data, encoding: .utf8) {
                    if responseString.contains("<html") || responseString.contains("<!DOCTYPE") {
                        let errorMessage = "Server returned an HTML page (likely authentication error). HTTP Status: \(httpResponse.statusCode). Please verify the API endpoint is accessible."
                        print("❌ HTML response detected: \(responseString.prefix(200))")
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        }
                        return
                    }
                }
                
                // Show user-friendly error message with more context
                var errorMessage = "Failed to decode server response. "
                if let responseString = String(data: data, encoding: .utf8) {
                    errorMessage += "Response preview: \(responseString.prefix(300))"
                }
                errorMessage += "\n\nHTTP Status: \(httpResponse.statusCode). Check Xcode console for full response."
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }
        }.resume()
    }
    
    // MARK: - Get All Doctors
    func getAllDoctors(completion: @escaping (Result<[Doctor], Error>) -> Void) {
        // Add $format=json to force JSON response (OData supports this parameter)
        let urlString = "\(listURL)?$format=json"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpShouldHandleCookies = false
        
        print("📡 getAllDoctors URL: \(urlString)")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ Network error in getAllDoctors: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response in getAllDoctors")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                }
                return
            }
            
            print("📡 getAllDoctors HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No data in getAllDoctors response")
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
            
            // Check if response is HTML (common for 401/403 errors) BEFORE trying to decode
            if let responseString = String(data: data, encoding: .utf8) {
                if responseString.contains("<html") || responseString.contains("<!DOCTYPE") || 
                   responseString.contains("401") || responseString.contains("Not authorized") ||
                   responseString.contains("Logon failed") {
                    let errorMessage = "Authentication failed (401 Unauthorized) when fetching doctor list. The server returned an HTML error page instead of JSON."
                    print("❌ HTML response detected in getAllDoctors: \(responseString.prefix(200))")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                    return
                }
                
                print("📄 getAllDoctors Raw Response (\(data.count) bytes): \(responseString.prefix(500))")
            }
            
            // Check for HTTP error status codes
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                print("⚠️ getAllDoctors HTTP Error Status: \(httpResponse.statusCode)")
                let errorMessage = "Server returned error \(httpResponse.statusCode) when fetching doctor list."
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(DoctorListResponse.self, from: data)
                let doctors = response.d.results.map { Doctor(from: $0) }
                print("✅ Successfully decoded \(doctors.count) doctors")
                DispatchQueue.main.async {
                    completion(.success(doctors))
                }
            } catch {
                print("❌ Decoding error in getAllDoctors: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Response: \(jsonString.prefix(500))")
                }
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Get Doctor by ID
    func getDoctorById(doctorId: String, completion: @escaping (Result<Doctor, Error>) -> Void) {
        // Add $format=json to force JSON response (OData supports this parameter)
        let urlString = "\(baseURL)(guid'\(doctorId)')?$format=json"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpShouldHandleCookies = false
        
        print("📡 getDoctorById URL: \(urlString)")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ Network error in getDoctorById: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response in getDoctorById")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                }
                return
            }
            
            print("📡 getDoctorById HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("❌ No data in getDoctorById response")
                DispatchQueue.main.async {
                    completion(.failure(APIError.noData))
                }
                return
            }
            
            // Check if response is HTML (common for 401/403 errors) or XML BEFORE trying to decode
            if let responseString = String(data: data, encoding: .utf8) {
                if responseString.contains("<html") || responseString.contains("<!DOCTYPE") || 
                   responseString.contains("401") || responseString.contains("Not authorized") ||
                   responseString.contains("Logon failed") {
                    let errorMessage = "Authentication failed (401 Unauthorized) when fetching doctor details. The server returned an HTML error page instead of JSON."
                    print("❌ HTML response detected in getDoctorById: \(responseString.prefix(200))")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                    return
                }
                
                // Check if response is XML (OData Atom format) - this shouldn't happen with $format=json
                if responseString.contains("<?xml") || responseString.contains("<entry") || responseString.contains("application/atom+xml") {
                    let errorMessage = "Server returned XML instead of JSON. The API may not support $format=json parameter. Please check the API endpoint configuration."
                    print("❌ XML response detected in getDoctorById (expected JSON): \(responseString.prefix(200))")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                    return
                }
                
                print("📄 getDoctorById Raw Response (\(data.count) bytes): \(responseString.prefix(500))")
            }
            
            // Check for HTTP error status codes
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                print("⚠️ getDoctorById HTTP Error Status: \(httpResponse.statusCode)")
                let errorMessage = "Server returned error \(httpResponse.statusCode) when fetching doctor details."
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "APIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                guard let doctorData = response.d else {
                    print("❌ Doctor data not found in response")
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Doctor data not found in response"])))
                    }
                    return
                }
                print("✅ Successfully decoded doctor details - ID: \(doctorData.id ?? "nil"), Name: \(doctorData.name ?? "nil")")
                let doctor = Doctor(from: doctorData)
                DispatchQueue.main.async {
                    completion(.success(doctor))
                }
            } catch {
                print("❌ Decoding error in getDoctorById: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Response: \(jsonString.prefix(500))")
                }
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

