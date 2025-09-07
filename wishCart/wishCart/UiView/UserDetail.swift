import SwiftUI

struct UserDetail: View {
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("phoneNumber") private var phoneNumber: String = ""
    @AppStorage("dob") private var dobData: Data = Data()
    @AppStorage("gender") private var gender: String = "Select Gender"

    @State private var dob: Date = Date()
    @State private var showDOBPicker = false
    @State private var showGenderPicker = false
    @State private var alertMessage = ""
    @State private var showAlert = false

    let genders = ["Male", "Female", "Other"]

    var dobFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                        .autocapitalization(.words)
                    TextField("Last Name", text: $lastName)
                        .autocapitalization(.words)
                }

                Section(header: Text("Contact Info")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Additional Info")) {
                    Button {
                        withAnimation { showDOBPicker.toggle() }
                    } label: {
                        HStack {
                            Text("Date of Birth")
                            Spacer()
                            Text(dobFormatted)
                                .foregroundColor(.primary)
                        }
                    }
                    if showDOBPicker {
                        DatePicker("", selection: $dob, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .onChange(of: dob) { newValue in
                                if let encoded = try? JSONEncoder().encode(newValue) {
                                    dobData = encoded
                                }
                            }
                    }

                    Button {
                        withAnimation { showGenderPicker.toggle() }
                    } label: {
                        HStack {
                            Text("Gender")
                            Spacer()
                            Text(gender)
                                .foregroundColor(gender == "Select Gender" ? .gray : .primary)
                        }
                    }
                    if showGenderPicker {
                        Picker("Select Gender", selection: $gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: gender) { _ in
                            withAnimation { showGenderPicker = false }
                        }
                    }
                }

                Section {
                    Button(action: saveDetails) {
                        Text("Save Details")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.mint)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("User Details")
            .onAppear {
                if let decoded = try? JSONDecoder().decode(Date.self, from: dobData) {
                    dob = decoded
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Info"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Save Logic
    func saveDetails() {
        if firstName.isEmpty || lastName.isEmpty {
            alertMessage = "Please enter your full name."
            showAlert = true
            return
        }
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
        if !isValidPhone(phoneNumber) {
            alertMessage = "Please enter a valid phone number."
            showAlert = true
            return
        }
        if gender == "Select Gender" {
            alertMessage = "Please select your gender."
            showAlert = true
            return
        }
        alertMessage = "Your profile details have been saved!"
        showAlert = true
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    func isValidPhone(_ phone: String) -> Bool {
        let digits = phone.filter { "0123456789".contains($0) }
        return digits.count >= 7 && digits.count <= 15
    }
}

struct UserDetail_Previews: PreviewProvider {
    static var previews: some View {
        UserDetail()
    }
}
