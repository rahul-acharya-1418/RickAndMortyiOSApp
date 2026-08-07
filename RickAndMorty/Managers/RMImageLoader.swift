//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 07/08/26.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    /// Get IMage content with URI
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            /// in here NSDatat == Data || NSString == String
            /// this objective c and swift
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            
            guard let data = data, let self, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
    
}
