//
//  WeatherManger.swift
//  WeatherApp
//
//  Created by Abo Saleh on 9/19/20.
//  Copyright © 2020 Abo Saleh. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol WeatherMangerDelegete{
    func didUpdateWeather(_ weatherManeger: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=64f35c49ed7025a2899fb55fc9db7515&units=metric"
    
    var delegate:WeatherMangerDelegete?
    
    func fetchWeatherByCityName(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeatherByLonAndLat(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
     func performRequest(with urlString: String) {
         if let url = URL(string: urlString) {
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil {
                     self.delegate?.didFailWithError(error: error!)
                     return
                 }
                 if let safeData = data {
                     if let weather = self.parseJSON(safeData) {
                         self.delegate?.didUpdateWeather(self, weather: weather)
                     }
                 }
             }
             task.resume()
         }
     }
     
     func parseJSON(_ weatherData: Data) -> WeatherModel? {
         let decoder = JSONDecoder()
         do {
             let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
             let id = decodedData.weather[0].id
             let temp = decodedData.main.temp
             let name = decodedData.name
             
             let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
             return weather
             
         } catch {
             delegate?.didFailWithError(error: error)
             return nil
         }
     }

}
