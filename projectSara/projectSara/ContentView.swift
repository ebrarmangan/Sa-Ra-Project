import SwiftUI

struct ContentView: View {
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var showVerificationView = false
    @State private var showRegistrationView = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var selectedCountryCode = "+90"
    
    let countryCodes = ["+90", "+1", "+44", "+49", "+33", "+39", "+7", "+86", "+81"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker("Ülke Kodu", selection: $selectedCountryCode) {
                        ForEach(countryCodes, id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                    
                    TextField("Telefon Numarası", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                if showVerificationView {
                    TextField("Doğrulama Kodu", text: $verificationCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(action: {
                    if showVerificationView {
                        verifyCode()
                    } else {
                        sendVerificationCode()
                    }
                }) {
                    Text(showVerificationView ? "Doğrula" : "Kod Gönder")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isLoading {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle("Giriş")
        }
    }
    
    private func sendVerificationCode() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let fullPhoneNumber = selectedCountryCode + phoneNumber.replacingOccurrences(of: " ", with: "")
                let result = try await NetworkManager.shared.checkPhone(phoneNumber: fullPhoneNumber)
                
                DispatchQueue.main.async {
                    isLoading = false
                    if result.success {
                        showVerificationView = true
                    } else {
                        errorMessage = "Telefon numarası doğrulanamadı"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func verifyCode() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let fullPhoneNumber = selectedCountryCode + phoneNumber.replacingOccurrences(of: " ", with: "")
                let result = try await NetworkManager.shared.verifyCode(phoneNumber: fullPhoneNumber, code: verificationCode)
                
                DispatchQueue.main.async {
                    isLoading = false
                    if result.success {
                        if result.isRegistered {
                            // Ana sayfaya yönlendir
                        } else {
                            showRegistrationView = true
                        }
                    } else {
                        errorMessage = "Doğrulama kodu hatalı"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
}