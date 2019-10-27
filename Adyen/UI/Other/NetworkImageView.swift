//
// Copyright (c) 2019 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import UIKit

/// An image view that displays images from a remote location.
/// :nodoc:
open class NetworkImageView: UIImageView {
    
    public var imageLoader: ImageLoader? = DefaultImageLoader(executer: URLSession.shared)
    
    /// The URL of the image to display.
    public var imageURL: URL? {
        didSet {
            guard imageURL != oldValue else { return }
            imageLoader?.reset()
            image = nil
            loadImageIfNeeded()
        }
    }
    
    /// :nodoc:
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        loadImageIfNeeded()
    }
    
    // MARK: - Private
    
    // If we have an image URL and are embedded in a window, load the image if we aren't already.
    public func loadImageIfNeeded() {
        guard let imageURL = imageURL, window != nil else { return }
        imageLoader?.loadImage(from: imageURL) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func cancelCurrentTask() {
        imageLoader?.reset()
    }
    
}
