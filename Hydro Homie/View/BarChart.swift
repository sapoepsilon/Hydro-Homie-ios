//
//  BarChart.swift
//  Hydro Comrade
//
//  Created by Ismatulla Mansurov on 6/22/21.
//

import SwiftUI
import CoreLocation
import UIKit
import CareKitUI

struct BarView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var statsDictionary: [[String: [String: Double]]] = []
    @EnvironmentObject var user: UserDocument
    @State private var pickerSelectedItem = 0
    @State var waterColor: Color = Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5)
    @State private var weekly: Bool = false
    @State private var cups: Double = 0
    @State private var weeklyOnAppear: Int = 0
    @State private var yearly: Bool = false
    @State private var monthly: Bool = false
    @State private var amountOfDays: Int = 0
    @State private var barData: [(String, Double)] = []
    @State private var barDataName: [String] = []
    @State private var barWidth: CGSize = CGSize(width: 400, height: 500)
    @State private var arrayDates: [String] = []
    @Environment(\.colorScheme) var colorScheme
    var currentLoop: Int = 0
    @State var currentPercentage: Double = 0
    let format = DateFormatter()
    @State private var arrayOfWater: [CGFloat] = [0, 1]
    @State private var arrayOfCoffee: [CGFloat] = [1, 2]
    @State private var arrayOfAlcohol: [CGFloat] = [1, 5]
    var percentage: Double = 50
    var backgroundColor: Color = Color.gray
    var startColor: Color = Color(UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5))
    var endColor: Color = Color(UIColor.blue)
    var thickness: CGFloat = 10
    @Binding var isStats: Bool
    var unitConverter: Double {
        if user.user.metric {
            return 237
        } else {
            return 8
        }
    }

    @State var periodInChart: String = "Week"

    let selectionIndicatorHeight: CGFloat = 60
    @State var selectedBarTopCentreLocation: CGPoint?
    let chartView = OCKCartesianChartView(type: .bar)
    @State var chartData: [OCKDataSeries] = [
    ]
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
    @State var orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation

    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

    var body: some View {
        ZStack{
            if orientation!.isPortrait {
        ZStack {
            ZStack {
                waterColor
                        .opacity(0.8)
            }
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                        .edgesIgnoringSafeArea(.all)
                waterColor.opacity(0.4)
                    .onAppear {
                        print("orientation \(orientation!.rawValue)")
                    }
            }
            VStack {
                VStack(spacing: 10) {
                        Spacer().frame(height: UIScreen.main.bounds.height / 13)
                    
                    Spacer()
                    HStack {
                            Spacer().frame(width: UIScreen.main.bounds.width / 7)
                        
                        Button(action: {
                            isStats = false
                        }, label: {
                            Text("Go back")
                                .fontWeight(.bold)
                                .font(.title2)
                        })
                        Spacer()
                    }
                    HStack {
                        Text(getTheWeekDay(day: 6))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 5))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 4))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 3))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 2))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 1))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                        Text(getTheWeekDay(day: 0))
                                .font(.title.bold())
                                .padding(.bottom, isIpad ? 0 : -29)
                                .frame(width: UIScreen.main.bounds.width / 8.2)
                    }
                    HStack {

                        if statsDictionary.count >= 7 {
                            ForEach(statsDictionary.suffix(7), id: \.self) { dictionary in
                                weeklyRings(hydration: dictionary)
                                        .shadow(color: .black, radius: 2, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                        .frame(width: UIScreen.main.bounds.width / 8.4).padding(.top)

                            }
                        } else if statsDictionary.count < 7 {
                            ForEach(statsDictionary, id: \.self) { dictionary in
                                weeklyRings(hydration: dictionary)
                                        .shadow(color: .black, radius: 2, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                        .frame(width: UIScreen.main.bounds.width / 8.4).padding(.top)
                            }
                        }

                    }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .padding()
                }.frame(height: UIScreen.main.bounds.height / 5)
                Spacer()
                Text(getTheWeekDay(day: 0, isToday: true)).frame(alignment: .top)
                        .font(.title.bold())
                        .padding()
                mainRingView(percentageWater: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "water"), startColor: Color.blue, endColor: Color(UIColor.blue), percentageAlcohol: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "alcohol"), startColorAlcohol: Color.orange, endColorAlcohol: Color(UIColor.purple), percentageCoffee: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "coffee"), startColorCoffee: Color.yellow, endColorCoffee: Color(UIColor.brown))
                        .shadow(color: .blue.opacity(0.05), radius: 3, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)

                ZStack(content: {
                    Menu(periodInChart) {
                        Button(action:{ periodInChart = "Week"
                            changeDatesInArray()
                            chartData = [OCKDataSeries(values: arrayOfWater, title: "Water", gradientStartColor: UIColor.blue, gradientEndColor: UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5)), ]
                        } , label: { Text("Week") })
                        Button(action:{ periodInChart = "Month"
                            changeDatesInArray()
                            chartData = [OCKDataSeries(values: arrayOfWater, title: "Water", gradientStartColor: UIColor.blue, gradientEndColor: UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5)), ]
                            print("Array of water \(arrayOfWater)")
                        } , label: { Text("Month") })
                        Button(action:{ periodInChart = "Six Months"} , label: { Text("6 Months") })
                        Button(action:{ periodInChart = "Year"} , label: { Text("Year") })
                    }.zIndex(2)
                            .offset(x: 120, y: -77)
                        CartesianChartView(title: "Water", horizontalMakers: dateFormatsForTheChart(), data: $chartData)
                        .layoutPriority(1)
                        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.size.height * 0.33, alignment: .center)
                        .padding()
                    }).padding()
            }

     
        }
            } else if orientation!.isLandscape {
                ZStack {
                    ZStack {
                        waterColor
                                .opacity(0.8)
                    }
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                                .edgesIgnoringSafeArea(.all)
                        waterColor.opacity(0.4)
                    }
                    VStack {
                        VStack() {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                Spacer().frame(height: UIScreen.main.bounds.height / 15)
                            } else {
                                Spacer().frame(height: UIScreen.main.bounds.height / 13)
                            }
                        
                            HStack {
                                    Spacer().frame(width: UIScreen.main.bounds.width / 10)
                                
                                Button(action: {
                                    isStats = false
                                }, label: {
                                    Text("Go back")
                                        .fontWeight(.bold)
                                        .font(.title2)
                                })
                                Spacer()
                            }
                        }
                            HStack {
                                Text(getTheWeekDay(day: 6))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 5))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 4))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 3))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 2))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 1))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                                Text(getTheWeekDay(day: 0))
                                        .font(.title.bold())
                                        .padding(.bottom, isIpad ? 0 : UIScreen.main.bounds.height / 12)
                                        .frame(width: UIScreen.main.bounds.width / 8.2)
                            }
                            HStack {

                                if statsDictionary.count >= 7 {
                                    ForEach(statsDictionary.suffix(7), id: \.self) { dictionary in
                                        landscapeWeeklyRings(hydration: dictionary)
                                                .shadow(color: .black, radius: 2, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                                .frame(width: UIScreen.main.bounds.width / 8.2)

                                    }
                                } else if statsDictionary.count < 7 {
                                    ForEach(statsDictionary, id: \.self) { dictionary in
                                        landscapeWeeklyRings(hydration: dictionary)
                                                .shadow(color: .black, radius: 2, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                                .frame(width: UIScreen.main.bounds.width / 8.2)
                                    }
                                }

                            }
                                    .frame(width: UIScreen.main.bounds.width * 0.95)
                        
                        Spacer()
                        HStack {
                            VStack(spacing: -5) {
                        Text(getTheWeekDay(day: 0, isToday: true)).frame(alignment: .top)
                                .font(.title.bold())
                                .padding(.top, 10)
                        landscapeMainRingView(percentageWater: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "water"), startColor: Color.blue, endColor: Color(UIColor.blue), percentageAlcohol: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "alcohol"), startColorAlcohol: Color.orange, endColorAlcohol: Color(UIColor.purple), percentageCoffee: getTheDrinkValue(hydrationDictionary: user.getHydrationArrayFromTheUserDefaults().last ?? ["Something": ["went wrong": 0]], drinkName: "coffee"), startColorCoffee: Color.yellow, endColorCoffee: Color(UIColor.brown))
                                .shadow(color: .blue.opacity(0.05), radius: 3, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }

                        ZStack(content: {
                            Menu(periodInChart) {
                                Button(action:{ periodInChart = "Week"
                                    changeDatesInArray()
                                    chartData = [OCKDataSeries(values: arrayOfWater, title: "Water", gradientStartColor: UIColor.blue, gradientEndColor: UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5)), ]
                                } , label: { Text("Week") })
                                Button(action:{ periodInChart = "Month"
                                    changeDatesInArray()
                                    chartData = [OCKDataSeries(values: arrayOfWater, title: "Water", gradientStartColor: UIColor.blue, gradientEndColor: UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5)), ]
                                    print("Array of water \(arrayOfWater)")
                                } , label: { Text("Month") })
                                Button(action:{ periodInChart = "Six Months"} , label: { Text("6 Months") })
                                Button(action:{ periodInChart = "Year"} , label: { Text("Year") })
                            }.zIndex(2)
                                    .offset(x: 120, y: -77)
                                CartesianChartView(title: "Water", horizontalMakers: dateFormatsForTheChart(), data: $chartData)
                                .layoutPriority(1)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.size.height * 0.6, alignment: .center)
                                .padding()
                        }).padding(.bottom, isIpad ? 0 : -20)
                        }
                    }

             
                }
            }
        }.onReceive(orientationChanged) { _ in
            self.orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation
        }
        .onAppear {
            print("orientation \(orientation!.rawValue)")
            changeDatesInArray()
            chartData = [OCKDataSeries(values: arrayOfWater, title: "Water", gradientStartColor: UIColor.blue, gradientEndColor: UIColor(red: 0, green: 0.5, blue: 0.75, alpha: 0.5)), ]
//            month = Calendar.current.monthSymbols[monthInt - 1]
        }
       
    }
    func changeDatesInArray() {
        arrayDates.removeAll()
        for days in weatherDatesFromCurrentDayMonth() {
            format.dateFormat = "MMM d, yyyy"
            let today = format.string(from: days)
            arrayDates.append(today)
        }
        self.getOCKData()
    }
    func dateFormatsForTheChart() -> [String] {
        var monthInNumeric: [String] = []
        for days in weatherDatesFromCurrentDayMonth() {
            format.dateFormat = "MM/dd"
            let today = format.string(from: days)
            monthInNumeric.append(today)
        }
        if periodInChart != "Week" {
            monthInNumeric.removeAll()
        }
        return monthInNumeric
    }

    func weeklyRings(hydration: [String: [String: Double]]) -> some View {
        let waterPercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "water")
        let alcoholPercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "alcohol")
        let coffeePercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "coffee")
        let ringViews = ringView(percentageWater: waterPercentage, startColor: Color.blue, endColor: Color(UIColor.blue), percentageAlcohol: alcoholPercentage, startColorAlcohol: Color.purple, endColorAlcohol: Color(UIColor.purple), percentageCoffee: coffeePercentage, startColorCoffee: Color.orange, endColorCoffee: Color(UIColor.brown))
        return ringViews
    }
    func landscapeWeeklyRings(hydration: [String: [String: Double]]) -> some View {
        let waterPercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "water")
        let alcoholPercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "alcohol")
        let coffeePercentage: Double = getTheDrinkValue(hydrationDictionary: hydration, drinkName: "coffee")
        let ringViews = landscapeRingView(percentageWater: waterPercentage, startColor: Color.blue, endColor: Color(UIColor.blue), percentageAlcohol: alcoholPercentage, startColorAlcohol: Color.purple, endColorAlcohol: Color(UIColor.purple), percentageCoffee: coffeePercentage, startColorCoffee: Color.orange, endColorCoffee: Color(UIColor.brown))
        return ringViews
    }

    func getTheDates() -> [String] {
        var horizontalHeaders: [String] = []
        for dates in user.getHydrationArrayFromTheUserDefaults() {
            for keys in dates.keys {
                horizontalHeaders.append(keys)
            }
        }
        return horizontalHeaders
    }

    func getTheDrinkValue(hydrationDictionary: [String: [String: Double]], drinkName: String) -> Double {
        var returnValue = 0.0
        for value in hydrationDictionary.values {
            for dictionary in value {
                if drinkName == "water" && dictionary.key == drinkName {
                    returnValue = (dictionary.value / (user.user.waterIntake / unitConverter))
                } else if drinkName == "coffee" && dictionary.key == drinkName {
                    returnValue = dictionary.value / 1
                } else if drinkName == dictionary.key {
                    returnValue = dictionary.value / 5
                }
            }
        }
        return returnValue
    }

    func weatherDatesFromCurrentDayMonth() -> [Date] {
        let now = Date()
        let tomorrow = Date(timeIntervalSinceNow: 86400)
        var currentDate = previousWeek(date: tomorrow)
        var datesArray = [Date]()

        while currentDate <= now {
            datesArray.append(currentDate)
            currentDate = nextDay(date: currentDate)
        }
        print("Dates Array \(datesArray)")
        return datesArray
    }

    func nextDay(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        return Calendar.current.date(byAdding: dateComponents, to: date)!
    }

    func previousWeek(date: Date) -> Date {
        var dateComponents = DateComponents()
        if(periodInChart == "Week") {
            dateComponents.weekOfMonth = -1
        } else if (periodInChart == "Month") {
            dateComponents.month = -1
        } else if (periodInChart == "Six Months") {
            dateComponents.year = -1 / 2
        } else if (periodInChart == "Year") {
            dateComponents.year = -1
        }
        return Calendar.current.date(byAdding: dateComponents, to: date)!
    }

    func getTheWeekDay(day: Int, isToday: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var weekDay = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -day, to: Date())!)
        if isToday {
            return weekDay
        } else {
            if weekDay == "Sunday" {
                weekDay.removeAll { character in
                    character != "S" && character != "u"
                }
                return weekDay
            } else {
                return weekDay.first!.description
            }
        }
    }

    func getOCKData() {
        arrayOfWater.removeAll()
        statsDictionary.removeAll()
        for day in arrayDates {
            var matchingDay: String = ""
            var matchingValue: Double = 0
            var dictionaryInTheLoop: [String: [String: Double]] = [:]
            for hydration in user.getHydrationArrayFromTheUserDefaults() {
                for values in hydration {
                    if day == values.key {
                        matchingDay = day
                        dictionaryInTheLoop = hydration
                        for water in values.value {
                            if water.key == "water" {
                                matchingValue = water.value
                            }
                        }
                    }
                }
            }
            if day == matchingDay {
                arrayOfWater.append(matchingValue)
                statsDictionary.append(dictionaryInTheLoop)
            } else {
                arrayOfWater.append(0)
                statsDictionary.append([day: ["water": 0, "coffee": 0, "alcohol": 0]])
            }
        }
    }

    func ringView(percentageWater: Double, startColor: Color, endColor: Color, percentageAlcohol: Double, startColorAlcohol: Color, endColorAlcohol: Color, percentageCoffee: Double, startColorCoffee: Color, endColorCoffee: Color) -> some View {
        var thickness: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 7 : 4
        }
        var firstRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 15 : UIScreen.main.bounds.width / 14
        }
        var firstRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 10 : UIScreen.main.bounds.height / 15
        }

        var secondRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 11 : UIScreen.main.bounds.width / 9.7
        }
        var secondRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 13 : UIScreen.main.bounds.height / 14
        }

        var thirdRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 8.7 : UIScreen.main.bounds.width / 7.2
        }
        var thirdRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 13 : UIScreen.main.bounds.height / 13
        }
        return ZStack {
            RingView(
                    percentage: percentageAlcohol,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: Color.green,
                    endColor: endColorAlcohol,
                    thickness: thickness
            )
                    .frame(width: firstRingWidth, height: firstRignHeight)
//            .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageCoffee,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorCoffee,
                    endColor: endColorCoffee,
                    thickness: thickness
            ).frame(width: secondRingWidth, height: secondRignHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageWater,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColor,
                    endColor: endColor,
                    thickness: thickness
            )
                    .frame(width: thirdRingWidth, height: thirdRignHeight)
                    .aspectRatio(contentMode: .fit)
        }

    }
    func landscapeRingView(percentageWater: Double, startColor: Color, endColor: Color, percentageAlcohol: Double, startColorAlcohol: Color, endColorAlcohol: Color, percentageCoffee: Double, startColorCoffee: Color, endColorCoffee: Color) -> some View {
        var thickness: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? 7 : 4
        }
        var firstRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 15 : UIScreen.main.bounds.height / 14
        }
        var firstRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 10 : UIScreen.main.bounds.width / 15
        }

        var secondRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 11 : UIScreen.main.bounds.height / 9.7
        }
        var secondRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 13 : UIScreen.main.bounds.width / 14
        }

        var thirdRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 8.7 : UIScreen.main.bounds.height / 7.2
        }
        var thirdRignHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 13 : UIScreen.main.bounds.width / 13
        }
        return ZStack {
            RingView(
                    percentage: percentageAlcohol,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: Color.green,
                    endColor: endColorAlcohol,
                    thickness: thickness
            )
                    .frame(width: firstRingWidth, height: firstRignHeight)
//            .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageCoffee,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorCoffee,
                    endColor: endColorCoffee,
                    thickness: thickness
            ).frame(width: secondRingWidth, height: secondRignHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageWater,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColor,
                    endColor: endColor,
                    thickness: thickness
            )
                    .frame(width: thirdRingWidth, height: thirdRignHeight)
                    .aspectRatio(contentMode: .fit)
        }

    }
    func landscapeMainRingView(percentageWater: Double, startColor: Color, endColor: Color, percentageAlcohol: Double, startColorAlcohol: Color, endColorAlcohol: Color, percentageCoffee: Double, startColorCoffee: Color, endColorCoffee: Color) -> some View {
        var thickness: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 22 : UIScreen.main.bounds.width / 40
        }
        var firstRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 4 : UIScreen.main.bounds.height / 4
        }
        var firstRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 5 : UIScreen.main.bounds.width / 8
        }
        //MARK: second ring of the MAINRING

        var secondRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 2.55 : UIScreen.main.bounds.height / 2.7
        }
        var secondRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 5
        }
        //MARK: third ring of the MAINRING

        var thirdRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 1.87 : UIScreen.main.bounds.height / 2.05
        }
        var thirdRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 2.5 : UIScreen.main.bounds.width / 4
    }
        return ZStack {

            RingView(
                    percentage: percentageAlcohol,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorAlcohol,
                    endColor: endColorAlcohol,
                    thickness: thickness
            )
                    .frame(width: firstRingWidth, height: firstRingHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageCoffee,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorCoffee,
                    endColor: endColorCoffee,
                    thickness: thickness
            ).frame(width: secondRingWidth, height: secondRingHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageWater,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColor,
                    endColor: endColor,
                    thickness: thickness
            )
                    .frame(width: thirdRingWidth, height: thirdRingHeight)
                    .aspectRatio(contentMode: .fit)
        }
    }
    func mainRingView(percentageWater: Double, startColor: Color, endColor: Color, percentageAlcohol: Double, startColorAlcohol: Color, endColorAlcohol: Color, percentageCoffee: Double, startColorCoffee: Color, endColorCoffee: Color) -> some View {

        //MARK: first ring of the MAINRING
        var thickness: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 22 : UIScreen.main.bounds.height / 40
        }
        var firstRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 4
        }
        var firstRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 5 : UIScreen.main.bounds.height / 8
        }
        //MARK: second ring of the MAINRING

        var secondRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 2.55 : UIScreen.main.bounds.width / 2.7
        }
        var secondRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 4 : UIScreen.main.bounds.height / 5
        }
        //MARK: third ring of the MAINRING

        var thirdRingWidth: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 1.87 : UIScreen.main.bounds.width / 2.05
        }
        var thirdRingHeight: CGFloat {
            UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.height / 2.5 : UIScreen.main.bounds.height / 4
        }

        return ZStack {

            RingView(
                    percentage: percentageAlcohol,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorAlcohol,
                    endColor: endColorAlcohol,
                    thickness: thickness
            )
                    .frame(width: firstRingWidth, height: firstRingHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageCoffee,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColorCoffee,
                    endColor: endColorCoffee,
                    thickness: thickness
            ).frame(width: secondRingWidth, height: secondRingHeight)
                    .aspectRatio(contentMode: .fit)
            RingView(
                    percentage: percentageWater,
                    backgroundColor: Color.blue.opacity(0.3),
                    startColor: startColor,
                    endColor: endColor,
                    thickness: thickness
            )
                    .frame(width: thirdRingWidth, height: thirdRingHeight)
                    .aspectRatio(contentMode: .fit)
        }
    }


    func getCups(hydration: [String: Dictionary<String, Double>]) -> Double {

        var cup: Double = 0
        var _: Double = 0
        var _: Double = 0

        for dictionary in hydration {
            for (_, cups) in dictionary.value {
                cup += cups
            }
        }
        return cup
    }


    func getDates(hydration: [String: Dictionary<String, Double>]) -> (String, Double) {
        var cup: Double = 0
        var date: String = ""
        for dictionary in hydration {
            for (dates, cups) in dictionary.value {
                date = dates
                cup += Double(cups)
            }
        }
        return (date, cup)
    }

}


