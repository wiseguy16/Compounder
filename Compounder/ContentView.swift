//
//  ContentView.swift
//  Compounder
//
//  Created by Gregory Weiss on 12/7/22.
//

import SwiftUI

struct ContentViewContainer: View {
    var body: some View {
        CompoundView()
        .modifyWhiteNavbar()
    }
}

struct ContentViewContainer_Previews: PreviewProvider {
    static var previews: some View {
      ContentViewContainer()
    }
}
