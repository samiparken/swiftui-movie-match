//
//  String+Ext.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-05-19.
//

import Foundation

extension String {
  //MARK: - Apply
    func toImageUrl() -> String {
      return K.API.imageUrlPrefix_w500 + self
    }
}
