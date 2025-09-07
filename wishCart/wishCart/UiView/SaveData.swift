import SwiftUI

struct SaveData: View {
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("phoneNumber") private var phoneNumber: String = ""
    @AppStorage("dob") private var dobData: Data = Data()
    @AppStorage("gender") private var gender: String = ""

    let mintColor = Color(red: 62/255, green: 180/255, blue: 137/255)

    var dob: Date? {
        try? JSONDecoder().decode(Date.self, from: dobData)
    }

    var dobFormatted: String {
        guard let dob = dob else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }

    var isDataEmpty: Bool {
        firstName.isEmpty &&
        lastName.isEmpty &&
        email.isEmpty &&
        phoneNumber.isEmpty &&
        gender.isEmpty &&
        dobData.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [
                    mintColor.opacity(0.1),
                    Color.white
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    Text("Saved Details")
                        .font(.title.bold())
                        .foregroundColor(mintColor)
                        .padding(.top, 40)

                    if isDataEmpty {
                        Spacer()
                        VStack(spacing: 15) {
                            Image(systemName: "tray")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(mintColor.opacity(0.7))
                            Text("No details found")
                                .font(.title3.bold())
                                .foregroundColor(.gray)
                            Text("Please update your profile details first.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                detailCard(icon: "person.fill", label: "First Name", value: firstName)
                                detailCard(icon: "person.fill", label: "Last Name", value: lastName)
                                detailCard(icon: "envelope.fill", label: "Email", value: email)
                                detailCard(icon: "phone.fill", label: "Phone Number", value: phoneNumber)
                                detailCard(icon: "calendar", label: "Date of Birth", value: dobFormatted)
                                detailCard(icon: "person.2.fill", label: "Gender", value: gender)
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    func detailCard(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(mintColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(mintColor)
                Text(value.isEmpty ? "Not Provided" : value)
                    .font(.body)
                    .foregroundColor(value.isEmpty ? .gray : .primary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        )
    }
}

struct SaveData_Previews: PreviewProvider {
    static var previews: some View {
        SaveData()
    }
}
