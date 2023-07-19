//
//  NFTDetailsViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

protocol NFTDetailsViewModel {
    var imageURL: String { get }
    var sectionName: String { get }
    var sectionAuthor: String { get }
    var sectionDescription: String { get }
    var nfts: Box<[NFT]> { get }
    func selectedNft(index: Int)
    func selectFavourite(index: Int)
}

final class NFTDetailsViewModelImpl: NFTDetailsViewModel {
    private(set) var nfts: Box<[NFT]>
    let imageURL: String
    let sectionName: String
    let sectionAuthor: String
    let sectionDescription: String
    private var profile: ProfileModel

    private let nftStorageService: NFtStorageService
    private let nftNetworkService: NFTNetworkService

    init(nftStorageService: NFtStorageService, nftNetworkService: NFTNetworkService, details: NFTDetails) {
        self.nftStorageService = nftStorageService
        self.nftNetworkService = nftNetworkService
        imageURL = details.imageURL
        sectionName = details.sectionName
        sectionAuthor = details.sectionAuthor
        sectionDescription = details.sectionDescription
        profile = details.profile

        nfts = .init(details.items.map { NFT($0) })

        nfts.value.forEach { nft in
            if let index = details.profile.likes.firstIndex(where: { nft.id == $0}) {
                nfts.value[index].isFavourite = true
            }
        }
    }

    func selectedNft(index: Int) {
        nfts.value[index].isSelected.toggle()

        nfts.value[index].isSelected
        ? nftStorageService.selectNft(nfts.value[index])
        : nftStorageService.unselectNft(nfts.value[index])

    }

    func selectFavourite(index: Int) {
        nfts.value[index].isFavourite.toggle()

        if nfts.value[index].isSelected {
            profile.likes.append(nfts.value[index].id)
        } else {
            profile.likes.removeAll { nfts.value[index].id == $0}
        }

        let params: [String: Any] = [
            "name": profile.name,
            "description": profile.description,
            "website": profile.website,
            "likes": [profile.likes]
        ]

        print("liked", profile.likes)

        nftNetworkService.putLikedNft(params: params) { result in
            switch result {
            case let .success(data):
                print("jopa", data)
                print(data.likes)
            case let .failure(error):
                print("jopa", error)
            }
        }

        nfts.value[index].isSelected
        ? nftStorageService.addToFavourite(nfts.value[index])
        : nftStorageService.removeFromFavourite(nfts.value[index])
    }
}

