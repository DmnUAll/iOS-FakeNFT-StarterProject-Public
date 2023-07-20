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
    
}

final class CartModel: CartModelProtocol {
    
    enum Constants {
        static let urlString = "https://648cbc0b8620b8bae7ed515f.mockapi.io/"
    }
    
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
        let requestString = Constants.urlString + "/api/v1/orders/1"
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
    
}
