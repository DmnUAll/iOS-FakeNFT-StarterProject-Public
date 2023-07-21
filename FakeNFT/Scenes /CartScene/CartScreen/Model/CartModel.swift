//
//  CartModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 25.06.2023.
//

import Foundation

protocol CartModelProtocol {
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void)
    func cartNFTs(completion: @escaping (OrdersStruct) -> Void)
    func changeCart(newArray: [String], completion: @escaping () -> Void)
    
}

final class CartModel: CartModelProtocol {
    
    enum Constants {
        static let urlString = "https://648cbc0b8620b8bae7ed515f.mockapi.io/"
    }
    
    private let networkClient = DefaultNetworkClient()
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void) {
        let requestString = Constants.urlString + "api/v1/nft/" + nftID
        guard let url = URL(string: requestString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CartStruct.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных корзины \(error) \(nftID)")
                }
            }
        }).resume()
    }
    
    func cartNFTs(completion: @escaping (OrdersStruct) -> Void) {
        let requestString = Constants.urlString + "api/v1/orders/1"
        guard let url = URL(string: requestString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(OrdersStruct.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных корзины \(error)")
                }
            }
        }).resume()
    }
    
    func changeCart(newArray: [String], completion: @escaping () -> Void) {
        let requestString = Constants.urlString + "api/v1/orders/1"
        guard let url = URL(string: requestString) else { return }
        let parameters = [
            "nfts": newArray
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(OrdersStruct.self, from: data)
                        completion()
                    } catch {
                        print(response)
                        print("Ошибка загрузки данных корзины \(error)")
                    }
                }
            })
            session.resume()
        } catch {
            print("Ошибка сериализации параметров в JSON: \(error)")
        }
    }

    
}
