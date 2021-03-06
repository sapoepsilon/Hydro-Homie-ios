//
//  ClearBackground.swift
//  Hydro Comrade
//
//  Created by Ismatulla Mansurov on 7/10/21.
//

import SwiftUI
import UIKit
import Combine

struct ClearBackgroundView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
        
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
//get the device model
public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
         
         //iPod
         iPod1              = "iPod 1",
         iPod2              = "iPod 2",
         iPod3              = "iPod 3",
         iPod4              = "iPod 4",
         iPod5              = "iPod 5",
         iPod6              = "iPod 6",
         iPod7              = "iPod 7",
         
         //iPad
         iPad2              = "iPad 2",
         iPad3              = "iPad 3",
         iPad4              = "iPad 4",
         iPadAir            = "iPad Air ",
         iPadAir2           = "iPad Air 2",
         iPadAir3           = "iPad Air 3",
         iPadAir4           = "iPad Air 4",
         iPad5              = "iPad 5", //iPad 2017
         iPad6              = "iPad 6", //iPad 2018
         iPad7              = "iPad 7", //iPad 2019
         iPad8              = "iPad 8", //iPad 2020
         
         //iPad Mini
         iPadMini           = "iPad Mini",
         iPadMini2          = "iPad Mini 2",
         iPadMini3          = "iPad Mini 3",
         iPadMini4          = "iPad Mini 4",
         iPadMini5          = "iPad Mini 5",
         
         //iPad Pro
         iPadPro9_7         = "iPad Pro 9.7\"",
         iPadPro10_5        = "iPad Pro 10.5\"",
         iPadPro11          = "iPad Pro 11\"",
         iPadPro2_11        = "iPad Pro 11\" 2nd gen",
         iPadPro3_11        = "iPad Pro 11\" 3nd gen",
         iPadPro12_9        = "iPad Pro 12.9\"",
         iPadPro2_12_9      = "iPad Pro 2 12.9\"",
         iPadPro3_12_9      = "iPad Pro 3 12.9\"",
         iPadPro4_12_9      = "iPad Pro 4 12.9\"",
         iPadPro5_12_9      = "iPad Pro 5 12.9\"",
         
         //iPhone
         iPhone4            = "iPhone 4",
         iPhone4S           = "iPhone 4S",
         iPhone5            = "iPhone 5",
         iPhone5S           = "iPhone 5S",
         iPhone5C           = "iPhone 5C",
         iPhone6            = "iPhone 6",
         iPhone6Plus        = "iPhone 6 Plus",
         iPhone6S           = "iPhone 6S",
         iPhone6SPlus       = "iPhone 6S Plus",
         iPhoneSE           = "iPhone SE",
         iPhone7            = "iPhone 7",
         iPhone7Plus        = "iPhone 7 Plus",
         iPhone8            = "iPhone 8",
         iPhone8Plus        = "iPhone 8 Plus",
         iPhoneX            = "iPhone X",
         iPhoneXS           = "iPhone XS",
         iPhoneXSMax        = "iPhone XS Max",
         iPhoneXR           = "iPhone XR",
         iPhone11           = "iPhone 11",
         iPhone11Pro        = "iPhone 11 Pro",
         iPhone11ProMax     = "iPhone 11 Pro Max",
         iPhoneSE2          = "iPhone SE 2nd gen",
         iPhone12Mini       = "iPhone 12 Mini",
         iPhone12           = "iPhone 12",
         iPhone12Pro        = "iPhone 12 Pro",
         iPhone12ProMax     = "iPhone 12 Pro Max",
         
         // Apple Watch
         AppleWatch1         = "Apple Watch 1gen",
         AppleWatchS1        = "Apple Watch Series 1",
         AppleWatchS2        = "Apple Watch Series 2",
         AppleWatchS3        = "Apple Watch Series 3",
         AppleWatchS4        = "Apple Watch Series 4",
         AppleWatchS5        = "Apple Watch Series 5",
         AppleWatchSE        = "Apple Watch Special Edition",
         AppleWatchS6        = "Apple Watch Series 6",
         
         //Apple TV
         AppleTV1           = "Apple TV 1gen",
         AppleTV2           = "Apple TV 2gen",
         AppleTV3           = "Apple TV 3gen",
         AppleTV4           = "Apple TV 4gen",
         AppleTV_4K         = "Apple TV 4K",
         AppleTV2_4K        = "Apple TV 4K 2gen",
         
         unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        let modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPod7,1"   : .iPod6,
            "iPod9,1"   : .iPod7,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            "iPad7,11"  : .iPad7, //iPad 2019
            "iPad7,12"  : .iPad7,
            "iPad11,6"  : .iPad8, //iPad 2020
            "iPad11,7"  : .iPad8,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,9"   : .iPadPro2_11,
            "iPad8,10"  : .iPadPro2_11,
            "iPad13,4"  : .iPadPro3_11,
            "iPad13,5"  : .iPadPro3_11,
            "iPad13,6"  : .iPadPro3_11,
            "iPad13,7"  : .iPadPro3_11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            "iPad8,11"  : .iPadPro4_12_9,
            "iPad8,12"  : .iPadPro4_12_9,
            "iPad13,8"  : .iPadPro5_12_9,
            "iPad13,9"  : .iPadPro5_12_9,
            "iPad13,10" : .iPadPro5_12_9,
            "iPad13,11" : .iPadPro5_12_9,
            
            //iPad Air
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            "iPad13,1"  : .iPadAir4,
            "iPad13,2"  : .iPadAir4,
            
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            
            // Apple Watch
            "Watch1,1" : .AppleWatch1,
            "Watch1,2" : .AppleWatch1,
            "Watch2,6" : .AppleWatchS1,
            "Watch2,7" : .AppleWatchS1,
            "Watch2,3" : .AppleWatchS2,
            "Watch2,4" : .AppleWatchS2,
            "Watch3,1" : .AppleWatchS3,
            "Watch3,2" : .AppleWatchS3,
            "Watch3,3" : .AppleWatchS3,
            "Watch3,4" : .AppleWatchS3,
            "Watch4,1" : .AppleWatchS4,
            "Watch4,2" : .AppleWatchS4,
            "Watch4,3" : .AppleWatchS4,
            "Watch4,4" : .AppleWatchS4,
            "Watch5,1" : .AppleWatchS5,
            "Watch5,2" : .AppleWatchS5,
            "Watch5,3" : .AppleWatchS5,
            "Watch5,4" : .AppleWatchS5,
            "Watch5,9" : .AppleWatchSE,
            "Watch5,10" : .AppleWatchSE,
            "Watch5,11" : .AppleWatchSE,
            "Watch5,12" : .AppleWatchSE,
            "Watch6,1" : .AppleWatchS6,
            "Watch6,2" : .AppleWatchS6,
            "Watch6,3" : .AppleWatchS6,
            "Watch6,4" : .AppleWatchS6,
            
            //Apple TV
            "AppleTV1,1" : .AppleTV1,
            "AppleTV2,1" : .AppleTV2,
            "AppleTV3,1" : .AppleTV3,
            "AppleTV3,2" : .AppleTV3,
            "AppleTV5,3" : .AppleTV4,
            "AppleTV6,2" : .AppleTV_4K,
            "AppleTV11,1" : .AppleTV2_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

