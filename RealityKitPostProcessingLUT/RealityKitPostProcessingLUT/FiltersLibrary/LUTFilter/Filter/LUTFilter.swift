//
//  LUTFilter.swift
//  LUTFilter
//
//  Created by Artyom Mihailovich on 9/1/21.
//

import CoreImage

final class LUTFilter: CIFilter {
    
    @objc
    private var inputImage: CIImage?
    
    @objc
    private let lookupImage: CIImage
    
    private static var kernel: CIKernel? = {
        do {
            guard let data = LUTFilterGenerator.sharedInstance.metallibData else { return nil }
            let kernel = try CIKernel(functionName: "lut", fromMetalLibraryData: data)
            return kernel
        } catch { return nil }
    }()
    
    init(lookupImage: CIImage) {
        self.lookupImage = lookupImage
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage,
              let kernel = LUTFilter.kernel else  { return nil }
        
        return kernel.apply(extent: inputImage.extent, roiCallback: { $1 }, arguments: [inputImage, lookupImage])
    }
}
