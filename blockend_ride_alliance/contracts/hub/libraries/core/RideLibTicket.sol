//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibAccessControl.sol";

library RideLibTicket {
    bytes32 constant STORAGE_POSITION_TICKET = keccak256("ds.ticket");

    /**
     * @dev if a ticket exists (details not 0) in tixIdToTicket, then it is considered active
     *
     */
    struct Ticket {
        address passenger;
        address driver;
        uint256 metres;
        bytes32 keyLocal;
        bytes32 keyPay;
        uint256 cancellationFee;
        uint256 fare;
        bool tripStart;
        uint256 forceEndTimestamp;
    }
    // TODO: add location

    /**
     * *Required to confirm if driver did initiate destination reached or not
     */
    struct DriverEnd {
        address driver;
        bool reached;
    }

    struct StorageTicket {
        mapping(address => bytes32) userToTixId;
        mapping(bytes32 => Ticket) tixIdToTicket;
        mapping(bytes32 => DriverEnd) tixIdToDriverEnd;
        mapping(address => uint256) allianceToForceEndDelay; // seconds
    }

    function _storageTicket() internal pure returns (StorageTicket storage s) {
        bytes32 position = STORAGE_POSITION_TICKET;
        assembly {
            s.slot := position
        }
    }

    function _requireNotActive() internal view {
        require(
            _storageTicket().userToTixId[msg.sender] == 0,
            "RideLibTicket: Caller is active"
        );
    }

    event ForceEndDelaySet(address indexed alliance, uint256 newDelayPeriod);

    function _setForceEndDelay(uint256 _delayPeriod) internal {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.ALLIANCE_ROLE
        );
        _storageTicket().allianceToForceEndDelay[msg.sender] = _delayPeriod;

        emit ForceEndDelaySet(msg.sender, _delayPeriod);
    }

    event TicketCleared(address indexed sender, bytes32 indexed tixId);

    /**
     * _cleanUp clears ticket information and set active status of users to false
     *
     * @param _tixId Ticket ID
     * @param _passenger passenger's address
     * @param _driver driver's address
     *
     * @custom:event TicketCleared
     */
    function _cleanUp(
        bytes32 _tixId,
        address _passenger,
        address _driver
    ) internal {
        StorageTicket storage s1 = _storageTicket();
        delete s1.tixIdToTicket[_tixId];
        delete s1.tixIdToDriverEnd[_tixId];
        delete s1.userToTixId[_passenger];
        delete s1.userToTixId[_driver];

        emit TicketCleared(msg.sender, _tixId);
    }
}