//Center columns and text

struct WidthPreferenceKey: PreferenceKey {
    
    static var defaultValue: [CGFloat] = []
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
    
}

struct EqualWidth: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: WidthPreferenceKey.self,
                            value: [proxy.size.width]
                        )
                }
            )
    }
}

extension String {
    
    func camelCaseToWords() -> String {
        
        return unicodeScalars.reduce("") {
            
            if CharacterSet.uppercaseLetters.contains($1) {
                
                return ($0 + " " + String($1))
            }
            else {
                
                return $0 + String($1)
            }
        }
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIToolbar {
    func setBackgroundColor(image: UIImage) {
        setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
    }
}
extension View {
    func equalWidth() -> some View {
        modifier(EqualWidth())
    }
}

struct CustomStepper : View {
    @Binding var value: Double
    @Binding var isDiuretic: Bool
    @Binding var textColor: Color
    @Binding var isCustomWater: Bool
    var step = 1.0
    
    var body: some View {
        HStack {
            
            Image(systemName: "minus.square")
                .resizable()
                .opacity(value >= 0 ? 1 : 0)
                .onTapGesture(perform: {
                    self.value -= self.step
                    self.feedback()
                })
                .onLongPressGesture(minimumDuration: 0.2, perform: {
                    isDiuretic = true
                    isCustomWater = true
                })
                .foregroundColor(textColor)
                .frame(width: 32.0, height: 32.0)
            
            Image(systemName: "plus.square")
                .resizable()
                .onTapGesture(perform: {
                    self.value += self.step
                    self.feedback()
                })
                .onLongPressGesture(minimumDuration: 0.2, perform: {
                    isDiuretic = true
                    isCustomWater = true
                })
                .foregroundColor(textColor)
                .frame(width: 32.0, height: 32.0)
        }
    }
    
    func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
struct ClearBackgroundMenuStyle : MenuStyle {
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        
    }
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(Color.green)
            .border(Color.red, width: 34)
    }
}

struct LoginButton : ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    @State private var waterColor: Color =  Color( red: 0, green: 0.5, blue: 0.7, opacity: 0.5)
    @State private var buttonWidth: CGFloat = 0.6
    
