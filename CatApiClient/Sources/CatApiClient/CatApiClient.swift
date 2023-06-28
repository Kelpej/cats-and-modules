import Foundation

public struct CatResponse: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

@available(iOS 15.0, *)
public struct CatClient {
    private let url: URL;
    
    public init(limit: Int) {
        let animal = Bundle.main.infoDictionary?["Animal"] as? String ?? "CATS"
        
        if animal == "DOGS" {
            guard let url = URL(string: "https://api.thedogapi.com/v1/images/search?limit=\(limit)") else {
                fatalError("Invalid API URL")
            }
            
            self.url = url
        } else {
            guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(limit)") else {
                fatalError("Invalid API URL")
            }
            
            self.url = url
        }
    }
    
    @available(macOS 12.0, *)
    public func getCats(quantity: Int) async throws -> [CatResponse]  {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(quantity)") else {
            fatalError("Invalid API URL")
        }
        
        let (data, _) = try! await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([CatResponse].self, from: data)
    }
}
