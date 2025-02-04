//
//  LandscapeView.swift
//  Calculator
//
//  Created by znexie on 1.02.25.
//

import SwiftUI

struct LandscapeView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 20) {
            PortraitView() // Можно оставить тот же калькулятор или изменить
            VStack {
                Text("Дополнительные кнопки в ландшафтном режиме")
                    .font(.title)
                    .padding()

                Button("Настройки") {
                    print("Открыть настройки")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("История") {
                    print("Открыть историю")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    LandscapeView()
}
