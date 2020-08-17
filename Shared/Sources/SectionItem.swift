// Copyright © 2020 Itty Bitty Apps. All rights reserved.

import Foundation

protocol SectionItem: Decodable {
  associatedtype Item

  var title: String? { get set }
  var rows: [Item] { get set }
}
