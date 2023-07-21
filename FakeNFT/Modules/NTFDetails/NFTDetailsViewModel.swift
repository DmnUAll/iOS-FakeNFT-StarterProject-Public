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
    private var selectedNfts: [String]

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
        selectedNfts = details.selectedNfts

        nfts = .init(details.items.map { NFT($0) })

        let favouriteIds = Set(nfts.value.map { $0.id }).intersection(Set(details.profile.likes))

        nfts.value.enumerated().forEach { index, nft in
            if favouriteIds.contains(nft.id) {
                nfts.value[index].isFavourite = true
            }
        }

        nfts.value.enumerated().forEach { index, nft in
            if details.selectedNfts.contains(nft.id) {
                nfts.value[index].isSelected = true
            }
        }
    }

    func selectedNft(index: Int) {
        nfts.value[index].isSelected.toggle()

        if nfts.value[index].isSelected {
            selectedNfts.append(nfts.value[index].id)
        } else {
            selectedNfts.removeAll { nfts.value[index].id == $0}
        }

        nftNetworkService.putOrder(nfts: selectedNfts) { result in
            switch result {
            case let .success(data):
                print(data)
                print(data.nfts)
            case let .failure(error):
                print(error)
            }
        }

        nfts.value[index].isSelected
        ? nftStorageService.selectNft(nfts.value[index])
        : nftStorageService.unselectNft(nfts.value[index])

    }

    func selectFavourite(index: Int) {
        nfts.value[index].isFavourite.toggle()

        if nfts.value[index].isFavourite {
            profile.likes.append(nfts.value[index].id)
        } else {
            profile.likes.removeAll { nfts.value[index].id == $0}
        }

        nftNetworkService.putLikedNft(profile: profile) { result in
            switch result {
            case let .success(data):
                print(data)
                print(data.likes)
            case let .failure(error):
                print(error)
            }
        }

        nfts.value[index].isSelected
        ? nftStorageService.addToFavourite(nfts.value[index])
        : nftStorageService.removeFromFavourite(nfts.value[index])
    }
}
