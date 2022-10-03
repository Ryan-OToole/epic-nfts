// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;


// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    uint256 public constant maxSupply = 25;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // comment example no meaning
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Guts", "Bones", "Holes", "Brain", "Xylem", "Switch", "Emptiness", "Anthem", "Remains", "Yourself", "Worms", "Crickets", "18wheels"];
    string[] secondWords = ["Dreams", "Ominous", "Hollow", "Gentle", "Fold", "Willingness", "Icebox", "Ridge", "Pulse", "Poise", "Silk", "Darkness", "Speed"];
    string[] thirdWords = ["Creature", "Height", "Trunk", "Ventilation", "Again", "Used", "His", "Molecular", "Runway", "Elastic", "Strung", "Behometh", "Halves"];
    string[] colors = ["orange", "yellow", "red", "blue", "#6B5B95", "#B565A7", "#F7CAC9", "#955251"];

    event newEpicNFTMinted(address sender, uint tokenId);

    constructor() ERC721 ("GentleAgainNFT", "GEN") {
        _tokenIds.increment();
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

    function pickRandomColor(uint256 _tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(_tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function totalSupply() public view returns (uint) {
        return _tokenIds.current();
    }

    function makeAnEpicNFT() public {
        require(totalSupply() <= maxSupply, "MAX Number of NFTs minted Sorry =(");
        uint256 newItemId = _tokenIds.current();
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        string memory randomColor = pickRandomColor(newItemId);

        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

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

        emit newEpicNFTMinted(msg.sender, newItemId);
        
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}
