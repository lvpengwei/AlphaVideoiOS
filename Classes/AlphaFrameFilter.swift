//
//  AlphaFrameFilter.swift
//  AlphaVideoiOSDemo
//
//  Created by lvpengwei on 2019/5/26.
//  Copyright © 2019 lvpengwei. All rights reserved.
//

import CoreImage

class AlphaFrameFilter: CIFilter {
    static var kernel: CIColorKernel? = {
        return CIColorKernel(source: """
kernel vec4 alphaFrame(__sample s, __sample m) {
  return vec4(s.rgb, m.r);
}
""")
    }()
    
    var inputImage: CIImage?
    var maskImage: CIImage?
    
    override var outputImage: CIImage? {
        let kernel = AlphaFrameFilter.kernel!
        guard let inputImage = inputImage, let maskImage = maskImage else {
            return nil
        }
        let args = [inputImage as AnyObject, maskImage as AnyObject]
        return kernel.apply(extent: inputImage.extent, arguments: args)
    }
}
