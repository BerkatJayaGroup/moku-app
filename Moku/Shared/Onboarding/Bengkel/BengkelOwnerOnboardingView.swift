//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI

struct BengkelOwnerOnboardingView: View {
    @StateObject var viewModel = ViewModel()

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().sectionFooterHeight = 0
    }

    var body: some View {
        VStack {
            Form {
                textField(title: "NAMA PEMILIK", placeholder: "Tulis namamu disini", text: $viewModel.ownerName, alert: "Nama Wajib Diisi")
                textField(title: "NAMA BENGKEL", placeholder: "Tulis nama bengkelmu disini", text: $viewModel.bengkelName, alert: "Nama Bengkel Wajib Diisi")

                locationField()

                textField(title: "NOMOR TELEPON BENGKEL", placeholder: "08xx-xxxx-xxxx", text: $viewModel.phoneNumber, alert: "Nomor Telepon Wajib Diisi", keyboardType: .numberPad)

                Section(header: header(title: "FOTO BENGKEL")) {
                    // UI IMAGE PICKER
                }
            }

            submitButton()
        }
        .sheet(isPresented: $viewModel.isSelectingLocation) {
            LocationSearchView(onSelect: viewModel.updateLocation).sheetStyle()
        }
        .navigationBarTitle("Profil Bengkel", displayMode: .inline)
    }
}

struct BengkelOwnerOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BengkelOwnerOnboardingView()
    }
}

// MARK: - View Components
extension BengkelOwnerOnboardingView {
    func header(title: String) -> some View {
        Text(title).headerStyle()
    }

    @ViewBuilder
    private func submitButton() -> some View {
        NavigationLink(destination: PengaturanBengkel(), isActive: $viewModel.isSettingDetail) { EmptyView() }

        Button {
            viewModel.openBengkelSetting()
        } label: {
            HStack {
                Spacer()
                Text("Lanjutkan")
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(AppColor.primaryColor)
            .cornerRadius(8)
        }
        .padding()
        .padding(.horizontal, 32)
    }

    private func locationField() -> some View {
        Section(header: header(title: "ALAMAT")) {
            VStack(alignment: .trailing) {
                HStack {
                    Button {
                        viewModel.selectLocation()
                    } label: {
                        if let address = viewModel.address {
                            Text(address).foregroundColor(.primary)
                        } else {
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text("Cari alamat bengkelmu disini")
                            }.foregroundColor(.tertiaryLabel)
                        }
                    }
                    Spacer()
                }.modifier(RoundedTextField())
                // Alert
                locationAlert()
            }
        }
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        alert: String,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        Section(header: header(title: title)) {
            VStack(alignment: .trailing) {
                TextField(placeholder, text: text).roundedStyle().keyboardType(keyboardType)
                emptyAlert(for: text, alert: alert)
            }
        }
    }

    @ViewBuilder
    private func locationAlert() -> some View {
        if viewModel.location == nil, viewModel.isSubmitting {
            Text("Alamat Wajib Diisi").alertStyle()
        }
    }

    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, viewModel.isSubmitting {
            Text(alert).alertStyle()
        }
    }
}
