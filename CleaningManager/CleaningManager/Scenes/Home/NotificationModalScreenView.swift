//
//  NotificationModalScreenView.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 21.09.2025.
//

import SwiftUI

struct NotificationModalScreenView: View {
    @State private var frequency = ["Daily", "Weekly", "Monthly"]
    @State private var selectedDate = Date()
    @State private var selectedFrequency = 0
    @State private var showAlert = false
    @State private var selectedWeekday = 2
    @State private var selectedDayOfMonth = 1
    @State private var showDayOfMonthWarning = false
    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            modalWindow
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .alert("Notifications is turned off", isPresented: $showAlert) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Please allow us to access your iPhone notifications.")
                }
                .alert("Attention!", isPresented: $showDayOfMonthWarning) {
                    Button("OK") {
                    }
                } message: {
                    Text("Notification will arrive on the last day if the selected day doesn’t exist in the month")
                }
        }
    }

    var modalWindow: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    Text("Notification settings")
                        .font(.headline)
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        )
                        .offset(x: 52)
                    }
                }
                Spacer()
            }
            .frame(width: 200)

            Text("Select notification frquency:")
                .font(.system(size: 14))
                .frame(width: 300, alignment: .leading)
                .padding(.top, 4)

            HStack(spacing: 8) {
                Picker("Frequency", selection: $selectedFrequency.animation()) {
                    ForEach(0..<frequency.count, id: \.self) { index in
                        Text(frequency[index]).tag(index)
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: (selectedFrequency == 0 ? 300 : 220))

                if selectedFrequency == 1 {
                    Menu {
                        ForEach(1...7, id: \.self) { day in
                            Button(action: {
                                selectedWeekday = day
                            })
                            {
                                Text(weekdayName(for: day))
                                    .font(.system(size: 14))
                            }
                        }
                    } label: {
                        HStack {
                            Text(weekdayName(for: selectedWeekday, short: true))
                                .frame(width: 36, height: 14)
                            Image(systemName: "chevron.down")
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .frame(width: 80)
                }

                if selectedFrequency == 2 {
                    Menu {
                        ForEach(1...31, id: \.self) { day in
                            Button(action: {
                                selectedDayOfMonth = day
                                
                                if selectedDayOfMonth >= 29 {
                                    showDayOfMonthWarning = true
                                }
                            })
                            {
                                Text("\(day)")
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(
                                selectedDayOfMonth > 0
                                    ? "\(selectedDayOfMonth)" : "Select"
                            )
                            .frame(width: 42, height: 14)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .frame(width: 80)
                }
            }
            .frame(width: 300)

            selectHourAndMinutes

            Button(
                action: {
                    Task {
                        let hasPermission = await NotificationService.shared
                            .checkForPermission()

                        if hasPermission {
                            NotificationService.shared.cancelAll()

                            let timeComponents = Calendar.current
                                .dateComponents(
                                    [.hour, .minute],
                                    from: selectedDate
                                )

                            switch selectedFrequency {
                            case 0:
                                var dailyComponents = DateComponents()
                                dailyComponents.hour = timeComponents.hour
                                dailyComponents.minute = timeComponents.minute

                                NotificationService.shared.dispatchNotification(
                                    identifier: "cleaning_reminder_daily",
                                    title: "It's time to clean",
                                    body:
                                        "Let's have some fun. This mop is sick",
                                    dateComponents: dailyComponents,
                                    repeats: true
                                )
                            case 1:
                                var weeklyComponents = DateComponents()
                                weeklyComponents.hour = timeComponents.hour
                                weeklyComponents.minute = timeComponents.minute
                                weeklyComponents.weekday = selectedWeekday

                                NotificationService.shared.dispatchNotification(
                                    identifier:
                                        "cleaning_reminder_weekly_\(selectedWeekday)",
                                    title: "It's time to clean",
                                    body:
                                        "Let's have some fun. This mop is sick",
                                    dateComponents: weeklyComponents,
                                    repeats: true
                                )
                            case 2:
                                let calendar = Calendar.current
                                let year = calendar.component(.year, from: Date())
                                let month = calendar.component(.month, from: Date())
                                let date = calendar.date(from: DateComponents(year: year, month: month))!
                                let range = calendar.range(of: .day, in: .month, for: date)!
                                let lastDay = range.upperBound - 1
                                
                                var monthlyComponents = DateComponents()
                                monthlyComponents.hour = timeComponents.hour
                                monthlyComponents.minute = timeComponents.minute
                                monthlyComponents.day = min(selectedDayOfMonth, lastDay)
                                
                                NotificationService.shared.dispatchNotification(
                                    identifier:
                                        "cleaning_reminder_monthly_\(selectedDayOfMonth)",
                                    title: "It's time to clean",
                                    body:
                                        "Let's have some fun. This mop is sick",
                                    dateComponents: monthlyComponents,
                                    repeats: true
                                )
                            default:
                                break
                            }

                            // ДЕБАГ ДЕБАГ

                            NotificationService.shared.getPending { requests in
                                print(
                                    "--- 📱 ПРОВЕРКА ЗАПЛАНИРОВАННЫХ УВЕДОМЛЕНИЙ ---"
                                )
                                if requests.isEmpty {
                                    print(
                                        "🔴 Нет ни одного запланированного уведомления."
                                    )
                                    return
                                }
                                for request in requests {
                                    print(
                                        "✅ Уведомление: \(request.identifier)"
                                    )
                                    if let trigger = request.trigger
                                        as? UNCalendarNotificationTrigger
                                    {
                                        print(
                                            "Компоненты для триггера: \(trigger.dateComponents)"
                                        )
                                        if let nextFireDate =
                                            trigger.nextTriggerDate()
                                        {
                                            let nextThreeFires =
                                                self.getNextTriggerDates(
                                                    from: nextFireDate,
                                                    frequencyIndex: self
                                                        .selectedFrequency,
                                                    count: 3
                                                )
                                            print("➡️ Следующие 3 срабатывания:")
                                            for (index, dateString)
                                                in nextThreeFires.enumerated()
                                            {
                                                print(
                                                    "   \(index + 1). \(dateString)"
                                                )
                                            }
                                        }
                                    }
                                    print(
                                        "-------------------------------------------------"
                                    )
                                }
                            }

                            // ДЕБАГ ДЕБАГ

                            dismiss()
                        } else {
                            showAlert = true
                            print("Разрешение на уведомления не получено.")
                        }
                    }

                },
                label: {
                    Text("Apply")
                        .frame(width: 240, height: 32)
                }
            )
            .buttonStyle(.borderedProminent)
            .cornerRadius(16)
        }
    }

    var selectHourAndMinutes: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: [.hourAndMinute]
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .frame(width: 264)
    }
}

extension NotificationModalScreenView {

    private func weekdayName(for dayNumber: Int, short: Bool = false) -> String
    {
        let formatter = DateFormatter()
        let symbols =
            short ? formatter.shortWeekdaySymbols : formatter.weekdaySymbols
        guard let symbols = symbols, dayNumber > 0, dayNumber <= symbols.count
        else { return "" }
        return symbols[dayNumber - 1]
    }

    /// Рассчитывает и форматирует следующие несколько дат срабатывания для дебага.
    private func getNextTriggerDates(
        from firstDate: Date,
        frequencyIndex: Int,
        count: Int = 3
    ) -> [String] {
        let calendar = Calendar.current
        var dates: [Date] = [firstDate]

        var dateComponent: Calendar.Component
        switch frequencyIndex {
        case 0:  // Daily
            dateComponent = .day
        case 1:  // Weekly
            dateComponent = .weekOfYear
        case 2:  // Monthly
            dateComponent = .month
        default:
            dateComponent = .day
        }

        for _ in 1..<count {
            if let lastDate = dates.last,
                let nextDate = calendar.date(
                    byAdding: dateComponent,
                    value: 1,
                    to: lastDate
                )
            {
                dates.append(nextDate)
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
        return dates.map { formatter.string(from: $0) }
    }
}

#Preview {
    NotificationModalScreenView()
}