    init() {
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 375, height: UIScreen.main.bounds.height * 0.05)
            .background(waterColor.currentWaterColor(colorScheme: colorScheme))
            .foregroundColor(.white)
            .clipShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .cornerRadius(26)
    }
    
}
struct drinkAdditionBackground : Shape {
    var startAngle: Angle = Angle(degrees: 0)
    var endAngle: Angle = Angle(degrees: 45)
    var clockwise: Bool = true
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY), radius: rect.width / 3, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return p
    }
}

struct LoadingView: View {
    
      @State private var shouldAnimate = false
    @State private var waterColor: Color = Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5)
      
      var body: some View {
          
          HStack(alignment: .center, spacing: shouldAnimate ? 15 : 5) {
              Capsule(style: .continuous)
                  .fill(Color.blue)
                  .frame(width: 10, height: 50)
              Capsule(style: .continuous)
                  .fill(Color.blue)
                  .frame(width: 10, height: 30)
              Capsule(style: .continuous)
                  .fill(Color.blue)
                  .frame(width: 10, height: 50)
              Capsule(style: .continuous)
                  .fill(Color.blue)
                  .frame(width: 10, height: 30)
              Capsule(style: .continuous)
                  .fill(Color.blue)
                  .frame(width: 10, height: 50)
          }
          .frame(width: shouldAnimate ? 150 : 100)
          .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
          .onAppear {
              self.shouldAnimate = true
          }
    }
    
}

struct LoadingPreview: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
    
    
}


extension Color {
    
    func currentWaterColor(colorScheme: ColorScheme) -> Color {
        var waterColor: Color = Color( red: 0, green: 0, blue: 0, opacity: 0)
        if colorScheme == .dark {
            waterColor = Color( red: 0, green: 0.5, blue: 0.7, opacity: 0.5)
        } else {
            waterColor = Color( red: 0, green: 0.5, blue: 0.8, opacity: 0.5)
        }
        return waterColor
    }
}
//View as a centering background



struct AuthenticationButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemIndigo))
            .cornerRadius(12)
            .padding()
    }
}


//half modalView

public struct HalfASheet<Content: View>: View {
    
    @Binding private var isPresented: Bool
    @State private var hasAppeared = false
    @State private var dragOffset: CGFloat = 0
    
    @State var height: HalfASheetHeight = .proportional(0.7) // about the same as a ColorPicker
    internal var contentInsets = EdgeInsets(top: 7, leading: 16, bottom: 12, trailing: 16)
    internal var backgroundColor: UIColor = .clear
    internal var closeButtonColor: UIColor = .white
    internal var allowsDraggingToDismiss = true
    
    private let title: String?
    private let content: () -> Content
    private let cornerRadius: CGFloat = 15
    private let additionalOffset: CGFloat = 44 // this is so we can drag the sheet up a bit
    
