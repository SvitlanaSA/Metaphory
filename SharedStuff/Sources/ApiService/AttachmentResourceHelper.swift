//
//  AttachmentResourceHelper.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 14.12.2023.
//

import UIKit
import Combine

public enum CDFrontImageAttachmentRequestError: Error {
    case loadImageError(Error)
    case invalidDowloadedData
    case absentBundleResource
}

public protocol AttachmentResourceHelperProtocol {
    typealias CompletionInput<ErrorType: Error> = Result<UIImage, ErrorType>
    typealias CompletionHandler<ErrorType: Error> = (CompletionInput<ErrorType>) -> Void
    
    func needFetchResource(for attachment: CDFrontImageAttachment) -> Bool
    func fetchResource(for attachment: CDFrontImageAttachment, completion: @escaping CompletionHandler<CDFrontImageAttachmentRequestError>) -> Cancellable?
    func storedResource(for attachment: CDFrontImageAttachment) -> UIImage?
}

public struct AttachmentResourceHelper: AttachmentResourceHelperProtocol {
    public init() { }
    
    public func needFetchResource(for attachment: CDFrontImageAttachment) -> Bool {
        guard let remoteValue = attachment.cdRemoteValue else { return false }
        return !remoteValue.isEmpty && nil == attachment.cdImageData
    }
    
    public func fetchResource(for attachment: CDFrontImageAttachment, completion: @escaping CompletionHandler<CDFrontImageAttachmentRequestError>) -> Cancellable? {
        if !needFetchResource(for: attachment) {
            var completionResult: CompletionInput = .failure(CDFrontImageAttachmentRequestError.absentBundleResource)
            defer {
                completion(completionResult)
            }
            guard let image = storedResource(for: attachment) else {
                return nil
            }
            completionResult = .success(image)
            return nil
        } else {
            guard let link = attachment.cdRemoteValue else { return nil }
            return FirebaseLoadDataHelper.fetchData(urlString: link) { loadImageResult in
                var completionResult: CompletionInput = .failure(CDFrontImageAttachmentRequestError.absentBundleResource)
                switch loadImageResult {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        cache(data: data, for: attachment)
                        completionResult = .success(image)
                    } else {
                        completionResult = .failure(.invalidDowloadedData)
                    }
                case .failure(let error):
                    completionResult = .failure(.loadImageError(error))
                }
                
                DispatchQueue.main.async {
                    completion(completionResult)
                }
            }
        }
    }
    
    public func storedResource(for attachment: CDFrontImageAttachment) -> UIImage? {
        var result: UIImage?
        if let imageData = attachment.cdImageData {
            result = UIImage(data: imageData)
        } else if let imageName = attachment.cdImageName {
            result = UIImage.proper(named: imageName)
        } else if let imageName = attachment.cdImageThumbnailName {
            result = UIImage.proper(named: imageName)
        }

        return result
    }
    
    // MARK: - Private methods
    
    private func cache(data: Data, for attachment: CDFrontImageAttachment) {
        attachment.cdImageData = data
    }
}

public struct StubAttachmentResourceHelper: AttachmentResourceHelperProtocol {
    public init() { }

    public func needFetchResource(for attachment: CDFrontImageAttachment) -> Bool {
        false
    }
    
    public func fetchResource(for attachment: CDFrontImageAttachment, completion: @escaping CompletionHandler<CDFrontImageAttachmentRequestError>) -> Cancellable? {
        DispatchQueue.main.async {
            guard let image = storedResource(for: attachment) else {
                completion(.failure(.absentBundleResource))
                return
            }
            completion(.success(image))
        }
        return nil
    }
    
    public func storedResource(for attachment: CDFrontImageAttachment) -> UIImage? {
        let imageName = attachment.cdImageName ?? attachment.cdImageThumbnailName ?? "backgroundCard"
        return UIImage.proper(named: imageName)
    }
}
