//
//  NotificationModalScreenView.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 21.09.2025.
//

import SwiftUI

struct NotificationModalScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var hoursAndMinutes = Date()
    @State private var frequency = ["Daily", "Weekly", "Monthly"]
    @State private var selectedDate = Date()
    @State private var selectedFrequency = 0
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            modalWindow
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .alert("Notifications is turned off", isPresented: $showAlert) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Please allow us to access your iPhone notifications.")
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

            Picker("Выбор", selection: $selectedFrequency) {
                ForEach(0..<frequency.count, id: \.self) { index in
                    Text(frequency[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 300, height: 40)

            selectHourAndMinutes

            Button(
                action: {
                    Task {
                        let hasPermission = await NotificationService.shared
                            .checkForPermission()

                        if hasPermission {
                            let repeatingComponents = createRepeatingComponents(
                                frequencyIndex: selectedFrequency,
                                selectedTime: selectedDate
                            )
                            NotificationService.shared.cancelAll()

                            NotificationService.shared.dispatchNotification(
                                identifier: "cleaning_reminder",
                                title: "It's time to clean",
                                body: "Let's have some fun. This mop is sick",
                                dateComponents: repeatingComponents,
                                repeats: true
                            )
                            // --- ДЕБАГ-БЛОК ДЛЯ ПРОВЕРКИ ---
                            NotificationService.shared.getPending { requests in
                                print(
                                    "--- 📱 ПРОВЕРКА ЗАПЛАНИРОВАННЫХ УВЕДОМЛЕНИЙ ---"
                                )
                                guard
                                    let request = requests.first(where: {
                                        $0.identifier == "cleaning_reminder"
                                    })
                                else {
                                    print("🔴 Уведомление не найдено в очереди.")
                                    return
                                }

                                print("✅ Уведомление успешно запланировано!")
                                if let trigger = request.trigger
                                    as? UNCalendarNotificationTrigger
                                {
                                    print(
                                        "Компоненты для триггера: \(trigger.dateComponents)"
                                    )

                                    if let nextFireDate =
                                        trigger.nextTriggerDate()
                                    {
                                        // Вызываем нашу новую функцию для расчета следующих 3-х дат
                                        let nextThreeFires =
                                            self.getNextTriggerDates(
                                                from: nextFireDate,
                                                frequencyIndex: self
                                                    .selectedFrequency,  // Используем текущий выбор
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
                            // --- КОНЕЦ БЛОКА ДЛЯ ДЕБАГА ---
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

    private func createRepeatingComponents(
        frequencyIndex: Int,
        selectedTime: Date
    ) -> DateComponents {
        let calendar = Calendar.current
        let now = Date()

        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: selectedTime
        )

        var components = DateComponents()
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        switch frequencyIndex {
        case 1:
            components.weekday = calendar.component(.weekday, from: now)
        case 2:
            components.day = calendar.component(.day, from: now)
        default:  // Ежедневно
            break
        }

        return components
    }

    /// Рассчитывает и форматирует следующие несколько дат срабатывания для дебага.
    private func getNextTriggerDates(
        from firstDate: Date,
        frequencyIndex: Int,
        count: Int = 3
    ) -> [String] {
        let calendar = Calendar.current
        var dates: [Date] = [firstDate]

        // Определяем шаг для следующей даты
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

        // Рассчитываем следующие даты
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

        // Форматируем для вывода
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
        return dates.map { formatter.string(from: $0) }
    }
}

#Preview {
    NotificationModalScreenView()
}