    private var actualContentInsets: EdgeInsets {
        return EdgeInsets(top: contentInsets.top, leading: contentInsets.leading, bottom: cornerRadius + additionalOffset + contentInsets.bottom, trailing: contentInsets.trailing)
    }
    
    
    public init(isPresented: Binding<Bool>, title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        _isPresented = isPresented
        self.title = title
        self.content = content
    }
    
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                if isPresented {
                    
                    Color.clear.opacity(0.4)
                        .onTapGesture {
                            dismiss()
                        }
                        .transition(.opacity)
                        .onAppear { // we don't want the content to slide up until the background has appeared
                            withAnimation {
                                hasAppeared = true
                            }
                        }
                        .onDisappear() {
                            withAnimation {
                                hasAppeared = false
                            }
                        }
                }
                
                if hasAppeared {
                    
                    VStack(alignment: .center) {
                        
                        Spacer()
                        
                        ZStack {
                            content()
                                .cornerRadius(23)
                                .padding(actualContentInsets)
                            
                            titleView
                        }
                        .frame(height: height.value(with: geometry) + cornerRadius + additionalOffset)
                        .offset(y: .zero)
                    }
                    .offset(y: dragOffset)
                    .transition(.verticalSlide(height.value(with: geometry)))
                    .highPriorityGesture(
                        dragGesture(geometry)
                    )
                    .onDisappear {
                        dragOffset = 0
                    }
                    
                }
            }
        }
    }
}
fileprivate struct VerticalSlideModifier: ViewModifier {
    
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .offset(CGSize(width: 0, height: offset))
    }
}


extension AnyTransition {
    
    static func verticalSlide(_ offset: CGFloat? = nil) -> AnyTransition {
        
        .modifier(
            active: VerticalSlideModifier(offset: offset ?? UIScreen.main.bounds.height),
            identity: VerticalSlideModifier(offset: 0)
        )
    }
}


struct If: View {
    
    private let viewProvider: () -> AnyView
    
    
    init<V: View>(_ isTrue: Binding<Bool>, @ViewBuilder _ viewProvider: @escaping () -> V) {
        self.viewProvider = {
            isTrue.wrappedValue ? AnyView(viewProvider()) : AnyView(EmptyView())
        }
    }
    
    init<V: View, O: View>(_ isTrue: Binding<Bool>, @ViewBuilder _ viewProvider: @escaping () -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            isTrue.wrappedValue ? AnyView(viewProvider()) : AnyView(otherViewProvider())
        }
    }
    
    init<V: View>(_ condition: @autoclosure @escaping () -> Bool, @ViewBuilder _ viewProvider: @escaping () -> V) {
        self.viewProvider = {
            condition() ? AnyView(viewProvider()) : AnyView(EmptyView())
        }
    }
    
    init<V: View, O: View>(_ condition: @autoclosure @escaping () -> Bool, @ViewBuilder _ viewProvider: @escaping () -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            condition() ? AnyView(viewProvider()) : AnyView(otherViewProvider())
        }
    }
    
    var body: some View {
        return viewProvider()
    }
}


struct IfLet: View {
    
    private let viewProvider: () -> AnyView
    
    
    init<T, V: View>(_ item: Binding<T?>, @ViewBuilder _ viewProvider: @escaping (T) -> V) {
        self.viewProvider = {
            AnyView(item.wrappedValue.map {
                viewProvider($0)
            })
        }
    }
    
    init<T, V: View, O: View>(_ item: Binding<T?>, @ViewBuilder _ viewProvider: @escaping (T) -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            if let item = item.wrappedValue {
                return AnyView(viewProvider(item))
            } else {
                return AnyView(otherViewProvider())
            }
        }
    }
    
    init<T, V: View>(_ item: T?, @ViewBuilder _ viewProvider: @escaping (T) -> V) {
        self.viewProvider = {
            AnyView(item.map {
                viewProvider($0)
            })
        }
    }
    
    init<T, V: View, O: View>(_ item: T?, @ViewBuilder _ viewProvider: @escaping (T) -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            if let item = item {
                return AnyView(viewProvider(item))
            } else {
                return AnyView(otherViewProvider())
            }
        }
    }
    
    var body: some View {
        return viewProvider()
    }
}



