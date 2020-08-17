//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func priceOfBitcoin(price : Double)
    func didFailWithError(error: Error )
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A7F5DD57-5C3B-49A9-89AC-E1525772EBB9"
    var delegate : CoinManagerDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice( for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest (with urlstring : String) {
        if let url =  URL(string: urlstring) {
            let session = URLSession(configuration: .default)
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    if let bitcoinPrice = JSONdecoder(safeData) {
                        self.delegate?.priceOfBitcoin(price: bitcoinPrice)
                    }
                    
                }
                
            }
            task.resume()
        }
        
        func JSONdecoder( _ data : Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let lastNumber = decodedData.rate
                
                print(lastNumber)
                return lastNumber
            } catch {
                self.delegate?.didFailWithError(error: error)
                return nil
            }
            
        }
    }
}
