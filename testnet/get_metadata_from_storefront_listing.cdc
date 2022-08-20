import MetadataViews from 0x631e88ae7f1d7c20
import AeraPack from 0x46625f59708ec2f8

pub struct PurchaseData {
    pub let id: UInt64
    pub let name: String
    pub let amount: UFix64
    pub let description: String
    pub let imageURL: String

    init(id: UInt64, name: String, amount: UFix64, description: String, imageURL: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.description = description
        self.imageURL = imageURL
    }
}

// IMPORTANT: Parameter list below should match the parameter list passed to the associated purchase txn
// Please also make sure that the argument order list should be same as that of the associated purchase txn
pub fun main(marketplace: Address, packIds:[UInt64], totalAmount: UFix64, signatures: [String], prices: [UFix64]): PurchaseData {

	let collection = getAccount(0x46625f59708ec2f8).getCapability(AeraPack.CollectionPublicPath).borrow<&{MetadataViews.ResolverCollection}>()
		?? panic("Could not borrow a reference to the collection")

	let displays: {UInt64: MetadataViews.Display} = {}
	for id in packIds {
		let nft = collection.borrowViewResolver(id: id)
		displays[id] = nft.resolveView(Type<MetadataViews.Display>())! as! MetadataViews.Display 
	}

	let firstPackId = packIds[0]
	let ipfsCid = (displays[firstPackId]!.thumbnail as! MetadataViews.IPFSFile).cid
	let purchaseData = PurchaseData(
		// id is the only field that doesn't make 100% sense for bulk purchase
		id: firstPackId,
		name: packIds.length.toString().concat(" x ".concat(displays[firstPackId]!.name)),
		amount: totalAmount,
		description: displays[firstPackId]!.description,
		imageURL: "https://nftstorage.link/ipfs/".concat(ipfsCid),
	)

    return purchaseData
}
