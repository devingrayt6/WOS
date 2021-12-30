// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.3.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.3.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.3.2/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts@4.3.2/utils/Context.sol";

contract WinOrSell is Context, AccessControlEnumerable, ERC20Burnable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
    }

    function decimals() public pure override returns (uint8) {
		return 0;
	}

    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
        _mint(to, amount);
    }

    function _shrink(address from, address to) private{
        if(
        from != address(0x0)
        &&
        to != address(0x0)
        &&
        from != address(this)
        )
        {
            if(balanceOf(address(this)) > 0)
            {
                this.burn(1);
            }else if(totalSupply() > 2){
                burn(1);
            }else{
                burn(1);
                this.mint(to, 250000000);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20) {
        _shrink(from, to);
        super._beforeTokenTransfer(from, to, amount);
    }

}