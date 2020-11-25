//
//  DetailView.swift
//  Bookworm
//
//  Created by Amber Spadafora on 11/24/20.
//  Copyright © 2020 Amber Spadafora. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    let book: Book
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ??  "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.author ?? "Unknown")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")
                .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                .font(.largeTitle)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: {
                    self.deleteBook()
                }), secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }, label: {
            Image(systemName: "trash")
        }))
    }
    
    func deleteBook() {
        moc.delete(book)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test title"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Good"
        return NavigationView {
            DetailView(book: book)
        }
    }
}
