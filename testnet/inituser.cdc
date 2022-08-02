import AeraNFT from 0x46625f59708ec2f8
import AeraPack from 0x46625f59708ec2f8
import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0x631e88ae7f1d7c20
import FLOAT from 0x0afe396ebc8eee65

//Initialize a users storage slots for OneFootball
transaction {
    prepare(account: AuthAccount) {

        let aeraPackCap= account.getCapability<&{NonFungibleToken.CollectionPublic}>(AeraPack.CollectionPublicPath)
        if !aeraPackCap.check() {
            account.save<@NonFungibleToken.Collection>( <- AeraPack.createEmptyCollection(), to: AeraPack.CollectionStoragePath)
            account.link<&AeraPack.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, AeraPack.CollectionPublic, MetadataViews.ResolverCollection}>(
                AeraPack.CollectionPublicPath,
                target: AeraPack.CollectionStoragePath
            )
        }

        let aeraCap= account.getCapability<&{NonFungibleToken.CollectionPublic}>(AeraNFT.CollectionPublicPath)
        if !aeraCap.check() {
            account.save<@NonFungibleToken.Collection>(<- AeraNFT.createEmptyCollection(), to: AeraNFT.CollectionStoragePath)
            account.link<&AeraNFT.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection, AeraNFT.CollectionPublic}>(
                AeraNFT.CollectionPublicPath,
                target: AeraNFT.CollectionStoragePath
            )
            account.link<&AeraNFT.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection, AeraNFT.CollectionPublic}>(
                AeraNFT.CollectionPrivatePath,
                target: AeraNFT.CollectionStoragePath
            )
        }

        let floatCap= account.getCapability<&{NonFungibleToken.CollectionPublic}>(FLOAT.FLOATCollectionPublicPath)
        // if account.borrow<&FLOAT.Collection>(from: FLOAT.FLOATCollectionStoragePath) == nil
        if !floatCap.check() {
            // cannot cast to <@NonFungibleToken.Collection>
            account.save(<- FLOAT.createEmptyCollection(), to: FLOAT.FLOATCollectionStoragePath)
            account.link<&FLOAT.Collection{NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection, FLOAT.CollectionPublic}>(
                FLOAT.FLOATCollectionPublicPath,
                target: FLOAT.FLOATCollectionStoragePath
            )
        }
    }
}