//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price : String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "apikey-BB8880D8-4946-40CD-ACA7-FBD40EBD7F80"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for Currency: String){
        let urlString = "\(baseURL)/\(apiKey)/\(Currency)"
        print(urlString)
        
        
        //1.Create a URL
        
        if let url = URL(string: urlString){
            //2.Create aURLSession
            
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate = data {
                    if  let bitcoinPrice = self.parseJSON(safeDate){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: Currency)
                    }
                }
            }
            //4.Start the task
            
            task.resume()
        }

    }
    
   
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decoderData = try decoder.decode(CoinData.self, from: data)
            print(decoderData)
            
            let lastPrice = decoderData.rate
            print(lastPrice)
            return lastPrice
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
