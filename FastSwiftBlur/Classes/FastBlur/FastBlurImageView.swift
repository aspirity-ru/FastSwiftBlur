//
// Created by Maxim on 07/05/2018.
// Copyright (c) 2018 Aspirity. All rights reserved.
//

import UIKit

/*
* Customized UIImageView for blur method
*/
public class FastBlurImageView: UIImageView {

    // --
    static let ANIMATION_DURATION = 1.0

    // --
    fileprivate var originalImage: UIImage?
    fileprivate var blurWorker: FastBlurWorker?

    // --
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        originalImage = image
    }

    // MARK: public properties

    public override var image: UIImage? {
        didSet {
            originalImage = image
            blurAndSetImage()
        }
    }

    public var blurRadius: Float = 0 {
        didSet {
            if blurRadius != oldValue {
                blurAndSetImage()
            }
        }
    }

    // --

    /*
    * Run blur process and change image with transition
    */
    private func blurAndSetImage() {
        guard blurRadius > 0 else {
            return
        }
        if blurWorker == nil, let originalImage = originalImage {
            blurWorker = FastBlurWorker(image: originalImage)
        }
        FastBlurManager.renderBlur(for: blurWorker, with: self, radius: blurRadius,
                callback: { [weak self] blurredImage in
                    self?.layer.removeAllAnimations()

                    guard let strongSelf = self, let blurredImage = blurredImage else {
                        self?.setImage(image: nil)
                        return
                    }

                    UIView.transition(with: strongSelf,
                            duration: FastBlurImageView.ANIMATION_DURATION,
                            options: [.transitionCrossDissolve, .allowUserInteraction],
                            animations: { [weak self] () in
                                self?.setImage(image: blurredImage)
                            },
                            completion: nil)
                })
    }

    fileprivate func setImage(image: UIImage?) {
        super.image = image
    }

}
