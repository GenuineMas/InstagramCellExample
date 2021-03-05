//
//  DataManager.swift
//  InstagramCellExample
//
//  Created by Genuine on 05.03.2021.
//

import Foundation
import UIKit


 func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            print(jsonData)
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

 func parse(jsonData: Data) {
    do {
        let decodedData = try JSONDecoder().decode(Posts.self,
                                                   from: jsonData)
        
        print("UserPost1: ", decodedData)
        print("UserPost2: ", decodedData)
    
    } catch {
        print("decode error")
    }
}

 func loadJson(fromURLString urlString: String,
                      completion: @escaping (Result<Data, Error>) -> Void) {
    if let url = URL(string: urlString) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        
        urlSession.resume()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
