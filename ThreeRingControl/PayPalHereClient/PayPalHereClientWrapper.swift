//
//  PayPalHereClientWrapper.swift
//  OntimeDeal
//
//  Created by Tilahun, Yoseph on 1/29/18.
//  Copyright © 2018 Tilahun, Yoseph. All rights reserved.
//

import UIKit

class PayPalHereClientWrapper: NSObject {


    var payPalHereClient: PayPalHereClient {
        return PayPalHereClient(accessToken: "Access.token")
    }

    public func listProviders() -> NSArray {

        let listofProviders: NSMutableArray =  NSMutableArray()
        self.payPalHereClient.listProviders { result in
            switch result {
            case let .success(providers):
                if let provider = providers.first {

                    let viewProvider =  ViewProvider(providerId:provider._id, _id: provider._id,  name: provider.name,  prddescription: provider.prddescription, version: provider.version)
                    listofProviders.add(viewProvider)

                } else {     

                }

            case let .validationFailure(error):
                break

            case let .clientFailure(error):
                break

            }
        }

      return listofProviders

    }

    public func listCoupons() -> NSArray {

        let listofCoupons: NSMutableArray =  NSMutableArray()
        self.payPalHereClient.listCoupons { result in
            switch result {
            case let .success(coupons):


                if let coupon = coupons.first {
                   for coupon in coupons {
                    let xx = coupon
                   // let viewProvider =  ViewProvider(providerId:provider._id, _id: provider._id,  name: provider.name,  prddescription: provider.prddescription, //version: provider.version)
                    //listofProviders.add(viewProvider)
                      print(coupon)
                    }

                } else {

                }

            case let .validationFailure(error):
                break

            case let .clientFailure(error):
                break

            }
        }

        return listofCoupons

    }


}




