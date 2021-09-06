//
//  EditUserView.swift
//  EditUserView
//
//  Created by Ismatulla Mansurov on 8/24/21.
//

import SwiftUI
import Combine
import FirebaseAuth

struct EditUserView: View {
    
    @State private var changeEmail: String = ""
    @State private var changePassword: String = ""
    @State private var changePasswordMatch: String = ""
    @State private var changeName: String = ""
    @State private var changeHeight: Double = 0
    @State private var changeWeight: String = ""
    @State private var changeGender: String = ""
    @State private var borderColor: Color = Color.gray
    @State private var changeIsCoffeDrinker: Bool = false
    @State private var changeExerciseTimeAmount: Int = 0
    
    //alert
    
    @State private var alertMessage: String = ""
    @State private var isAlert: Bool = false
    
    @State private var usedUID: String = ""
    @Binding var isMetric: Bool
    @Binding var isDashboard: Bool
    @State private var  isSecureField = true
    @State private var isChangePassword: Bool = false
    @State private var isChangeEmail: Bool = false
    @EnvironmentObject var user: UserDocument
    @AppStorage ("log_status") var appleLogStatus = false
    
    var body: some View {
        VStack {
            
            ZStack{
                Text("Edit your info").font(.headline)
                    .bold()
                    .padding()
            }
            
            VStack{
                HStack {
                    Text("Change Password?")
                        .opacity(isChangeEmail ? 0 : 1)
                    Picker("Change password?", selection: $isChangePassword.animation(), content: {
                        Text("Yes") .tag(true)
                        Text("No").tag(false)
                    })
                    .fixedSize()
                    .foregroundColor(.white)
                    .pickerStyle(SegmentedPickerStyle())
                    .opacity(isChangeEmail ? 0 : 1)

                }.opacity(appleLogStatus ? 0 : 1)
                
                if isChangePassword {
                    
                    if !appleLogStatus {
                            VStack {
                                HStack {
                                    Text("Change email?")
                                    Picker("Change email?", selection: $isChangeEmail.animation(), content: {
                                        Text("Yes") .tag(true)
                                        Text("No").tag(false)
                                    })
                                    .fixedSize()
                                    .foregroundColor(.white)
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                if isChangeEmail {
                                    SATextField(tag: 1, placeholder: "E-mail", changeHandler: { (email) in
                                        self.changeEmail = email
                                    }, onCommitHandler: {
                                        print("commit handler")
                                    }, text: changeEmail)   .padding()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .keyboardType(.emailAddress)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(self.changeEmail == "" ? borderColor : Color.green, lineWidth: 2)
                                    )
                                    .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                                } else {
                                    SATextField(tag: 2, placeholder: "New password", changeHandler: {(password) in
                                        self.changePassword = password
                                    }, isSecureTextEntry: $isSecureField, onCommitHandler: {
                                        print("commit handler")
                                    })
                                    .padding()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(self.changePassword == "" ? borderColor : Color.green, lineWidth: 2)
                                    )
                                    .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                                    SATextField(tag: 3, placeholder: "repeat Password", changeHandler: { (pass) in
                                        self.changePasswordMatch = pass
                                    }, isSecureTextEntry: $isSecureField, onCommitHandler: {
                                        print("commit handler")
                                    })
                                    .padding()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(self.changePasswordMatch == "" ? borderColor : Color.green, lineWidth: 2)
                                    )
                                    .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                                }
                            }
                            .transition(.move(edge: .leading))
                        }
                    } else {
                        VStack {
                            SATextField(tag: 0, placeholder: "Name", changeHandler: { (name) in
                                self.changeName = name
                            }, onCommitHandler: {
                                print("commit handler")
                            }, text: changeName)
                            .padding()
                            .keyboardType(.default)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(self.changeName == "" ? borderColor : Color.green, lineWidth: 2)
                            )
                            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                            
                            
                            Section{
                                
                                HStack{
                                    Spacer(minLength: 15)
                                    if(changeHeight == 0){
                                        Text("Height").foregroundColor(.gray).opacity(0.6)
                                    }
                                    if !isMetric {
                                        Text("\(String(format: "%.1f", changeHeight)) '")
                                    } else {
                                        Text("\(String(format: "%.1f", changeHeight)) cm")
                                    }
                                    Menu {
                                        Button(action:{
                                            if isMetric {
                                                self.changeHeight = 0.0}
                                            isMetric = false
                                        }){
                                            Text("Imperic")
                                        }
                                        Button(action:{
                                            if !isMetric{
                                                self.changeHeight = 0.0
                                            }
                                            isMetric = true
                                        }){
                                            Text("Metric").foregroundColor(.blue)
                                        }
                                    } label: {
                                        if(isMetric == false){
                                            Text("Imperic")
                                                .foregroundColor(self.changeHeight == 0 ? borderColor : Color.green)
                                            Image(systemName: "ruler").foregroundColor(.blue)
                                        } else {
                                            Text("Metric ")
                                                .foregroundColor(self.changeHeight == 0 ? borderColor : Color.green)
                                            (Image(systemName: "ruler")).foregroundColor(.blue)
                                        }
                                    }
                                    .foregroundColor(.black)
                                    HeightPicker(metric: $isMetric, height: $changeHeight)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(self.changeHeight == 0 ? borderColor : Color.green, lineWidth: 2))
                                .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                            }
                            
                            HStack() {
                                Text("")
                                TextField("Weight", text: $changeWeight)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(changeWeight)) { newValue in
                                        let filtered = newValue.filter { "0123456789.".contains($0) }
                                        if filtered != newValue {
                                            self.changeWeight = filtered
                                        }
                                    }
                                if isMetric {
                                    Text("kg")
                                        .foregroundColor(.gray)
                                        .padding()
                                        .opacity(0.6)
                                } else {
                                    Text("lb")
                                        .foregroundColor(.gray)
                                        .padding()
                                        .opacity(0.6)
                                }
                                Spacer()
                                
                            }
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(self.changeWeight == "" ? borderColor : Color.green, lineWidth: 2))
                            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                            
                            
