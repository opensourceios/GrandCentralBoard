//
//  AreaBarChartComponentViewModel+FromDailyBillingStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-18.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit


extension AreaBarChartComponentViewModel {
    static func viewModelFromDailyBillingStats(dailyBillingStats: DailyBillingStats) -> AreaBarChartComponentViewModel? {
        guard dailyBillingStats.groups.count == 3 else {
            return nil
        }

        let indexes = 0...2
        let groups = dailyBillingStats.groups
        let colors = [UIColor.lipstick(), UIColor.aquaMarine(), UIColor.almostWhite()]

        let items = indexes.flatMap { index -> AreaBarItemViewModel? in
            let group = groups[index]
            let color = colors[index]
            let width = widthForGroup(group, groups: groups)
            let height = heightForGroup(group, groups: groups)
            let valueLabelMode = valueLabelModeForGroup(group, groups: groups)

            if (width > 0) {
                return AreaBarItemViewModel(proportionalWidth: width, proportionalHeight: height, color: color, valueLabelMode: valueLabelMode)

            } else {
                return nil
            }
        }

        let countLabelText = countLabelTextForDailyBillingStats(dailyBillingStats)
        let headerText = headerTextForDailyBillingStats(dailyBillingStats)
        let subheaderText = subheaderTextForDailyBillingStats(dailyBillingStats)

        return AreaBarChartComponentViewModel(barItems: items, horizontalAxisCountLabelText: countLabelText, headerText: headerText, subheaderText: subheaderText)
    }

    private static func widthForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> CGFloat {
        let count = group.count
        let totalCount = totalCountForGroups(groups)

        return CGFloat(count) / CGFloat(totalCount)
    }

    private static func heightForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> CGFloat {
        let maxHours = 8.0
        let hours = min(group.averageHours, maxHours)

        return CGFloat(hours / maxHours)
    }

    private static func valueLabelModeForGroup(group: BillingStatsGroup, groups: [BillingStatsGroup]) -> AreaBarItemValueLabelDisplayMode {
        let text = String(group.averageHours)

        switch group.type {
        case .Less:
            return .VisibleLabelLeft(text: text)
        case .Normal:
            return .VisibleWithHiddenLabel
        case .More:
            return .VisibleLabelRight(text: text)
        }
    }

    private static func countLabelTextForDailyBillingStats(dailyBillingStats: DailyBillingStats) -> String {
        let totalCount = totalCountForGroups(dailyBillingStats.groups)

        return String(totalCount)
    }

    private static func headerTextForDailyBillingStats(dailyBillingStats: DailyBillingStats) -> String {
        return "HARVEST BURN REPORT"
    }

    private static func subheaderTextForDailyBillingStats(dailyBillingStats: DailyBillingStats) -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE dd.MM.yyyy"

        return formatter.stringFromDate(dailyBillingStats.day)
    }

    private static func totalCountForGroups(groups: [BillingStatsGroup]) -> Int {
        return groups.reduce(0) { (count, group) in
            return count + group.count
        }
    }
}
