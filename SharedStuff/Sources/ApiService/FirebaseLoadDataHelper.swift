//
//  FirebaseLoadDataHelper.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 05.05.2023.
//

import SwiftUI
import Combine
//import FirebaseStorage

public class FirebaseLoadDataHelper {
    struct StubCancellable: Cancellable {
        func cancel() {
        }
    }

    enum FirebaseLoadDataHelperError: Error {
        case emptyDataFromService
    }

    public static func fetchData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable {
        DispatchQueue.main.async {
            completion(.failure(FirebaseLoadDataHelperError.emptyDataFromService))
        }
        return StubCancellable()
    }
}

//extension StorageDownloadTask: Cancellable { }