//MARK: Ring shape
struct RingBackgroundShape: Shape {

    var thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
                center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                radius: rect.width / 2 - thickness,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360),
                clockwise: false
        )
        return path
                .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }

}

//MARK: Ring Shape
struct RingTipShape: Shape {

    var currentPercentage: Double
    var thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let angle = CGFloat((360 * currentPercentage) * .pi / 180)
        let controlRadius: CGFloat = rect.width / 2 - thickness
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)

        path.addEllipse(in:
        CGRect(
                x: pointCenter.x - thickness / 2,
                y: pointCenter.y - thickness / 2,
                width: thickness,
                height: thickness
        )
        )

        return path
    }

    var animatableData: Double {
        get {
            return currentPercentage
        }
        set {
            currentPercentage = newValue
        }
    }

}

//MARK: Ring Shape
struct RingShape: Shape {

    var currentPercentage: Double
    var thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addArc(
                center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                radius: rect.width / 2 - thickness,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360 * currentPercentage),
                clockwise: false
        )

        return path
                .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }

    var animatableData: Double {
        get {
            return currentPercentage
        }
        set {
            currentPercentage = newValue
        }
    }

}

//MARK: Ring View
struct RingView: View {

    @State var currentPercentage: Double = 0

    var percentage: Double
    var backgroundColor: Color
    var startColor: Color
    var endColor: Color
    var thickness: CGFloat

