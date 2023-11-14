//
//  UserSession.swift
//  TODORI
//
//  Created by Dasol on 2023/05/17.
//

import UIKit

class UserSession {
    static let shared = UserSession()
    
    private init() {}
 
    var signUpEmail: String?
    var signUpNickname: String?
    
    var image: Data?
    var isChangedImage: Bool?
    
    func imageToBase64String(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
    
    func base64StringToImage(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
}
