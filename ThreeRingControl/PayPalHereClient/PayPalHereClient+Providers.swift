//
//  PayPalHereClient+Providers.swift
//  OntimeDeal
//5
//  Created by Tilahun, Yoseph on 1/28/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//
import Foundation

extension PayPalHereClient {

    //   NSString *urlAddress = [NSString stringWithFormat:@"http://customerconnect.herokuapp.com/api/providers"];

    public func listProviders(_ completion: @escaping ((Result<[ProviderObj], BasicError>) -> Void)) -> Task? {

        return performRequest(.GET, path: "api/providers", baseURL: URL(string: "http://customerconnect.herokuapp.com"), completion: completion) {
            (dictionaries: [JSONDictionary]) -> [ProviderObj]? in
            return dictionaries.flatMap { ProviderObj(dictionary: $0) }
        }
    }
//performRequest(.GET, path: "venmo-card-settings", completion: completion, success: VenmoCardSettings.init)
   // open func performRequest<Input, Output, OutputError: ValidationErrorType>(_ method: Method, path: String, parameters: JSONDictionary? = nil, headers: JSONDictionary? = nil, baseURL: URL? = nil, completion: @escaping (Result<Output, //OutputError>) -> Void, success: @escaping ((Input) -> Output?)) -> Task? {


    @discardableResult

    public func listCoupons(_ completion: @escaping ((Result<[Coupon], BasicError>) -> Void)) -> Task? {

        return performRequest(.GET, path: "api/providers/id=5652da1a37ed28cf19a4cc53/coupons/", baseURL: URL(string: "http://customerconnect.herokuapp.com"), completion: completion) {
            (dictionaries: [JSONDictionary]) -> [Coupon]? in
            return dictionaries.flatMap { Coupon(dictionary: $0) }
        }
    }



}
