// MARK: - Private
extension HalfASheet {
    
    private var titleView: IfLet {
        
        let titleView = IfLet(title) { title in
            
            VStack {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(Font.title.weight(.semibold))
                        .opacity(0)
                        .padding(EdgeInsets(top: 10, leading: 13, bottom: 0, trailing: 0))
                    Spacer()
                    Text(title)
                        .font(Font.headline.weight(.semibold))
                        .padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0))
                        .lineLimit(1)
                    closeButton
                }
                Spacer()
            }
            
        } else: {
            
            VStack {
                HStack {
                    closeButton
                        .padding(.top, 10)
                }
                Spacer()
            }
        }
        
        return titleView
    }
    
    private func dragGesture(_ geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        
        let gesture = DragGesture()
            .onChanged {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                let offset = $0.translation.height
                dragOffset = offset > 0 ? offset : sqrt(-offset) * -3
                print("dragOffset: \(dragOffset)")
            }
            .onEnded {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                if dragOffset > 0, $0.predictedEndTranslation.height / $0.translation.height > 2 {
                    dismiss()
                    return
                }  else if dragOffset < -30 {
                    withAnimation {
                        fullSize()
                    }
                } else if dragOffset > 0 {
                    withAnimation {
                        halfSize()
                    }
                }
                
                let validDragDistance = height.value(with: geometry) / 2
                if dragOffset < validDragDistance {
                    withAnimation {
                        dragOffset = 0
                    }
                } else {
                    dismiss()
                }
            }
        return gesture
    }
    
    private var closeButton: AnyView {
        
        let button =
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 6, height: 7.5)
                .cornerRadius(30)
            
        }
        
        return AnyView(button)
    }
    private func fullSize() {
        height = .proportional(1)
    }
    
    private func halfSize() {
        height = .proportional(0.7)
    }
    
    private func dismiss() {
        
        //        withAnimation {
        height = .proportional(0.7)
        hasAppeared = false
        isPresented = false
        //        }
    }
}


public enum HalfASheetHeight {
    case fixed(CGFloat)
    case proportional(CGFloat)
    
    func value(with geometry: GeometryProxy) -> CGFloat {
        switch self {
        case .fixed(let height):
            return height
        case .proportional(let proportion):
            return geometry.size.height * proportion
        }
    }
}
extension HalfASheet {
    
    /// The proportion of the containing view's height to use for the height of the HalfASheet
    /// - Parameter height: a HalfASheetHeight case - either .fixed(required height in pixels) or .proportional(proportion of the containing view's height - 1 is 100% of the height)
    public func height(_ height: HalfASheetHeight) -> Self {
        let copy = self
        copy.height = height
        return copy
    }
    
    /// Insets to use around the content of the HalfASheet
    /// - Parameter contentInsets: an EdgeInsets instance
    public func contentInsets(_ contentInsets: EdgeInsets) -> Self {
        var copy = self
        copy.contentInsets = contentInsets
        return copy
    }
    
    /// The background colour for the HalfASheet
    /// - Parameter backgroundColor: a UIColor
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }
    
    /// The color for the close button
    /// - Parameter closeButtonColor: a UIColor
    public func closeButtonColor(_ closeButtonColor: UIColor) -> Self {
        var copy = self
        copy.closeButtonColor = closeButtonColor
        return copy
    }
    
    /// Use this to disable the drag-downwards-to-dismiss functionality
    public var disableDragToDismiss: Self {
        var copy = self
        copy.allowsDraggingToDismiss = false
        return copy
    }
}


extension View {
    
    /// View extension in the style of .sheet - offers no real customisation. If more flexibility is required, use HalfASheet(...) directly, and apply the required modifiers
    /// - Parameters:
    ///   - isPresented: binding to a Bool which controls whether or not to show the partial sheet
    ///   - title: an optional title for the sheet
    ///   - content: the sheet's content
    public func halfASheet<T: View>(isPresented: Binding<Bool>, title: String? = nil, @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(HalfASheetPresentationModifier(content: { HalfASheet(isPresented: isPresented, title: title, content: content) }))
    }
}


