// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // comment example no meaning
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Guts", "Bones", "Holes", "Brain", "Xylem", "Switch", "Emptiness", "Anthem", "Remains", "Yourself", "Worms", "Crickets", "18wheels"];
    string[] secondWords = ["Dreams", "Ominous", "Hollow", "Gentle", "Fold", "Willingness", "Icebox", "Ridge", "Pulse", "Poise", "Silk", "Darkness", "Speed"];
    string[] thirdWords = ["Creature", "Height", "Trunk", "Ventilation", "Again", "Used", "His", "Molecular", "Runway", "Elastic", "Strung", "Behometh", "Halves"];

    constructor() ERC721 ("RyanNFT", "ROT") {
        console.log("this is my fist nft");
    }


    function pickRandomFirstWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("First Word", Strings.toString(_tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Second Word", Strings.toString(_tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Third Word", Strings.toString(_tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord,"</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log(finalTokenURI);
        
        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenURI);

        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}
