//
//  JWTGenerator.swift
//  Services
//
//  Created by hyerin on 9/10/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import SwiftJWT

public final class JWTGenerator {
  
  private init() {}
  
  public static var shared = JWTGenerator()

  public func makeJWT() -> String{
      let myHeader = Header(kid: "9RWQTM6LCY") //sign in with
      struct MyClaims: Claims {
          let iss: String
          let iat: Int
          let exp: Int
          let aud: String
          let sub: String
      }

      let nowDate = Date()
      var dateComponent = DateComponents()
      dateComponent.month = 6
      let sixDate = Calendar.current.date(byAdding: dateComponent, to: nowDate) ?? Date()
      let iat = Int(Date().timeIntervalSince1970)
      let exp = iat + 3600
      let myClaims = MyClaims(iss: "MYR6MP3VKX",
                              iat: iat,
                              exp: exp,
                              aud: "https://appleid.apple.com",
                              sub: "com.mashup.gabbangzip")

      var myJWT = JWT(header: myHeader, claims: myClaims)

    guard let url = Bundle(for: JWTGenerator.self).url(forResource: "AuthKey_9RWQTM6LCY", withExtension: "p8") else {
      return ""
    }
      let privateKey: Data? = try? Data(contentsOf: url, options: .alwaysMapped)

    if let privateKey {
      let jwtSigner = JWTSigner.es256(privateKey: privateKey)
      let signedJWT = try? myJWT.sign(using: jwtSigner)

      print("🗝 singedJWT - \(signedJWT)")
      return signedJWT ?? ""
    } else {
      return ""
    }
  }
}
