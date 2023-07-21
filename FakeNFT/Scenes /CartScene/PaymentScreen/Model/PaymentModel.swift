//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import Foundation

protocol PaymentModelProtocol {
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void)
    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void)
    
}

final class PaymentModel: PaymentModelProtocol {
    
    var urlString = "https://648cbc0b8620b8bae7ed515f.mockapi.io/"
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void) {
        guard let url = URL(string: urlString + "api/v1/currencies") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([PaymentStruct].self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных валюты \(error)")
                }
            }
        }).resume()
    }
    
    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void) {
        guard let url = URL(string: urlString + "/api/v1/orders/1/payment/" + currencyID) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(Payment.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки оплаты \(error)")
                }
            }
        }).resume()
    }
    
}
