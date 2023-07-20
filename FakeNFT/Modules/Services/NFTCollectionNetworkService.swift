//
//  NFTCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

protocol NFTNetworkService {
    func getCollectionNFT(result: @escaping (Result<NFTCollectionResponse, Error>) -> Void)
    func getIndividualNFT(result: @escaping (Result<NFTIndividualResponse, Error>) -> Void)
    func getLikedNFT(result: @escaping (Result<ProfileModel, Error>) -> Void)
    func putLikedNft(profile: ProfileModel, result: @escaping (Result<ProfileModel, Error>) -> Void)
    func getOrders(result: @escaping (Result<OrderAPI, Error>) -> Void)
    func putOrder(nfts: [String], result: @escaping (Result<OrderAPI, Error>) -> Void)
}

struct OrderAPI: Codable {
    let nfts: [String]
    let id: String
}

struct OrderRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var dto: Encodable?
    var endpoint: URL? {
        URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/orders/1")
    }
}

