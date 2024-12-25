import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://127.0.0.1:3001/api/auth"
    
    private init() {}
    
    func checkPhone(phoneNumber: String) async throws -> (success: Bool, exists: Bool) {
        guard let url = URL(string: "\(baseURL)/check-phone") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["phoneNumber": phoneNumber]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            let response = try JSONDecoder().decode(CheckPhoneResponse.self, from: data)
            return (response.success, response.exists)
        } else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        }
    }
    
    func verifyCode(phoneNumber: String, code: String) async throws -> (success: Bool, isRegistered: Bool) {
        guard let url = URL(string: "\(baseURL)/verify-code") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["phoneNumber": phoneNumber, "code": code]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            let response = try JSONDecoder().decode(VerifyCodeResponse.self, from: data)
            return (response.success, response.isRegistered)
        } else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        }
    }
}

// Response Models
struct CheckPhoneResponse: Codable {
    let success: Bool
    let exists: Bool
    let message: String
}

struct VerifyCodeResponse: Codable {
    let success: Bool
    let isRegistered: Bool
    let status: String
    let message: String
}