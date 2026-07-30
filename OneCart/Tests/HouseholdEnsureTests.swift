import CoreData
@testable import OneCart
import XCTest

@MainActor
final class HouseholdEnsureTests: XCTestCase {
    func testEnsureHouseholdCreatesCartWhenEmpty() async throws {
        let persistence = PersistenceController(inMemory: true, cloudKitEnabled: false)
        try await persistence.load()
        let defaults = try makeDefaults()
        let account = OneCartAccount(id: UUID(), displayName: "Max")
        let session = AppSession(
            persistence: persistence,
            preferences: DevicePreferences(defaults: defaults),
            defaults: defaults
        )
        try session.bootstrapTestingSession(account: account)
        XCTAssertNil(session.activeFamilySpace)
        XCTAssertTrue(session.familySpaces.isEmpty)

        await session.ensureHouseholdCartIfNeeded()

        XCTAssertNotNil(session.activeFamilySpace)
        XCTAssertFalse(session.householdCartBootstrapFailed)
        XCTAssertFalse(session.isEnsuringHouseholdCart)
    }

    func testEnsureHouseholdNoOpWhenActiveFamilyExists() async throws {
        let persistence = PersistenceController(inMemory: true, cloudKitEnabled: false)
        try await persistence.load()
        let defaults = try makeDefaults()
        let account = OneCartAccount(id: UUID(), displayName: "Max")
        let repository = FamilySpaceRepository(
            persistence: persistence,
            permissionAuthorizer: AllowAllPermissionAuthorizer()
        )
        let familyID = try await repository.createFamilySpace(
            name: "Cart",
            cachedForUserID: account.id,
            isHouseholdDefault: true
        )
        defaults.set(familyID.uuidString, forKey: "onecart.active-family-space-id.\(account.id.uuidString)")
        let session = AppSession(
            persistence: persistence,
            preferences: DevicePreferences(defaults: defaults),
            defaults: defaults
        )
        try session.bootstrapTestingSession(account: account)
        XCTAssertEqual(session.activeFamilySpace?.id, familyID)

        await session.ensureHouseholdCartIfNeeded()

        XCTAssertEqual(session.activeFamilySpace?.id, familyID)
        XCTAssertFalse(session.householdCartBootstrapFailed)
    }

    func testEnsureHouseholdAdoptsSharedWhileOnPrivate() async throws {
        let persistence = PersistenceController(inMemory: true, cloudKitEnabled: false)
        try await persistence.load()
        let defaults = try makeDefaults()
        let account = OneCartAccount(id: UUID(), displayName: "Max")
        let repository = FamilySpaceRepository(
            persistence: persistence,
            permissionAuthorizer: AllowAllPermissionAuthorizer()
        )
        let privateID = try await repository.createFamilySpace(
            name: "Private",
            cachedForUserID: account.id,
            isHouseholdDefault: true
        )
        let sharedID = UUID()
        try await persistence.performBackgroundTask { context in
            let space = FamilySpace(context: context)
            try persistence.assign(space, to: .shared, in: context)
            space.id = sharedID
            space.name = "Shared"
            space.createdAt = Date()
            space.updatedAt = Date()
            space.isHouseholdDefault = NSNumber(value: true)
        }
        defaults.set(
            privateID.uuidString,
            forKey: "onecart.active-family-space-id.\(account.id.uuidString)"
        )
        let session = AppSession(
            persistence: persistence,
            preferences: DevicePreferences(defaults: defaults),
            defaults: defaults
        )
        try session.bootstrapTestingSession(account: account)
        XCTAssertEqual(session.activeFamilySpace?.id, privateID)

        await session.ensureHouseholdCartIfNeeded()

        XCTAssertEqual(session.activeFamilySpace?.id, sharedID)
        XCTAssertEqual(session.persistence.scope(for: try XCTUnwrap(session.activeFamilySpace)), .shared)
    }
}
