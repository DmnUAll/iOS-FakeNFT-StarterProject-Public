//
//  NFTDetailsFactory.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

struct NFTDetailsFactory {
    static func create(_ details: NFTDetails) -> UIViewController {
        let storageService = StorageServiceImpl()
        let storage = NFtStorageServiceImpl(storageService: storageService)
        let client = DefaultNetworkClient()
        let networkService = NFTNetworkServiceImpl(networkClient: client)
        let viewModel = NFTDetailsViewModelImpl(nftStorageService: storage,
                                                nftNetworkService: networkService,
                                                details: details)
        let viewController = NFTDetailsViewController(viewModel: viewModel)
        return viewController
    }
}


