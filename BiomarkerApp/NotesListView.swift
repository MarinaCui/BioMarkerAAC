import SwiftUI

struct NotesListView: View {
    
    @State private var isShowingEditor = false
    
    @State private var showShareSheet = false // State for sharing
   

    var body: some View {
        NavigationView {
            List {
                
            }
            .listStyle(PlainListStyle())
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Conversations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Create a new conversation when "+" is tapped
                        let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .medium
                            dateFormatter.timeStyle = .short

                        let currentDateTime = dateFormatter.string(from: Date())
                        // Add the new conversation to the list
                        isShowingEditor = true // Show the editor
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
                // Export Button
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: exportConversations) {
                                    Text("Export")
                                        .foregroundColor(.blue)
                                }
                            }
            }
            .sheet(isPresented: $isShowingEditor) {
                // Pass the new conversation as a parent to the NoteEditorView
                
            }
        }
        .onAppear {
            // Load the conversations when the view appears
            
        }
        .sheet(isPresented: $showShareSheet) {
                    
                }

    }

    private func deleteConversation(at offsets: IndexSet) {
       
    }
//    private func exportConversations() {
//            if let fileURL = dataManager.exportConversationsToJSON(conversations: conversations) {
//                print("Conversations exported to \(fileURL.path)")
//                // Optionally, you can show an alert to the user with the file path or open the file in a different app.
//            } else {
//                print("Failed to export conversations.")
//            }
//        }
    private func exportConversations() {
           // Trigger the ShareSheet to show
           showShareSheet = true
       }
}
