//
//  NetworkManager.swift
//  Todo
//
//  Created by Nikita Beglov on 15.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchTodoList(completion: @escaping (Result<([Todo]), Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.allowsJSON5 = true
        return decoder
    }()
    
    func fetchTodoList(completion: @escaping (Result<([Todo]), Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let self = self else { return }
            do {
                let todoList = try self.decoder.decode(Welcome.self, from: data)
                completion(.success(todoList.todos))
            } catch {
                completion(.failure(error))
                print("Failed to decode: \(error)")
            }
        }.resume()
    }
}
