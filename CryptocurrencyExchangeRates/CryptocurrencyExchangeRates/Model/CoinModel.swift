//
//  CoinModel.swift
//  CryptocurrencyExchangeRates
//
//  Created by Jeanette on 1/28/25.
//  

struct CoinModel {
    var price: Double
    var currency: String
    
    var priceString: String {
        String(format: "%0.2f", price)
    }
    
}
