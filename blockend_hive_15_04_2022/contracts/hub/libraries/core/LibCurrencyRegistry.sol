//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/LibAccessControl.sol";

// @Note CurrencyRegistry is separated from Exchange mainly to ease checks for Holding and Fee, and to separately register fiat and crypto easily
library LibCurrencyRegistry {
    bytes32 constant STORAGE_POSITION_CURRENCYREGISTRY =
        keccak256("ds.currencyregistry");

    struct StorageCurrencyRegistry {
        address nativeToken;
        mapping(bytes32 => bool) currencyKeyToSupported;
        mapping(bytes32 => bool) currencyKeyToCrypto;
    }

    function _storageCurrencyRegistry()
        internal
        pure
        returns (StorageCurrencyRegistry storage s)
    {
        bytes32 position = STORAGE_POSITION_CURRENCYREGISTRY;
        assembly {
            s.slot := position
        }
    }

    function _requireCurrencySupported(bytes32 _key) internal view {
        require(
            _storageCurrencyRegistry().currencyKeyToSupported[_key],
            "LibCurrencyRegistry: Currency not supported"
        );
    }

    // _requireIsCrypto does NOT check if is ERC20
    function _requireIsCrypto(bytes32 _key) internal view {
        require(
            _storageCurrencyRegistry().currencyKeyToCrypto[_key],
            "LibCurrencyRegistry: Not crypto"
        );
    }

    event NativeTokenSet(address indexed sender, address token);

    function _setNativeToken(address _token) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.DEFAULT_ADMIN_ROLE);

        _storageCurrencyRegistry().nativeToken = _token;

        emit NativeTokenSet(msg.sender, _token);
    }

    // code must follow: ISO-4217 Currency Code Standard: https://www.iso.org/iso-4217-currency-codes.html
    function _registerFiat(string memory _code) internal returns (bytes32) {
        require(
            bytes(_code).length != 0,
            "LibCurrencyRegistry: Empty code string"
        );
        bytes32 key = _encode_code(_code); //keccak256(abi.encode(_code));
        _register(key);
        return key;
    }

    function _encode_code(string memory _code) internal pure returns (bytes32) {
        return keccak256(abi.encode(_code));
    }

    function _registerCrypto(address _token) internal returns (bytes32) {
        require(
            _token != address(0),
            "LibCurrencyRegistry: Zero token address"
        );
        bytes32 key = _encode_token(_token); //bytes32(uint256(uint160(_token)) << 96);
        _register(key);
        _storageCurrencyRegistry().currencyKeyToCrypto[key] = true;
        return key;
    }

    function _encode_token(address _token) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_token)) << 96); // cannot be decoded
        // encode address: bytes32(uint256(uint160(_address)))
        // decode address: address(uint160(uint256(encoding)))
    }

    event CurrencyRegistered(address indexed sender, bytes32 key);

    function _register(bytes32 _key) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);
        _storageCurrencyRegistry().currencyKeyToSupported[_key] = true;

        emit CurrencyRegistered(msg.sender, _key);
    }

    event CurrencyRemoved(address indexed sender, bytes32 key);

    function _removeCurrency(bytes32 _key) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);
        _requireCurrencySupported(_key);
        StorageCurrencyRegistry storage s1 = _storageCurrencyRegistry();
        delete s1.currencyKeyToSupported[_key]; // delete cheaper than set false

        if (s1.currencyKeyToCrypto[_key]) {
            delete s1.currencyKeyToCrypto[_key];
        }

        emit CurrencyRemoved(msg.sender, _key);
    }
}
