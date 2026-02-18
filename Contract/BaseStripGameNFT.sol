// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * Base Strip Game NFT (Open Edition)
 * - Fixed price mint
 * - Stores characterId per token (1..5)
 * - tokenURI = baseURI + characterId + ".json"
 *
 * NOTE (MVP): game progression is client-side and can be spoofed.
 * For real gating, add a backend signer (EIP-712 voucher) or onchain proofs.
 */
contract BaseStripGameNFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MINT_PRICE = 0.0001 ether;

    uint256 public totalSupply;
    string public baseTokenURI; // e.g. "ipfs://<cid>/"

    mapping(uint256 => uint8) public characterOf; // tokenId -> characterId

    error InvalidCharacter();
    error WrongPrice();
    error WithdrawFailed();

    event Minted(address indexed to, uint256 indexed tokenId, uint8 indexed characterId);
    event BaseURISet(string baseTokenURI);

    constructor(string memory _baseTokenURI) ERC721("Base Strip Game", "BSG") Ownable(msg.sender) {
        baseTokenURI = _baseTokenURI;
        emit BaseURISet(_baseTokenURI);
    }

    function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
        emit BaseURISet(_baseTokenURI);
    }

    function mint(uint8 characterId) external payable returns (uint256 tokenId) {
        if (msg.value != MINT_PRICE) revert WrongPrice();
        if (characterId < 1 || characterId > 5) revert InvalidCharacter();

        tokenId = ++totalSupply;
        characterOf[tokenId] = characterId;
        _safeMint(msg.sender, tokenId);

        emit Minted(msg.sender, tokenId, characterId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // OpenZeppelin ERC721 v5: _exists() was removed. Use _requireOwned().
        _requireOwned(tokenId);
        uint8 characterId = characterOf[tokenId];
        return string.concat(baseTokenURI, uint256(characterId).toString(), ".json");
    }

    function withdraw(address payable to) external onlyOwner {
        (bool ok, ) = to.call{value: address(this).balance}("");
        if (!ok) revert WithdrawFailed();
    }
}

