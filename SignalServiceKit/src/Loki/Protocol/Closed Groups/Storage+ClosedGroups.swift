
internal extension Storage {

    // MARK: Ratchets
    internal static func getClosedGroupRatchetCollection(for groupPublicKey: String) -> String {
        return "LokiClosedGroupRatchetCollection.\(groupPublicKey)"
    }

    internal static func getClosedGroupRatchet(for groupPublicKey: String, senderPublicKey: String) -> ClosedGroupRatchet? {
        let collection = getClosedGroupRatchetCollection(for: groupPublicKey)
        var result: ClosedGroupRatchet?
        read { transaction in
            result = transaction.object(forKey: senderPublicKey, inCollection: collection) as? ClosedGroupRatchet
        }
        return result
    }

    internal static func setClosedGroupRatchet(for groupPublicKey: String, senderPublicKey: String, ratchet: ClosedGroupRatchet, using transaction: YapDatabaseReadWriteTransaction) {
        let collection = getClosedGroupRatchetCollection(for: groupPublicKey)
        transaction.setObject(ratchet, forKey: senderPublicKey, inCollection: collection)
    }

    internal static func getAllClosedGroupRatchets(for groupPublicKey: String) -> Set<ClosedGroupRatchet> {
        let collection = getClosedGroupRatchetCollection(for: groupPublicKey)
        var result: Set<ClosedGroupRatchet> = []
        read { transaction in
            transaction.enumerateRows(inCollection: collection) { _, object, _, _ in
                guard let ratchet = object as? ClosedGroupRatchet else { return }
                result.insert(ratchet)
            }
        }
        return result
    }

    internal static func removeAllClosedGroupRatchets(for groupPublicKey: String, using transaction: YapDatabaseReadWriteTransaction) {
        let collection = getClosedGroupRatchetCollection(for: groupPublicKey)
        transaction.removeAllObjects(inCollection: collection)
    }
}

@objc internal extension Storage {

    // MARK: Private Keys
    internal static let closedGroupPrivateKeyCollection = "LokiClosedGroupPrivateKeyCollection"

    internal static func getUserClosedGroupPublicKeys() -> Set<String> {
        var result: Set<String> = []
        read { transaction in
            result = Set(transaction.allKeys(inCollection: closedGroupPrivateKeyCollection))
        }
        return result
    }

    @objc(getPrivateKeyForClosedGroupWithPublicKey:)
    internal static func getClosedGroupPrivateKey(for publicKey: String) -> String? {
        var result: String?
        read { transaction in
            result = transaction.object(forKey: publicKey, inCollection: closedGroupPrivateKeyCollection) as? String
        }
        return result
    }

    internal static func setClosedGroupPrivateKey(_ privateKey: String, for publicKey: String, using transaction: YapDatabaseReadWriteTransaction) {
        transaction.setObject(privateKey, forKey: publicKey, inCollection: closedGroupPrivateKeyCollection)
    }

    internal static func removeClosedGroupPrivateKey(for publicKey: String, using transaction: YapDatabaseReadWriteTransaction) {
        transaction.removeObject(forKey: publicKey, inCollection: closedGroupPrivateKeyCollection)
    }
}
