//
//  ContentView.swift
//  Shared
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI
import CoreData
import Prometheus

import Firebase
import FirebaseAuth
import Helena


struct ContentView: View {
    
    @State var uid: String?
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        
        if let uid = uid {
            HomeView(viewModel: AnyViewModel(HomeViewModel(stationsService: FirestoreChargingStationsService(currentUserID: uid))))
            // TODO: create project & do add google-plist to .gitignore
        } else {
            VStack {
                Text("Login").helenaFont(type: .title)
                HelenaTextField("Email", text: $email, isSecure: false, isLarge: true)
                HelenaTextField("Password", text: $password, isSecure: true, isLarge: true)
                HelenaButton(text: "Login") {
                    Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error  in
                        self.uid = authResult?.user.uid
                    }
                }
            }.padding()
            .onAppear {
                if let uid = Auth.auth().currentUser?.uid {
                    self.uid = uid
                }
            }
        }
        
    }
    
}

/*struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()*/

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
