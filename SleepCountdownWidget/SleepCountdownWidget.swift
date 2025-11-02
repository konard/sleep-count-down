import WidgetKit
import SwiftUI

// MARK: - User Defaults for Bedtime
extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.com.example.SleepCountdown")

    var bedtimeHour: Int {
        get { integer(forKey: "bedtimeHour") }
        set { set(newValue, forKey: "bedtimeHour") }
    }

    var bedtimeMinute: Int {
        get { integer(forKey: "bedtimeMinute") }
        set { set(newValue, forKey: "bedtimeMinute") }
    }
}

// MARK: - Timeline Entry
struct SleepCountdownEntry: TimelineEntry {
    let date: Date
    let bedtime: Date?
    let countdown: String
}

// MARK: - Timeline Provider
struct SleepCountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> SleepCountdownEntry {
        SleepCountdownEntry(
            date: Date(),
            bedtime: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()),
            countdown: "2h 30m"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SleepCountdownEntry) -> Void) {
        let entry = createEntry(for: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SleepCountdownEntry>) -> Void) {
        var entries: [SleepCountdownEntry] = []
        let currentDate = Date()

        // Generate entries for the next 24 hours, updating every 5 minutes
        for minuteOffset in stride(from: 0, to: 24 * 60, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = createEntry(for: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func createEntry(for date: Date) -> SleepCountdownEntry {
        let bedtime = calculateNextBedtime(from: date)
        let countdown = formatCountdown(from: date, to: bedtime)

        return SleepCountdownEntry(
            date: date,
            bedtime: bedtime,
            countdown: countdown
        )
    }

    private func calculateNextBedtime(from currentDate: Date) -> Date? {
        let defaults = UserDefaults.appGroup ?? UserDefaults.standard
        let hour = defaults.bedtimeHour == 0 ? 22 : defaults.bedtimeHour
        let minute = defaults.bedtimeMinute

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.hour = hour
        components.minute = minute
        components.second = 0

        guard var bedtime = calendar.date(from: components) else { return nil }

        // If bedtime has passed today, use tomorrow's bedtime
        if bedtime <= currentDate {
            bedtime = calendar.date(byAdding: .day, value: 1, to: bedtime)!
        }

        return bedtime
    }

    private func formatCountdown(from currentDate: Date, to bedtime: Date?) -> String {
        guard let bedtime = bedtime else {
            return "Set bedtime in Settings"
        }

        let interval = bedtime.timeIntervalSince(currentDate)

        if interval < 0 {
            return "Past bedtime"
        }

        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Bedtime now!"
        }
    }
}

// MARK: - Widget View
struct SleepCountdownWidgetView: View {
    var entry: SleepCountdownProvider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            largeWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(spacing: 8) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 30))
                .foregroundColor(.blue)

            Text(entry.countdown)
                .font(.title2)
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Text("to bedtime")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }

    private var mediumWidget: some View {
        HStack(spacing: 20) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 8) {
                Text(entry.countdown)
                    .font(.title)
                    .fontWeight(.bold)

                Text("until bedtime")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let bedtime = entry.bedtime {
                    Text("at \(bedtime, style: .time)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }

    private var largeWidget: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            Text(entry.countdown)
                .font(.system(size: 48, weight: .bold))

            Text("until bedtime")
                .font(.title3)
                .foregroundColor(.secondary)

            if let bedtime = entry.bedtime {
                VStack(spacing: 8) {
                    Text("Bedtime at")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(bedtime, style: .time)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Widget Configuration
struct SleepCountdownWidget: Widget {
    let kind: String = "SleepCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SleepCountdownProvider()) { entry in
            SleepCountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("Sleep Countdown")
        .description("Shows countdown to your bedtime.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    SleepCountdownWidget()
} timeline: {
    SleepCountdownEntry(
        date: Date(),
        bedtime: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()),
        countdown: "2h 30m"
    )
    SleepCountdownEntry(
        date: Date().addingTimeInterval(3600),
        bedtime: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()),
        countdown: "1h 30m"
    )
}
