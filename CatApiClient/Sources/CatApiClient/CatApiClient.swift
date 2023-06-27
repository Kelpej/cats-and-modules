import SwiftUI
import UIKit

public struct Cat: Identifiable {
    public let id: String
    public let image: UIImage
}

private struct CatResponse: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

@available(iOS 15.0, *)
public struct CatClient {
    public init() {
        
    }
    
    public func getCats(quantity: Int) async throws -> [Cat]  {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(quantity)") else {
            fatalError("Invalid API URL")
        }
        
        let (data, _) = try! await URLSession.shared.data(from: url)
        
        let responses = try JSONDecoder().decode([CatResponse].self, from: data)
        
        var cats = [Cat]()
        
        for response in responses {
            guard let imageUrl = URL(string: response.url) else {
                fatalError("Invalid Image URL")
            }
            
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            
            if let image = UIImage(data: data) {
                cats.append(Cat(id: response.id, image: image))
            }
        }
        
        return cats
    }
}