struct HalfASheetPresentationModifier<SheetContent>: ViewModifier where SheetContent: View {
    
    var content: () -> HalfASheet<SheetContent>
    
    init(@ViewBuilder content: @escaping () -> HalfASheet<SheetContent>) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            self.content()
        }
    }
}

class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onCommitHandler?()
    }
}

struct SATextField: UIViewRepresentable {
    private let tmpView = WrappableTextField()
    
    //var exposed to SwiftUI object init
    var tag:Int = 0
    var placeholder:String?
    var fieldVariable:String?
    var changeHandler:((String)->Void)?
    var returnKeyType: UIReturnKeyType = .default
    var isSecureTextEntry: Binding<Bool>? = nil
    var onCommitHandler:(()->Void)?
    var text: String?
    
    func makeUIView(context: UIViewRepresentableContext<SATextField>) -> WrappableTextField {
        tmpView.tag = tag
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        tmpView.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        tmpView.returnKeyType = returnKeyType
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<SATextField>) {
        if text != nil {
            uiView.text = text
        }
        uiView.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
    }
}

class FormSheetWrapper<Content: View>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var content: () -> Content
    var onDismiss: (() -> Void)?
    
    private var hostVC: UIHostingController<Content>?
    
    required init?(coder: NSCoder) { fatalError("") }
    
    init(content: @escaping () -> Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    func show() {
        guard hostVC == nil else { return }
        let vc = UIHostingController(rootView: content())
        
//        vc.view.sizeToFit()
//        vc.preferredContentSize = vc.view.bounds.size
//
        vc.modalPresentationStyle = .formSheet
        vc.presentationController?.delegate = self
        hostVC = vc
        self.present(vc, animated: true, completion: nil)
    }
    
    func hide() {
        guard let vc = self.hostVC, !vc.isBeingDismissed else { return }
        dismiss(animated: true, completion: nil)
        hostVC = nil
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        hostVC = nil
        self.onDismiss?()
    }
}

struct FormSheet<Content: View> : UIViewControllerRepresentable {
    
    @Binding var show: Bool
    
    let content: () -> Content
    internal var backgroundColor: UIColor = .clear

    func makeUIViewController(context: UIViewControllerRepresentableContext<FormSheet<Content>>) -> FormSheetWrapper<Content> {
        
        
        let vc = FormSheetWrapper(content: content)
    
        vc.onDismiss = { self.show = false }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: FormSheetWrapper<Content>,
                                context: UIViewControllerRepresentableContext<FormSheet<Content>>) {
        if show {
            uiViewController.show()
        }
        else {
            uiViewController.hide()
        }
    }
}
extension FormSheet {
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }
}
extension View {
    public func formSheet<Content: View>(isPresented: Binding<Bool>,
                                         @ViewBuilder content: @escaping () -> Content) -> some View {
        self.background(FormSheet(show: isPresented,
                                  content: content))
    }
}
struct Arrow: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // 2.
            path.addLines( [
                CGPoint(x: width * 0.4, y: height),
                CGPoint(x: width * 0.4, y: height * 0.4),
                CGPoint(x: width * 0.2, y: height * 0.4),
                CGPoint(x: width * 0.5, y: height * 0.1),
                CGPoint(x: width * 0.8, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height * 0.4),
                CGPoint(x: width * 0.6, y: height)
                
            ])
            // 3.
            path.closeSubpath()
        }
    }
}

extension UserDefaults {
    var isWelcomePageShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomePage") as? Bool) ?? true
        } set {
            UserDefaults.standard.set(newValue, forKey: "welcomePage")
        }
    }
}

extension UserDefaults {
    var isFirstTimeLaunch: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "isFirstTimeLaunch") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey:  "isFirstTimeLaunch")
        }
    }
}


extension UserDefaults {
    /// Return false if Sync with the Firebase hasn't occured.
    ///
    /// - Author: Ismatulla Mansurov
    ///
    /// - Returns: Boolean
    ///
    ///  - Version: 1.0
    ///
    var isSyncFirebase: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "isSyncFirebase") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey:  "isSyncFirebase")
        }
    }
}

