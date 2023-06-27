//
//  CatListView.swift
//  CatsAndModules_SerhiiHryhorenko
//
//  Created by Serhii Hryhorenko on 23.05.2023.
//

import SwiftUI
import CatApiClient
import FirebaseCrashlytics
import FirebasePerformance

struct CatListView: View {
    @State private var cats: [Cat] = []
    @State private var expandedCat: Cat? = nil
    @State private var isLoading = false
    
    let client = CatClient()
    
    var body: some View {
        VStack {
            Button("Crash") {
                fatalError("Crash was triggered")
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Button("Get new cats") {
                    fetchCats()
                }
            }
            
            List(cats) { cat in
                CatRowView(cat: cat)
            }.onAppear {
                fetchCats()
            }
        }
    }
    
    private func fetchCats() {
        let networkTrace = Performance.startTrace(name: "FetchCats")
        
        Task.init {
            defer {
                networkTrace?.stop()
                isLoading.toggle()
            }
            
            do {
                isLoading.toggle()
                
                let fetchedCats = try await client.getCats(quantity: 10)
                
                DispatchQueue.main.async {
                    cats = fetchedCats
                }
            } catch {
                print("Fetching cats error: \(error)")
            }
        }
    }
}

struct CatRowView: View {
    let cat: Cat
    @State private var isExpanded = false
    
    var body: some View {
        HStack {
            Image(uiImage: cat.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    Crashlytics.crashlytics().setCustomValue(cat.id, forKey: "CatTapped")
                    Crashlytics.crashlytics().log("User tapped on \(cat.id) cat")
                    
                    isExpanded.toggle()
                 }
                .fullScreenCover(isPresented: $isExpanded) {
                    FullScreenImageView(image: cat.image)
                }
        }
    }
}
