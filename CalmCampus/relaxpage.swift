//
//  relaxpage.swift
//  sample2
//
//  Created by Harshal Dhaduk on 9/18/23.
//

import SwiftUI

struct relaxpage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Meditation & Relaxation")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    MeditationSessionView()
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    RelaxationSessionView()
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Text("Featured Articles")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ArticlesScrollView()
                        .padding(.horizontal)
                }
            }
            .navigationBarTitle("Mindfulness App")
        }
    }
}

struct MeditationAppView_Previews: PreviewProvider {
    static var previews: some View {
        relaxpage()
    }
}


struct MeditationSessionView: View {
    var body: some View {
        VStack {
            Text("Meditation Sessions")
                .font(.headline)
                .padding(.top, 10)
            
            // Placeholder for meditation sessions
            Text("Add your meditation content here.")
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct RelaxationSessionView: View {
    var body: some View {
        VStack {
            Text("Relaxation Sessions")
                .font(.headline)
                .padding(.top, 10)
            
            // Placeholder for relaxation sessions
            Text("Add your relaxation content here.")
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ArticlesScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Placeholder for articles
                ForEach(0..<5) { index in
                    ArticleCardView()
                }
            }
            .padding()
        }
    }
}

struct ArticleCardView: View {
    var body: some View {
        VStack {
            Text("Article Title")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(10)
            
            // Placeholder for article content
            Text("Add article content here.")
                .foregroundColor(.gray)
                .padding(.horizontal)
                .lineLimit(2) // Adjust as needed
        }
        .frame(width: 150, height: 200) // Adjust card dimensions
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

