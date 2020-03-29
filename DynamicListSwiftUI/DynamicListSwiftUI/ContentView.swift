//
//  ContentView.swift
//  DynamicListSwiftUI
//
//  Created by Tran Van Hung on 3/29/20.
//  Copyright © 2020 hungtv. All rights reserved.
//

import SwiftUI

struct User : Identifiable {
    var id:Int
    let username, message, iconName: String
}

// Model
struct Person: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let image: UIImage
    let jobTitle: String
}

struct ContentView: View {
    
    @State var people: [Person] = [
        .init(firstName: "Steve", lastName: "Jobs", image: #imageLiteral(resourceName: "tim_cook"), jobTitle: "Founder of Apple"),
        .init(firstName: "Tim", lastName: "Cook", image: #imageLiteral(resourceName: "tim_cook"), jobTitle: "Apple CEO"),
        .init(firstName: "Jony", lastName: "Ive", image: #imageLiteral(resourceName: "tim_cook"), jobTitle: "Head of Desig nce cewcvbb r rer er re ert ert ert er ert ret er er reter r re")
    ]
    
    let users: [User] = [
        .init(id: 1, username: "hungtv64", message: "toi dang o nha hoc swift", iconName: "tim_cook"),
        .init(id: 2, username: "hungtv64", message: "toi dang o nha hoc swift", iconName: "tim_cook"),
        .init(id: 3, username: "hungtv64", message: "toi dang o nha hoc swift", iconName: "tim_cook"),
        .init(id: 4, username: "hungtv64", message: "toi dang o nha hoc swift", iconName: "tim_cook"),
        .init(id: 5, username: "hungtv64", message: "toi dang o nha hoc swiftb fdgdfgf fg dfg dfg dfgdfg dfgdfg dfg dfg df df fd fdg dfg df df d", iconName: "tim_cook")
    ]
        
    @State var isPresentingAddModal = false
    
    var body: some View {
        NavigationView {
            List(people) { person in
                PersonRow(person: person, didDelete: { p in
                    self.people.removeAll(where: {$0.id == person.id})
                })
            }.navigationBarTitle("People")
                .navigationBarItems(trailing: Button(action: {
                    self.isPresentingAddModal.toggle()
                }, label: {
                    Text("Add")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.green)
                    .cornerRadius(4)
                }))
                .sheet(isPresented: $isPresentingAddModal, content: {
                    PersonForm(isPresented: self.$isPresentingAddModal, didAddPerson: { p in
                        self.people.append(p)
                    })
                })
        }
    }
}

struct PersonForm: View {
    
    @Binding var isPresented: Bool
    
    var didAddPerson: (Person) -> ()
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    @State var isShowingImagePicker = false
    
    @State var selectedImage = UIImage()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            Text("Create Person")
                .fontWeight(.heavy)
                .font(.system(size: 32))
            
            HStack {
                Spacer()
                Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 80)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1)))
                .cornerRadius(80)
                Spacer()
            }
            
            Button(action: {
                self.isShowingImagePicker.toggle()
            }, label: {
                HStack {
                    Spacer()
                    Text("Select Image")
                        .fontWeight(.bold)
                        .padding(.all, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    Spacer()
                }
                
            }).sheet(isPresented: $isShowingImagePicker, content: {
                HybridImagePickerController(imageFromPicker: self.$selectedImage)
            })
            
            HStack (spacing: 16) {
                Text("First Name")
                TextField("First Name", text: $firstName)
                    .padding(.all, 12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
            }
            HStack (spacing: 16) {
                Text("Last Name")
                TextField("Last Name", text: $lastName)
                    .padding(.all, 12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
            }
            
            Button(action: {
                let person = Person(firstName: self.firstName, lastName: self.lastName, image: self.selectedImage, jobTitle: "")
                self.didAddPerson(person)
                self.isPresented = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Add")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
            })
            .background(Color.green)
            .cornerRadius(4)
            
            Button(action: {
                self.isPresented = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
            })
            .background(Color.red)
            .cornerRadius(4)
            
            Spacer()
            
        }.padding(.all, 20)
        
    }
}

struct HybridImagePickerController: UIViewControllerRepresentable {
    
    @Binding var imageFromPicker: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<HybridImagePickerController>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func makeCoordinator() -> HybridImagePickerController.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: HybridImagePickerController
        
        init(_ parent: HybridImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let selectedImage = info[.originalImage] as! UIImage
            parent.imageFromPicker = selectedImage
            picker.dismiss(animated: true)
        }
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<HybridImagePickerController>) {
        
    }
    
}

struct PersonRow: View {
    
    var person: Person
    var didDelete: (Person) -> ()
    
    var body: some View {
        HStack {
            Image(uiImage: person.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 60)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(Color.black))
                .cornerRadius(60)
            
            VStack (alignment: .leading) {
                Text("\(person.firstName) \(person.lastName)")
                    .fontWeight(.bold)
                Text(person.jobTitle)
                    .fontWeight(.light)
            }.layoutPriority(1)
            
            Spacer()
            
            Button(action: {
                self.didDelete(self.person)
            }, label: {
                Text("Delete")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.all, 12)
                    .background(Color.red)
                    .cornerRadius(3)
            })
            
        }.padding(.vertical, 8)
    }
}

struct UserRow: View {
    let user: User
    var body: some View {
        HStack {
            Image(user.iconName)
                .resizable().clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .frame(width: 70, height: 70)
                .clipped()
            VStack (alignment: .leading) {
                Text(user.username).font(.headline)
                Text(user.message).font(.subheadline).lineLimit(nil)
            }.padding(.leading, 8)
        }.padding(.init(top: 10, leading: 0, bottom: 12, trailing: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
