//
//  Yokune.swift
//  FinanceApp
//
//  Yokune (reaction) model
//

import Foundation
import SwiftData

@Model
final class Yokune: @unchecked Sendable {
    @Attribute(.unique) var id: UUID
    var fromUserId: UUID
    var activityId: UUID
    var createdAt: Date

    init(
        id: UUID = UUID(),
        fromUserId: UUID,
        activityId: UUID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.fromUserId = fromUserId
        self.activityId = activityId
        self.createdAt = createdAt
    }
}
