//
//  FullScreenImageView.swift
//  CatsAndModules_SerhiiHryhorenko
//
//  Created by Serhii Hryhorenko on 30.05.2023.
//

import SwiftUI

struct FullScreenImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                dismissFullScreen()
            }
    }
    
    private func dismissFullScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.dismiss(animated: true, completion: nil)
            }    }
}
