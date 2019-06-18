//
//  ContentView.swift
//  FormExample
//
//  Created by Edwin Bosire on 18/06/2019.
//  Copyright © 2019 Edwin Bosire. All rights reserved.
//
import Combine
import SwiftUI

struct ContentView : View {
    @ObjectBinding var order = Order()
    @State var showingConfirmation = false
    @State var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $order.type, label: Text("Select your cake type")) {
                        ForEach(0 ..< Order.types.count) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                        }
                }
                
                Section {
                    Toggle(isOn: $order.specialRequest) {
                        Text("Any Special Requests?")
                    }
                    
                    if order.specialRequest {
                        Toggle(isOn: $order.addSprinkles) {
                            Text("Add Sprinkles")
                        }
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add Extra Frosting")
                        }
                    }
                }
                
                Section {
                    TextField($order.name, placeholder: Text("Name"))
                    TextField($order.city, placeholder: Text("City"))
                    TextField($order.postcode, placeholder: Text("Post Code"))
                }
                
                Section {
                    Button(action: { self.placeOrder(self.order) }) {
                        Text("Place Order")
                    }.disabled(!order.isValid)
                }
                }
                .navigationBarTitle(Text("Cupcake Corner"))
            }.presentation($showingConfirmation) {
                Alert(title: Text("Order"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
        }
        }
        
    
    
func placeOrder(_ order: Order) {
        print("Order placed")
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data in response \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertMessage = "Order was made"
                self.showingConfirmation = true
            } else {
                self.alertMessage = String(decoding: data, as: UTF8.self)
                self.showingConfirmation = true
            }
            
        }.resume()
    }
}


class Order: BindableObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case  type, quantity, specialRequest, extraFrosting, addSprinkles, name, city, postcode
    }
    var didChange = PassthroughSubject<Void, Never>()
    
    static var types = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    var type = 0 { didSet { update() }}
    var quantity = 3 { didSet { update() }}
    
    var specialRequest = false { didSet { update() }}
    var extraFrosting = false { didSet{ update() }}
    var addSprinkles = false { didSet{ update() }}
    
    var name = "" { didSet{ update() }}
    var city = "" { didSet{ update() }}
    var postcode = "" { didSet{ update() }}
    
    var isValid: Bool {
        if name.isEmpty || city.isEmpty || postcode.isEmpty {
            return false
        }
        return true
    }
    func update() {
        didChange.send(())
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
