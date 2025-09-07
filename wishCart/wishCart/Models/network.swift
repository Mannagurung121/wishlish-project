import Foundation

struct Product: Codable {
    let title: String
    let price: Int
    let image: String
}

func fetchProductDetails(link: String, completion: @escaping (Product?) -> Void) {
    guard let url = URL(string: "http://192.168.1.6:3000/scrape") else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = ["url": link]
    request.httpBody = try? JSONEncoder().encode(body)

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let product = try JSONDecoder().decode(Product.self, from: data)
            completion(product)
        } catch {
            print("Decoding failed:", error)
            completion(nil)
        }
    }.resume()
}
