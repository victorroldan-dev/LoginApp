//
//  Helper.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation

class Helper{
    static func decodeJSON<T: Decodable>(_ fileName: String) -> T? {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedObject = try decoder.decode(T.self, from: jsonData)
                return decodedObject
            } catch {
                print("Error al decodificar el JSON: \(error)")
                return nil
            }
        }
        return nil
    }
}

