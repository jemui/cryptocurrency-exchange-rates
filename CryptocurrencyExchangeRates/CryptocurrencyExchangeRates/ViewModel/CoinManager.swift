//
//  CoinManager.swift
//  CryptocurrencyExchangeRates
//
//  Created by Jeanette on 1/28/25.
//  

import Foundation

protocol CoinManagerDelegate: Sendable {
    func didUpdatePrice(coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager: Sendable{
    
    let baseToken = "BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    let url = "https://api-realtime.exrates.coinapi.io/v1/exchangerate"
   
     
    func getCoinPrice(for currency: String) {
        fetchExchangeRate(base: baseToken, quote: currency)
    }
    
    func fetchExchangeRate(base: String, quote: String) {
        let urlString = "\(url)/\(base)/\(quote)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let apiKey = NetworkRequestManager.getAPIKey()
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        Task {
            let session = URLSession(configuration: .default)
            let networkTask = session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    guard let unwrappedError = error else { return }
                    delegate?.didFailWithError(error: unwrappedError)
                    return
                }
                
                guard let unwrappedData = data else { return }
                parseJSON(coinData: unwrappedData)
            }
            
            networkTask.resume()
        }
       
    }
    
    func parseJSON(coinData: Data) {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(CoinDataModel.self, from: coinData)
            guard let lastPrice = data.rate else { return }
            guard let quote = data.quote else { return }
            
            let coinModel = CoinModel(price: lastPrice, currency: quote)
            delegate?.didUpdatePrice(coinManager: self, coinModel: coinModel)
        } catch let error {
            delegate?.didFailWithError(error: error)
        }
    }
}
