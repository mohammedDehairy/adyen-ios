//
//  ImageLoader.swift
//  Adyen
//
//  Created by mohamed mohamed El Dehairy on 10/27/19.
//  Copyright © 2019 Adyen. All rights reserved.
//

import Foundation

public protocol ImageLoader {
    func loadImage(from url: URL, completion: @escaping (_ image: UIImage?) -> Void)
    func reset()
}

public final class DefaultImageLoader: ImageLoader {
    private var image: UIImage?
    private var dataTask: Cancelable?
    private var waitingList: [((_ image: UIImage?) -> Void)] = []
    
    private let executer: URLRequestExecuter
    
    init(executer: URLRequestExecuter) {
        self.executer = executer
    }
    
    public func loadImage(from url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        assert(Thread.isMainThread)
        waitingList.append(completion)
        guard waitingList.count == 1 else { return }
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        if let image = image {
            deliverImage(image: image)
            return
        }
        dataTask = executer.execute(request: URLRequest(url: url)) { data, response, error in
            guard
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data, scale: 1.0)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.deliverImage(image: image)
                self.dataTask = nil
            }
        }
    }
    
    private func deliverImage(image: UIImage) {
        waitingList.forEach { $0(image) }
        waitingList = []
    }
    
    public func reset() {
        dataTask?.cancel()
        waitingList = []
        image = nil
    }
}
