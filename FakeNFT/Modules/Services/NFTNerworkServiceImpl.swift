//
//  NFTNerworkServiceImpl.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

final class NFTNetworkServiceImpl: NFTNetworkService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getCollectionNFT(result: @escaping (Result<NFTCollectionResponse, Error>) -> Void) {
        networkClient.send(request: NFTCollectionRequest(), type: NFTCollectionResponse.self, onResponse: result)
    }

    func getIndividualNFT(result: @escaping (Result<NFTIndividualResponse, Error>) -> Void) {
        networkClient.send(request: NFTIndividualRequest(), type: NFTIndividualResponse.self, onResponse: result)
    }

    func getLikedNFT(result: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkClient.send(request: ProfileRequest(httpMethod: .get), type: ProfileModel.self, onResponse: result)
    }

    func putLikedNft(profile: ProfileModel, result: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile),
                           type: ProfileModel.self,
                           onResponse: result)
    }

    func getOrders(result: @escaping (Result<OrderAPI, Error>) -> Void) {
        networkClient.send(request: OrderRequest(httpMethod: .get), type: OrderAPI.self, onResponse: result)
    }

    func putOrder(nfts: [String], result: @escaping (Result<OrderAPI, Error>) -> Void) {
        networkClient.send(request: OrderRequest(httpMethod: .put, dto: ["nfts": nfts]),
                           type: OrderAPI.self,
                           onResponse: result)
    }
}
