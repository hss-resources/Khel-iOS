//
//  KhelWidget.swift
//  KhelWidget
//
//  Created by Janak Shah on 19/09/2020.
//  Copyright © 2020 App Ktchn. All rights reserved.
//

import WidgetKit
import SwiftUI
import PlistManager

//TODO: Deeplink to open the KhelDetailView

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> KhelEntry {
        KhelEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (KhelEntry) -> Void) {
        let entry = KhelEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        
        let entryDateString = dateFormatter.string(from: entryDate)

        let timeline = Timeline(entries: [KhelEntry(date: currentDate), KhelEntry(date: dateFormatter.date(from: entryDateString) ?? entryDate)], policy: .atEnd)
        completion(timeline)
        
    }
    
}

struct KhelEntry: TimelineEntry {
    let date: Date
    var khel: Khel?
        
    static func onlyDayDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    func randomKhel() -> Khel {
        
        if let stored = PlistManager.get(StoredWidgetData.self, from: String(describing: StoredWidgetData.self)),
           stored.date == KhelEntry.onlyDayDateString(Date()) {
            return stored.khel
        }
        
        let allKhels: [Khel] = {
            if let url = Bundle.app.url(forResource: "khel", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    return try decoder.decode([Khel].self, from: data)
                } catch {
                    print("error:\(error)")
                }
            }
            return []
        }()
        let newKhel = allKhels.randomElement() ?? placeholderKhel()
        PlistManager.save(StoredWidgetData(date: KhelEntry.onlyDayDateString(Date()), khel: newKhel), plistName: String(describing: StoredWidgetData.self))
        return newKhel
    }
    
    func placeholderKhel() -> Khel {
        return Khel(name: "Dand Pakado",
                    meaning: "Hold the Dand!",
                    aim: "Objective is to catch and stop the Dand from falling onto the ground when the shikshak lets go.",
                    description: "All swayamsevaks will stand on the circumference of the circle and each is given a number. The shikshak will stand in the middle of the circle holding the dand at one end, whilst the other end is touch the ground. The shikshak will shout out a number and at the same time will let go of the dand. The swayamsevak whose number is called will quickly run to catch the dand before it falls onto the ground. Those who are not successful are out of the game. The radius of the circle can be increased to make the activity, more difficult.",
                    category: .dand)
    }
    
}

struct KhelWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        
        let khel = entry.randomKhel()
        
        HStack(content: {
            VStack(alignment: .leading, spacing: 6) {
                Text("Khel of the day")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Image("runIcon")
                    .resizable()
                    .frame(width: 24.0, height: 24.0)
                Text(khel.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                Text(khel.category.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .background(Color(khel.category.color))
                    .cornerRadius(5)
                Spacer()
            }
            Spacer()
        })
        .padding(16)
        .widgetURL(URL(string: "khel.widget://" + khel.name ))
    }
}

@main
struct KhelWidget: Widget {
    let kind: String = "KhelWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KhelWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.80, green: 0.56, blue: 0.03), Color(red: 0.96, green: 0.69, blue: 0.10)]), startPoint: .top, endPoint: .bottom))
        }
        .configurationDisplayName("Khel of the day")
        .description("Discover a new khel every day")
        .supportedFamilies([.systemSmall])
    }
}

struct KhelWidget_Previews: PreviewProvider {
    static var previews: some View {
        KhelWidgetEntryView(entry: KhelEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Bundle {
    /// Return the main bundle when in the app or an app extension.
    static var app: Bundle {
        var components = main.bundleURL.path.split(separator: "/")
        var bundle: Bundle?

        if let index = components.lastIndex(where: { $0.hasSuffix(".app") }) {
            components.removeLast((components.count - 1) - index)
            bundle = Bundle(path: components.joined(separator: "/"))
        }

        return bundle ?? main
    }
}
