//___FILEHEADER___

import ComposableArchitecture
import SwiftUI

public struct ___FILEBASENAMEASIDENTIFIER___: View {
  let store: StoreOf<___VARIABLE_productName:identifier___Core>

  public init(store: StoreOf<___VARIABLE_productName:identifier___Core>) {
    self.store = store
  }

  public var body: some View {
    Text("Hello, World!")
  }
}

#Preview {
  ___FILEBASENAMEASIDENTIFIER___(
    store: Store(initialState: .init()) {
      ___VARIABLE_productName:identifier___Core()
    }
  )
}