                            HStack {
                                Text(" ")
                                Text(String(changeExerciseTimeAmount))
                                Text("Minutes")
                                    .padding()
                                Spacer()
                                workoutPicker()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(self.changeExerciseTimeAmount == 0 ? borderColor : Color.green, lineWidth: 2))
                            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                            HStack() {
                                Toggle("Are you a coffee Drinker? ", isOn: $changeIsCoffeDrinker)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            .padding(.horizontal, UIScreen.main.bounds.size.width * 0.05)
                        }.transition(.slide)
                    }
                }
                
                Button(action: {
                    var waterIntakeCalculator: Double {
                        if isMetric {
                            return 4300.5
                        } else {
                            return 67
                        }
                    }
                    var waterIntake = ((Double(changeWeight) ?? 0) / 100) * waterIntakeCalculator
                    waterIntake += exerciseHydration()
                    let weight = Double(changeWeight) ?? 0
                    if isChangePassword {
                        if (changeEmail != "" && changePassword != "" && changePasswordMatch != "") {
                            if changePassword != changePasswordMatch {
                                borderColor = Color.red
                            } else {
                                alertMessage = user.changeCredentials(newPassword: changePassword)
                                isAlert = true
                            }
                        }
                        if isChangeEmail {
                            user.changeEmail(email: changeEmail)
                        }
                    } else {
                        if (changeHeight != 0 && changeWeight != "" ) {
                            alertMessage = 	user.changeData(userID: usedUID, name: changeName, weight: weight, height: changeHeight, isMetric: isMetric, isCoffeeDrinker: changeIsCoffeDrinker, waterIntake: waterIntake)
                            isAlert = true
                        } else {
                            self.borderColor = Color.red
                        }
                    }
                }, label: {
                    Text("Edit")
                }).padding()
                .buttonStyle(LoginButton())
            }
            .alert(isPresented: $isAlert, content: {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                    withAnimation {
                        print("is Dashboard \(isDashboard)")
                        isDashboard = false
                    }
                }))
            })
            .onAppear(perform: {
                changeEmail = (Auth.auth().currentUser?.email) ?? ""
                changeName = self.user.user.name
                changeWeight = String(self.user.user.weight)
                changeHeight = Double(self.user.user.height)
                isMetric = self.user.user.metric
                changeIsCoffeDrinker = self.user.user.isCoffeeDrinker
                usedUID = self.user.user.userUID
                print("Used id: \(usedUID)")
            })
        }
        
        func workoutPicker() -> some View {
            let workoutTime = [15,30,45,60,75,90,105,120,135,150,165,180,195,210,225, 240, 255, 270, 285, 300, 315, 330, 345, 360, 375, 390, 405, 420, 435, 450, 465, 480, 495, 510, 525, 540]
            
            return Menu("Do you workout? ") {
                ForEach(workoutTime, id: \.self) { action in
                    Button(action: {
                        changeExerciseTimeAmount = action
                    }, label: {
                        if action % 60 == 0 {
                            Text("\(action / 60) hour")
                        } else {
                            if getTheMinutes(value: action, divider: 60).0 != 0 {
                                Text("\(String(format: "%0.f", getTheMinutes(value: action, divider: 60).0)) hour \(String(format: "%0.f", getTheMinutes(value: action, divider: 60).1)) minutes")
                            } else if getTheMinutes(value: action, divider: 60).0 == 0 {
                                Text("\(String(format: "%0.f", getTheMinutes(value: action, divider: 60).1)) minutes")
                            }
                        }
                    })
                }
            }.padding()
        }
        
        func getTheMinutes(value: Int, divider: Int) -> (Double,Double) {
            
            let returnValue = Double(value) / Double(divider)
            var hour: Double = 0
            var minute: Double = 0
            if returnValue < 1 {
                hour = 0
                minute = (returnValue * 60.0)
            } else {
                let remainder: Double = Double(value % divider)
                hour = returnValue - (remainder / 60)
                minute = remainder
            }
            return (hour,minute)
        }
        
        
        func exerciseHydration() -> Double {
            var cupSize: Double {
                return isMetric ? 237 : 8
            }
            let cupConverter: Double = Double(changeExerciseTimeAmount / 30)
            return cupSize * cupConverter
        }
    }

