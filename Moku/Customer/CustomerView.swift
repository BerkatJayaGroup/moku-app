//
//  CustomerView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI

struct CustomerView: View {
    @State var customer: Customer

    init(for customer: Customer) {
        _customer = State(wrappedValue: customer)
    }

    var body: some View {
        Text("\(customer.name) - \(customer.motors?.count ?? 0)")
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView(for: .preview)
    }
}
