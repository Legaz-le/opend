import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import HashMap "mo:base/HashMap";
import NFTActorClass "../NFT/nft";

actor OpenD {

  var mapOfNFTs = HashMap.HashMap<Principal,NFTActorClass.NFT>(1, Principal.equal, Principal.hash);
  var mapOfOwners = HashMap.HashMap<Principal, List.List<Principal>>(1, Principal.equal, Principal.hash);

 
  public shared(msg) func mint(imgData: [Nat8], name: Text) : async Principal {
    let owner: Principal = msg.caller;

    Cycles.add(100_500_000_000);
    let newNFT =  await NFTActorClass.NFT(name, owner, imgData);

    let newNFTPrincipal = await newNFT.getCanisterId();

    mapOfNFTs.put(newNFTPrincipal,newNFT);
    addToOwnershipMap(owner, newNFTPrincipal);


    return newNFTPrincipal
  };

  private func addToOwnershipMap(owner: Principal, nftId: Principal){
    var ownedNFTs : List.List<Principal> = switch(mapOfOwners.get(owner)) {
      case null List.nil<Principal>();
      case (?result) result;
    };

    ownedNFTs := List.push(nftId, ownedNFTs);
    mapOfOwners.put(owner,ownedNFTs);
  };

  public query func getOwnedNFTs(user: Principal) : async [Principal]{
    var userNFTs : List.List<Principal> = switch(mapOfOwners.get(user)){
      case null List.nil<Principal>();
      case (?result) result;
    };

    return List.toArray(userNFTs);

  }
};
