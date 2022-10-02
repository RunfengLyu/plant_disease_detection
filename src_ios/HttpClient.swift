//
//  HttpClient.swift
//  Chloris.AI
//
//  Created by Mathias Tahas on 30.09.22.
//

import NIO
import AsyncHTTPClient
import UIKit

let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)

let jsonDecoder = JSONDecoder()

func uploadImage(image: UIImage, entity: Entity) async -> [String: Double] {
    let url = entity == .Tomato ? azureTomatoUrl : azureCocoaUrl
    let authKey = entity == .Tomato ? azureTomatoKey : azureCocoaKey
    
    var request = HTTPClientRequest(url: url)
    request.method = .POST
    request.headers.add(name: "Authorization", value: "Bearer \(authKey)")
    let data = [UInt8](image.jpegData(compressionQuality: 1.0)!.base64EncodedString().utf8)
    request.body = .bytes(data)
    
    let response = try! await httpClient.execute(request, timeout: .seconds(30))
    if response.status == .ok {
        let data = try! await response.body.collect(upTo: 1024 * 1024)
        let text = String(buffer: data).replacingOccurrences(of: "\\", with: "").dropFirst().dropLast()
        return try! jsonDecoder.decode([String:String].self, from: ByteBuffer(substring: text)).mapValues { Double($0)! }
    } else {
        fatalError("Server")
    }
}
