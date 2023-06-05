//
//  ContentView.swift
//  SwiftUICustomDatePicker
//
//  Created by İlker Kaya on 5.06.2023.
//

import SwiftUI

struct ContentView: View {
    let days = ["Pzr", "Pzt", "Sal", "Çar", "Per", "Cuma", "Cts"]
    
    @Binding var currentDate: Date
    @State var  currentMonth: Int = 0
    
    @State var firstDate: TaskMetaData? = nil
    @State var secondDate: TaskMetaData? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Tarih aralığı")
                    .font(.title2.bold())
                    .foregroundColor(Color(uiColor: hexStringToUIColor(hex: "#2D2D2D")))
                Spacer()
            }
            .padding([.leading, .trailing], 21)
            .padding(.bottom, 10)
            
            HStack {
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Color(uiColor: hexStringToUIColor(hex: "#969696")))
                }
                Spacer()
                Text("\(extraDate()[1])-\(extraDate()[0])")
                    .font(.title3.bold())
                    .foregroundColor(Color(uiColor: hexStringToUIColor(hex: "#2D2D2D")))
                Spacer()
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(Color(uiColor: hexStringToUIColor(hex: "#969696")))
                } 
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top)
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(returnBackgroundColor(value: value))
                                .padding(.horizontal, 8)
                                .opacity(firstDate?.taskDate == value.date || secondDate?.taskDate == value.date ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
        }
        .padding(.bottom, 10)
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth()
        }
    }
    
    func returnForegroundColor(value: DateValue) -> Color{
        if firstDate?.taskDate == value.date || secondDate?.taskDate == value.date {
            return .white
        } else {
            return .black
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        
        VStack {
            
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(returnForegroundColor(value: value))
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if firstDate == nil && secondDate == nil {
                            firstDate = TaskMetaData(taskDate: value.date)
                        } else if firstDate != nil && secondDate == nil {
                            secondDate = TaskMetaData(taskDate: value.date)
                        } else if value.date == firstDate?.taskDate {
                            firstDate = nil
                            secondDate = nil
                        } else if value.date == secondDate?.taskDate {
                            secondDate = nil
                        }
                    }
            }
        }
        .padding(.vertical, 3)
        .frame(height: 30, alignment: .top)
        
    }
    // Checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        return Calendar.current.isDate(date1, inSameDayAs: date2)
        
    }
    
    
    // Extraing year and month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting Current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // Getting Current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func returnBackgroundColor(value: DateValue) -> Color {
        if firstDate?.taskDate == value.date || secondDate?.taskDate == value.date{
            return Color(uiColor: hexStringToUIColor(hex: "#09244B"))
        } else {
            return .white
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentDate: .constant(Date()))
    }
}


extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // geting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
