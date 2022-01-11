// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract Elements is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

  string[] elements = [
      "Hydrogen", "Helium", "Oxygen", "Carbon", "Neon", "Iron",
      "Nitrogen", "Silicon", "Magnesium", "Sulfur", "Argon", "Calcium",
      "Nickel", "Aluminum", "Sodium", "Chromium", "Manganese", "Phosphorus",
      "Cobalt", "Titanium", "Potassium", "Vanadium", "Chlorine", "Flourine",
      "Zinc", "Germanium", "Copper", "Zirconium", "Strontium", "Krypton",
      "Selenium", "Scandium", "Lead", "Neodymium", "Cerium", "Barium",
      "Xenon", "Rubidium", "Gallium", "Tellurium", "Arsenic", "Yttrium",
      "Bromine", "Lithium", "Platinum", "Samarium", "Molyndenum", "Tin",
      "Ruthenium", "Osmium", "Iridium", "Ytterbium", "Erbium", "Dysprosium",
      "Gadolinium", "Praseodymium", "Lanthanum", "Cadmium", "Palladium", "Niobium",
      "Mercury", "Iodine", "Boron", "Beryllium", "Cesium", "Bismuth",
      "Hafnium", "Gold", "Silver", "Rhodium", "Thallium", "Tungsten",
      "Holmium", "Terbium", "Europium", "Thorium", "Antimony", "Indium",
      "Uranium", "Rhenium", "Lutetium", "Thulium", "Tantalum"
  ];

  uint[] weights = [
      9375000000, 2875000000, 125000000, 62500000, 16250000, 13750000,
      12500000, 8750000, 7375000, 6250000, 2500000, 875000, 750000,
      625000, 250000, 187500, 100000, 87500, 37500, 37500, 37500,
      12500, 12500, 5000, 3750, 2500, 750, 625, 500, 500, 375, 375,
      125, 125, 125, 125, 125, 125, 125, 112, 100, 87, 87, 75, 62,
      62, 62, 50, 50, 37, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,
      12, 12, 12, 12, 10, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 5, 5, 3,
      2, 2, 1, 1, 1
  ];

  constructor() ERC721 ("Elements", "ELMNT") {
  }

  function accumulate(uint[] memory arr) public view returns ( uint[] memory ){
    uint[] memory acc = new uint[](arr.length);
    uint total = 0;
    for(uint i = 0; i <= arr.length-1; i++){
        total = total + arr[i];
        acc[i] = total;
    }
    return acc;
  }

  function bisect_left(uint[] memory a, uint x) public view returns ( uint256 ) {
    uint low = 0;
    uint hi = a.length;
    while ( low < hi ) {
        uint mid = ( low + hi )/2;
        if ( a[mid] < x ) {
            low = mid + 1;
        } else {
            hi = mid;
        }
    }
    return low;
  }

  function removeWeight(uint index) internal {
    require(index < weights.length);
    weights[index] = weights[weights.length-1];
    weights.pop();
  }

  function removeElement(uint index) internal {
    require(index < elements.length);
    elements[index] = elements[elements.length-1];
    elements.pop();
  }

  function wsample(string[] memory population, uint[] memory aweights, string memory eNum, uint tokenId) public payable returns ( string memory  ) {
    string memory sample;
    uint index = bisect_left(aweights, random(string(abi.encodePacked(eNum, Strings.toString(tokenId), block.timestamp)), aweights[aweights.length-1]));
    require(index < elements.length);
    sample = elements[index];
    removeElement(index);
    removeWeight(index);
    return sample;
  }

  function random(string memory input, uint max) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input))) % max;
  }

  function GetElement(string memory tokenNum, uint itemId) public payable returns (string memory) {
    uint[] memory addedweights = accumulate(weights);
    string memory sample = wsample(elements, addedweights, tokenNum, itemId);
    return sample;
  }

  function GeneratetokenURI(uint256 tokenId) public payable returns (string memory) {
        string[17] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = GetElement("FIRST", tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = GetElement("SECOND", tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = GetElement("THIRD", tokenId);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = GetElement("FOURTH", tokenId);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = GetElement("FIFTH", tokenId);

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = GetElement("SIXTH", tokenId);

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = GetElement("SEVENTH", tokenId);

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = GetElement("EIGHTH", tokenId);

        parts[16] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Set #', Strings.toString(tokenId), '", "description": "Element is a list of randomly generated elements based on their adundance in the universe. Feel free to use this in any way you choose.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

  event NewNFTMinted(address sender, uint256 tokenId);

  function BigBang() public {
    uint256 newItemId = _tokenIds.current();
    assert(newItemId <= 1);
    string memory URI = GeneratetokenURI(newItemId);

    //console.log("\n--------------------");
    //console.log(URI);
    //console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, URI);

    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewNFTMinted(msg.sender, newItemId);
  }
}