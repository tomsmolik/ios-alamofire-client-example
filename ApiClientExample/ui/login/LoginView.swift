import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject var vm = LoginViewModel()
    
    @State var startAnimate = false
 
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer()
           
                Image(systemName: "s.circle")
                    .resizable()
                    .foregroundColor(Color.white)
                    .frame(width: 75, height: 75)
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
           
                // MARK: Login header
                HStack {
                    VStack(alignment: .leading, spacing: 12, content: {
                        Text("Sign In")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("To continue, please log in")
                            .foregroundColor(Color.white.opacity(0.9))
                    })
                    Spacer()
                }
                .padding()
                .padding(.leading, 16)
                
                // MARK: Username
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    CustomTextField(
                        placeholder: Text("Username")
                            .foregroundColor(Color.white.opacity(0.4)),
                        text: $vm.username
                    )
                }
                .padding()
                .background(Color.white.opacity(vm.username.isEmpty ? 0.20 : 0.40))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // MARK: Password
                HStack {
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    CustomSecuredTextField(
                        placeholder: Text("Password")
                            .foregroundColor(Color.white.opacity(0.4)),
                        text: $vm.password
                    )
                }
                .padding()
                .background(Color.white.opacity(vm.password.isEmpty ? 0.20 : 0.40))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top)
                .alert(isPresented: $vm.alert, content: {
                    Alert(
                        title: Text("Alert"),
                        message: Text(vm.alertMsg)
                    )
                })
                
                // MARK: Login button
                HStack(spacing: 15) {
                    Button(action: authenticate, label: {
                        Text("LOGIN")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 150)
                            .background(Color.white)
                            .clipShape(Capsule())
                    })
                        .opacity(!vm.username.isEmpty && !vm.password.isEmpty ? 1 : 0.4)
                        .disabled(!vm.username.isEmpty && !vm.password.isEmpty ? false : true)
                }
                .padding()
                
                Spacer()
            }
            .animation(startAnimate ? .easeOut : .none)
      
            if vm.isLoading {
                LoadingView()
            }
        }
    }
    
    private func authenticate() {
        self.vm.authenticate()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
