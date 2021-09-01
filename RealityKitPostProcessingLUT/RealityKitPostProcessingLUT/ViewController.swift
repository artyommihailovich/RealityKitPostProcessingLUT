//
//  ViewController.swift
//  RealityKitPostProcessingLUT
//
//  Created by Artyom Mihailovich on 8/27/21.
//

import UIKit
import RealityKit

final class ViewController: UIViewController {
    
    private lazy var arView = ARView().do {
        $0.frame = view.bounds
    }
    
    private var context: CIContext?
    private var device: MTLDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        postEffect(arView: arView)
    }
    
    private func setupSubview() {
        view.addSubview(arView)
    }
    
    private func postEffect(arView: ARView) {
        arView.renderCallbacks.prepareWithDevice = { [weak self] device in
            guard let self = self else { return }
            self.prepareWithDevice(device)
        }
        arView.renderCallbacks.postProcess = { [weak self] context in
            guard let self = self else { return }
            self.postProcess(context)
        }
    }
    
    private func prepareWithDevice(_ device: MTLDevice) {
        self.context = CIContext(mtlDevice: device)
        self.device = device
    }
    
    private func postProcess(_ context: ARView.PostProcessContext) {
        filter(context)
    }
    
    private func filter(_ context: ARView.PostProcessContext) {
        guard let inputImage = CIImage(mtlTexture: context.sourceColorTexture),
              let lookupImage = UIImage(named: "WellSeeLUT") else
        { return }
        
        let filter = LUTFilter(lookupImage: CIImage(image: lookupImage) ?? CIImage())
        filter.setValue(inputImage, forKey: "inputImage")
        
        let destination = CIRenderDestination(mtlTexture: context.targetColorTexture,
                                              commandBuffer: context.commandBuffer)
        destination.isFlipped = false
        
        _ = try? self.context?.startTask(toRender: filter.outputImage ?? CIImage(), to: destination)
    }
}
