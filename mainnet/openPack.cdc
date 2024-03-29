import AeraPack from 0x30cf5dcf6ea8d379
import AeraPackExtraData from 0x30cf5dcf6ea8d379
import FungibleToken from 0xf233dcee88fe0abe
import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448

/// A transaction to open a pack with a given id
/// @param packId: The id of the pack to open
transaction(packId:UInt64) {

    let packs: &AeraPack.Collection
    let receiver: Capability<&{NonFungibleToken.Receiver}>

    prepare(account: AuthAccount) {
        self.packs=account.borrow<&AeraPack.Collection>(from: AeraPack.CollectionStoragePath)!
        let pack = self.packs.borrowAeraPack(id: packId) ?? panic("You do not own pack with Id : ".concat(packId.toString()))
        let path = AeraPackExtraData.getReceiverPathPerPackType(pack.getTypeID())!
        self.receiver = account.getCapability<&{NonFungibleToken.Receiver}>(PublicPath(identifier: path)!)
    }

    pre {
        self.receiver.check() : "The receiver collection for the packs is not present"
    }
    execute {
        self.packs.open(packId: packId, receiverCap:self.receiver)
    }

    post {
        !self.packs.getIDs().contains(packId) : "The pack is still present in the users collection"
    }
}