struct WelcomeBoardText: View {
    @Environment(\.colorScheme) var colorScheme
    var text:String
    var body: some View {
        VStack {
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
            }
            Text(text)
                    .padding()
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: UIScreen.main.bounds.width-50, height: 200)
        }.frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height / 5)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .clipped()
    }
}



struct OverlayModifier<OverlayView: View>: ViewModifier {
    
    func body(content: Content) -> some View {
        content.overlay(isPresented ? overlayView() : nil)
    }
    
    
    @Binding var isPresented: Bool
    @ViewBuilder var overlayView: () -> OverlayView
    
    init(isPresented: Binding<Bool>, @ViewBuilder overlayView: @escaping () -> OverlayView) {
        self._isPresented = isPresented
        self.overlayView = overlayView
    }
}

extension View {
    
    func alertView<OverlayView: View>(isPresented: Binding<Bool>,
                                  blurRadius: CGFloat = 3,
                                  blurAnimation: Animation? = .linear,
                                  @ViewBuilder overlayView: @escaping () -> OverlayView) -> some View {
        blur(radius: isPresented.wrappedValue ? blurRadius : 0)
            .animation(blurAnimation)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(isPresented: isPresented, overlayView: overlayView))
    }
}
class DisplayLink: NSObject, ObservableObject {
    @Published var frameDuration: CFTimeInterval = 0
    @Published var frameChange: Bool = false
    @Published var frameChanger: CGFloat = 0
    
    static let sharedInstance: DisplayLink = DisplayLink()
    
    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(frame))
        displaylink.add(to: .current, forMode: RunLoop.Mode.default)
    }
    
    @objc func frame(displaylink: CADisplayLink) {
        frameDuration = displaylink.targetTimestamp
        frameChanger = 1 / (displaylink.targetTimestamp - displaylink.timestamp)
        frameChange.toggle()
    }

    
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


// Date Listener
class TimeCounter: ObservableObject {
    @Published var time = 0
    
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.time += 1 }
    init() { timer.fire() }
}



// swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
class BulletinModel: ObservableObject {
    @Published var show: Bool

    init(show: Bool) {
        self.show = show
    }
}



struct BulletinBoard<Presenting, Board>: View where Presenting: View, Board: View {
    @Binding var isShowing: Bool
    let presenting: Presenting
    let boardItem: () -> Board
    @GestureState private var offset: CGSize = .zero
    @State private var text = ""

    var body: some View {
        let drag = DragGesture()
            .updating($offset) { value, state, _ in
                if value.translation.height >= -(UIScreen.main.bounds.height - 500) {
                    state = value.translation
                }
            }
            .onEnded({ value in
                print(value.translation.height)
                if value.translation.height >= 200 {
                    print("dismiss")
                    self.isShowing = false
                    self.dismissKeyboard()
                }
            })
        return ZStack() {
                GeometryReader { geo in
                    VStack() {
                        Spacer()
                        VStack() {
                            self.boardItem()
                                .padding([.bottom], 35)
                                .frame(minWidth: 0, maxWidth: geo.size.width, minHeight: 300, alignment: Alignment.bottom)
                        }
                        .frame(minWidth: 0, maxWidth: geo.size.width, minHeight: 300, alignment: Alignment.center)
                         .background(Color("background"))
                         .cornerRadius(35)
                         .offset(y: self.offset.height)
                         .padding(5)
                         .gesture(drag)
                         .animation(.spring())
                    }
                    .opacity(isShowing ? 1 : 0)
                    .animation(.spring())
                }.zIndex(2)

                presenting
                    .overlay(
                    EmptyView()
                        .background(Color.black)
                        .edgesIgnoringSafeArea([.all])
                        .opacity(self.isShowing ? 0.65 : 0)
                        .animation(.easeInOut(duration: 0.1))
                )
        }.edgesIgnoringSafeArea(.bottom)
    }

    func dismissKeyboard() {
        UIApplication.shared.windows.first?.endEditing(true)
    }

}

extension View {
    func addBoard<Board: View>(@ViewBuilder board: @escaping () -> Board, isShowing: Binding<Bool>) -> some View {
        BulletinBoard(isShowing: isShowing, presenting: self, boardItem: board)
    }
}
