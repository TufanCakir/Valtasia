//
//  JSONLoader.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

class JSONLoader {

    static func load<T: Decodable>(
        _ file: String
    ) throws -> T {

        guard let url =
            Bundle.main.url(
                forResource: file,
                withExtension: "json"
            )
        else {

            fatalError(
             "JSON file not found: \(file).json"
            )
        }

        let data =
        try Data(contentsOf: url)

        return try JSONDecoder()
            .decode(
                T.self,
                from: data
            )
    }
}
