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

    func putLikedNft(params: [String: Any], result: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkClient.upload(request: ProfileRequest(httpMethod: .put),
                             type: ProfileModel.self,
                             params: params,
                             onResponse: result)
    }
}


