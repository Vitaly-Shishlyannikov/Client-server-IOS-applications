//
//  CachePictures.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 10.09.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import Foundation
import Alamofire

class PhotoService {
    
    private let cacheLifeTime : TimeInterval = 30 * 24 * 60 * 60
    
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return pathName}
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    private func getFilePath(url: String) -> String? {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        
        let hasheName = String(describing: url.hashValue)
        
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hasheName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        
        guard let fileName = getFilePath(url: url) else { return }
        
        let data = image.pngData()
        
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        
        guard   let fileName = getFilePath(url: url),
                let info = try? FileManager.default.attributesOfItem(atPath: fileName),
                let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else {return nil}
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName)
        else {return nil}
        
        images[url] = image
        
        return image
    }
    
    private var images = [String : UIImage]()
    
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        
        Alamofire.request(url).responseData(queue: DispatchQueue.global()) { [weak self] response in
            
            guard   let data = response.data,
                    let image = UIImage(data: data) else {return}
            
            self?.images[url] = image
            self?.saveImageToCache(url: url, image: image)
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexPath: indexPath)
            }
        }
    }
    
    func photo(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        
        var image: UIImage?
        
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        
        return image
    }
    
    private let container: DataReloable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
}

fileprivate protocol DataReloable {
    func reloadRow(atIndexPath indexpath: IndexPath)
}

extension PhotoService {

    private class Table: DataReloable {
        
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexPath indexpath: IndexPath) {
            table.reloadRows(at: [indexpath], with: .none)
        }
    }

    private class Collection: DataReloable {
        
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexPath indexpath: IndexPath) {
            collection.reloadItems(at: [indexpath])
        }
    }
}

