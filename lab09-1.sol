pragma solidity ^0.6.1;
    // Set the Solidity compiler version.

contract MyERC20Token {
    mapping (address => uint256) _balances;
        // Stores token balance for each address.
    mapping (address => mapping(address => uint256)) _allowed;
        // Stores approvals: how much an address allows another to use.

    string public name = "My ERC20 Token";
        // Token name (for display).
    string public symbol = "MET";
        // Token symbol/abbreviation.
    uint8 public decimals = 0;
        // Number of decimal places (0 = whole tokens only).
    uint256 private _totalSupply = 100;
        // The total number of tokens created.

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
        // Event that logs transfers.
    event Approval(address indexed _owner, address indexed _spender, uint256 value);
        // Event that logs approvals.

    constructor() public {
        _balances[msg.sender] = _totalSupply;
            // Assign all tokens to contract creator.
        emit Transfer(address(0), msg.sender, _totalSupply);
            // Emit event to show tokens minted to creator.
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply - _balances[address(0)];
            // Returns total supply (excluding burned tokens).
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return _balances[_owner];
            // Returns the token balance of a specific address.
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return _allowed[_owner][_spender];
            // Returns the approved amount spender can use from owner.
    }

    function transfer(address _to, uint256 _value) public returns (bool success)
    {
        require(_balances[msg.sender] >= _value,"value exceeds senders balance");
            // Checks if sender has enough tokens.
        _balances[msg.sender] -= _value;
            // Deduct tokens from sender.
        _balances[_to] += _value;
            // Add tokens to receiver.
        emit Transfer(msg.sender, _to, _value);
            // Emit event for the transfer.
        return true;
            // Return success.
    }

    function approve(address _spender, uint256 _value) public returns (bool success)
    {
        _allowed[msg.sender][_spender] = _value;
            // Set allowance for spender to use sender's tokens.
        emit Approval(msg.sender, _spender, _value);
            // Emit approval event.
        return true;
            // Return success.
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        require(_value <= _balances[_from], "Not enough balance");
            // Check if _from has enough tokens.
        require(_value <= _allowed[_from][msg.sender], "Not enough allowance");
            // Check if caller is allowed to spend enough tokens.
        _balances[_from] -= _value;
            // Deduct tokens from _from.
        _balances[_to] += _value;
            // Add tokens to _to.
        _allowed[_from][msg.sender] -= _value;
            // Decrease allowance.
        emit Transfer(_from, _to, _value);
            // Emit transfer event.
        return true;
            // Return success.
    }
}
