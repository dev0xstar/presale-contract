pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KakaoERC is ERC20 {
    
    constructor(uint256 _amount) ERC20("UsdcToken", "UTK"){
        _mint(msg.sender, _amount);
    }
}