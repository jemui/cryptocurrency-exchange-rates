//
//  CoinDataModel.swift
//  CryptocurrencyExchangeRates
//
//  Created by Jeanette on 1/28/25.
//  

struct CoinDataModel: Codable {
    var time: String?
    var base: String?
    var quote: String?
    var rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case base = "asset_id_base"
        case quote = "asset_id_quote"
        case rate
    }
}
