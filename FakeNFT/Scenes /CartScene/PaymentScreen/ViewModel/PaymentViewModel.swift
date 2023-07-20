//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import Foundation

protocol PaymentViewModelProtocol {
    
    var model: PaymentModelProtocol? { get set }
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void)
    func getPaymentResult(currencyID: String, completion: @escaping (Bool) -> Void)
    
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    var model: PaymentModelProtocol?
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void) {
        model?.getСurrencies(completion: { payments in
            completion(payments)
        })
    }
    
    func getPaymentResult(currencyID: String, completion: @escaping (Bool) -> Void) {
        model?.getPaymentResult(currencyID: currencyID, completion: { payment in
            completion(payment.success)
        })
    }
    
}
