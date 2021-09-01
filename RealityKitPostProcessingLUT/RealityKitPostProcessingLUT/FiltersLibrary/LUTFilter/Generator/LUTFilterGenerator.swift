//
//  LUTFilterGenerator.swift
//  LUTFilterGenerator
//
//  Created by Artyom Mihailovich on 9/1/21.
//

import CoreImage

final class LUTFilterGenerator: NSObject {
    
    static let sharedInstance = LUTFilterGenerator()
    
    override init() {
        super.init()
    }
    
    private(set) lazy var metallibData: Data? = {
        guard let url = Bundle.main.url(forResource: "LUT", withExtension: "ci.metallib") else {
            return nil
        }
        let data = try? Data(contentsOf: url)
        return data
    }()
}

