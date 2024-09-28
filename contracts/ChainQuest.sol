// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChainQuest is ERC721URIStorage, Ownable {
    uint256 public puzzleCount;
    uint256 public tokenCounter;
    mapping(uint256 => string) private puzzles;
    mapping(uint256 => bytes32) private solutions;
    mapping(address => bool) public completed;
    
    event PuzzleSolved(address indexed solver, uint256 puzzleId);
    event NFTMinted(address indexed solver, uint256 tokenId, uint256 puzzleId, string tokenURI); // New event for NFT minting

    constructor() ERC721("ChainQuestNFT", "CQN") Ownable(msg.sender) {
       
    }

    // Add new puzzles to the quest (owner only)
    // Solution is passed as a plain string and hashed inside the contract
    function addPuzzle(uint256 _puzzleId, string memory _puzzle, string memory _solution) public onlyOwner {
        puzzles[_puzzleId] = _puzzle;
        solutions[_puzzleId] = keccak256(abi.encodePacked(_solution)); // Hashing done here
        puzzleCount++;
    }

    // Get the puzzle details
    function getPuzzle(uint256 _puzzleId) public view returns (string memory) {
        require(_puzzleId < puzzleCount, "Puzzle does not exist");
        return puzzles[_puzzleId];
    }

    // Solve a puzzle by submitting the solution (not pre-hashed)
    function solvePuzzle(uint256 _puzzleId, string memory _solution) public {
        require(!completed[msg.sender], "Already completed");
        require(_puzzleId < puzzleCount, "Puzzle does not exist");

        bytes32 solutionHash = solutions[_puzzleId];
        bytes32 providedHash = keccak256(abi.encodePacked(_solution)); // Hashing again for comparison

        require(providedHash == solutionHash, "Incorrect solution");

        completed[msg.sender] = true;
        _mintNFT(msg.sender, _puzzleId);

        emit PuzzleSolved(msg.sender, _puzzleId);
    }

    // Mint an NFT as a reward
    function _mintNFT(address _solver, uint256 _puzzleId) internal {
        tokenCounter++;
        uint256 newItemId = tokenCounter;
        string memory tokenURI = string(abi.encodePacked("https://metadata-api.com/token/", uint2str(_puzzleId), ".json"));
        _safeMint(_solver, newItemId);
        _setTokenURI(newItemId, tokenURI);

        // Emit the NFTMinted event when an NFT is minted
        emit NFTMinted(_solver, newItemId, _puzzleId, tokenURI);
    }

    // Helper to convert uint to string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
