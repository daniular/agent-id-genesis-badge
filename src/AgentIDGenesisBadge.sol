// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Agent ID Genesis Badge
/// @notice A free commemorative ERC-721 for Binance Agent ID holders.
///         1 badge per Agent ID, claimable gas-only (value 0).
///         Eligibility is verified on-chain against the SPACE ID Agent ID
///         registry (0x60b9262456de011f7d15a54cdd8c48baaa8b022f, BSC).
/// @dev Minimal hand-rolled ERC-721 (no OpenZeppelin) to keep deployment
///      gas small. No owner, no admin functions, no pause, no withdraw —
///      the contract is fully permissionless: the ONLY way to mint is
///      claim() by an Agent ID holder, and claim() is non-payable (value 0).
///      Metadata is served off-chain via baseURI + tokenId.
interface IAgentID {
    function balanceOf(address owner) external view returns (uint256);
    function handleOf(address owner) external view returns (string memory);
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

contract AgentIDGenesisBadge {
    // ---------- registry ----------
    IAgentID public immutable registry;

    // ---------- ERC-721 storage ----------
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // ---------- badge state ----------
    mapping(bytes32 => bool) public claimed; // agentId (keccak256(handle)) => claimed
    uint256 public nextTokenId = 1;
    uint256 public totalSupply;
    string private _baseURI;

    // ---------- events ----------
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Claimed(address indexed claimer, bytes32 indexed agentId, uint256 indexed tokenId);

    constructor(address registry_, string memory baseURI_) {
        registry = IAgentID(registry_);
        _baseURI = baseURI_;
    }

    // ---------- metadata ----------
    function name() external pure returns (string memory) {
        return "Agent ID Genesis Badge";
    }

    function symbol() external pure returns (string memory) {
        return "AIDGB";
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "Nonexistent token");
        return string.concat(_baseURI, _toString(tokenId));
    }

    // ---------- claim ----------
    /// @notice Claim the one free badge for your Agent ID. Value must be 0
    ///         (this function is non-payable, so any attached value reverts).
    function claim() external {
        require(registry.balanceOf(msg.sender) > 0, "No Agent ID");
        string memory handle = registry.handleOf(msg.sender);
        bytes32 agentId = keccak256(bytes(handle));
        require(!claimed[agentId], "Already claimed");
        claimed[agentId] = true;

        uint256 tokenId = nextTokenId++;
        totalSupply++;
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;

        emit Transfer(address(0), msg.sender, tokenId);
        emit Claimed(msg.sender, agentId, tokenId);
    }

    // ---------- ERC-721 core ----------
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Nonexistent token");
        return owner;
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _owners[tokenId];
        require(owner != address(0), "Nonexistent token");
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender], "Not authorized");
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        require(_owners[tokenId] != address(0), "Nonexistent token");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_owners[tokenId] != address(0), "Nonexistent token");
        require(to != address(0), "Zero address");
        address owner = _owners[tokenId];
        require(from == owner, "Not owner");
        require(
            msg.sender == owner ||
            _tokenApprovals[tokenId] == msg.sender ||
            _operatorApprovals[owner][msg.sender],
            "Not authorized"
        );
        delete _tokenApprovals[tokenId];
        _owners[tokenId] = to;
        unchecked {
            _balances[from]--;
            _balances[to]++;
        }
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(msg.sender, from, to, tokenId, ""), "Not ERC721Receiver");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(msg.sender, from, to, tokenId, data), "Not ERC721Receiver");
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165
            interfaceId == 0x80ac58cd || // ERC721
            interfaceId == 0x5b5e139f;   // ERC721Metadata
    }

    // ---------- internals ----------
    function _checkOnERC721Received(address operator, address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
        if (to.code.length == 0) return true;
        (bool success, bytes memory ret) = to.call(
            abi.encodeWithSelector(IERC721Receiver.onERC721Received.selector, operator, from, tokenId, data)
        );
        return success && ret.length == 32 && abi.decode(ret, (bytes4)) == IERC721Receiver.onERC721Received.selector;
    }

    function _toString(uint256 value) private pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits = 0;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            // casting to uint8 is safe: value % 10 is 0-9, +48 is 48-57 (ASCII digits)
            // forge-lint: disable-next-line(unsafe-typecast)
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
