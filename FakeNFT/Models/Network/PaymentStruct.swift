//
//  PaymentStruct.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import Foundation

struct PaymentStruct: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct Payment: Codable {
    let success: Bool
    let id, orderID: String

    enum CodingKeys: String, CodingKey {
        case success, id
        case orderID = "orderId"
    }
}