    var animation: Animation {
        Animation.easeInOut(duration: 1)
    }

    var body: some View {
        let gradient = AngularGradient(gradient: Gradient(colors: [startColor, endColor]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * currentPercentage))
        return ZStack {
            RingBackgroundShape(thickness: thickness)
                    .fill(backgroundColor)
            RingShape(currentPercentage: currentPercentage, thickness: thickness)
                    .fill(gradient)
                    .rotationEffect(.init(degrees: -90))
                    .shadow(radius: 2)
                    .drawingGroup()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(self.animation) {
                                self.currentPercentage = self.percentage
                            }
                        }
                    }
            RingTipShape(currentPercentage: currentPercentage, thickness: thickness)
                    .fill(currentPercentage > 1 ? endColor : .clear)
                    .rotationEffect(.init(degrees: -90))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(self.animation) {
                                self.currentPercentage = self.percentage
                            }
                        }
                    }
        }

    }
}

struct CartesianChartView: UIViewRepresentable {

    var title: String
    var type: OCKCartesianGraphView.PlotType = .bar
    var horizontalMakers: [String]

    @Binding var data: [OCKDataSeries]

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: type)
        chartView.headerView.titleLabel.text = title
        chartView.graphView.dataSeries = data
        chartView.graphView.selectedIndex = 6
        chartView.graphView.horizontalAxisMarkers = horizontalMakers
        return chartView
    }

     func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // will be called when bound data changed, so update internal
        // graph here when external dataset changed
             uiView.graphView.dataSeries = data
             uiView.graphView.horizontalAxisMarkers = horizontalMakers
    }
}

