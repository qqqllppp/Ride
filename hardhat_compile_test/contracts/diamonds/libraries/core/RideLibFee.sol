//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibBadge.sol";
import "../../libraries/utils/RideLibAccessControl.sol";
import "../../libraries/core/RideLibCurrencyRegistry.sol";

library RideLibFee {
    bytes32 constant STORAGE_POSITION_FEE = keccak256("ds.fee");

    struct StorageFee {
        mapping(bytes32 => uint256) currencyKeyToCancellationFee;
        mapping(bytes32 => uint256) currencyKeyToBaseFee;
        mapping(bytes32 => uint256) currencyKeyToCostPerMinute;
        mapping(bytes32 => mapping(uint256 => uint256)) currencyKeyToBadgeToCostPerMetre;
    }

    function _storageFee() internal pure returns (StorageFee storage s) {
        bytes32 position = STORAGE_POSITION_FEE;
        assembly {
            s.slot := position
        }
    }

    event FeeSetCancellation(address indexed sender, uint256 fee);

    /**
     * _setCancellationFee sets cancellation fee
     *
     * @param _key        | currency key
     * @param _cancellationFee | unit in Wei
     */
    function _setCancellationFee(bytes32 _key, uint256 _cancellationFee)
        internal
    {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().currencyKeyToCancellationFee[_key] = _cancellationFee; // input format: token in Wei

        emit FeeSetCancellation(msg.sender, _cancellationFee);
    }

    event FeeSetBase(address indexed sender, uint256 fee);

    /**
     * _setBaseFee sets base fee
     *
     * @param _key     | currency key
     * @param _baseFee | unit in Wei
     */
    function _setBaseFee(bytes32 _key, uint256 _baseFee) internal {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().currencyKeyToBaseFee[_key] = _baseFee; // input format: token in Wei

        emit FeeSetBase(msg.sender, _baseFee);
    }

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    /**
     * _setCostPerMinute sets cost per minute
     *
     * @param _key           | currency key
     * @param _costPerMinute | unit in Wei
     */
    function _setCostPerMinute(bytes32 _key, uint256 _costPerMinute) internal {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().currencyKeyToCostPerMinute[_key] = _costPerMinute; // input format: token in Wei

        emit FeeSetCostPerMinute(msg.sender, _costPerMinute);
    }

    event FeeSetCostPerMetre(address indexed sender, uint256[] fee);

    /**
     * _setCostPerMetre sets cost per metre
     *
     * @param _key          | currency key
     * @param _costPerMetre | unit in Wei
     */
    function _setCostPerMetre(bytes32 _key, uint256[] memory _costPerMetre)
        internal
    {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        require(
            _costPerMetre.length == RideLibBadge._getBadgesCount(),
            "RideLibFee: Input length must be equal RideBadge.Badges"
        );
        for (uint256 i = 0; i < _costPerMetre.length; i++) {
            _storageFee().currencyKeyToBadgeToCostPerMetre[_key][
                    i
                ] = _costPerMetre[i]; // input format: token in Wei // rounded down
        }

        emit FeeSetCostPerMetre(msg.sender, _costPerMetre);
    }

    /**
     * _getFare calculates the fare of a trip.
     *
     * @param _key             | currency key
     * @param _badge           | badge
     * @param _metresTravelled | unit in metre
     * @param _minutesTaken    | unit in minute
     *
     * @return Fare | unit in Wei
     *
     * _metresTravelled and _minutesTaken are rounded down,
     * for example, if _minutesTaken is 1.5 minutes (90 seconds) then round to 1 minute
     * if _minutesTaken is 0.5 minutes (30 seconds) then round to 0 minute
     */
    function _getFare(
        bytes32 _key,
        uint256 _badge,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) internal view returns (uint256) {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        StorageFee storage s1 = _storageFee();

        uint256 baseFee = s1.currencyKeyToBaseFee[_key]; // not much diff in terms of gas to assign temporary variable vs using directly (below)
        uint256 costPerMinute = s1.currencyKeyToCostPerMinute[_key];
        uint256 costPerMetre = s1.currencyKeyToBadgeToCostPerMetre[_key][
            _badge
        ];

        return (baseFee +
            (costPerMinute * _minutesTaken) +
            (costPerMetre * _metresTravelled));
    }

    function _getCancellationFee(bytes32 _key) internal view returns (uint256) {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return _storageFee().currencyKeyToCancellationFee[_key];
    }
}