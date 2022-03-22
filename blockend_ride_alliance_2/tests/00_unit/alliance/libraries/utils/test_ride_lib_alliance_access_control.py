import pytest
import math
import brownie
from web3 import Web3
import scripts.utils as utils


TEST1_ROLE = Web3.toHex(Web3.solidityKeccak(["string"], ["TEST1_ROLE"]))
TEST1_ROLE_ADMIN = Web3.toHex(Web3.solidityKeccak(["string"], ["TEST1_ROLE_ADMIN"]))


@pytest.fixture(scope="module", autouse=True)
def ride_alliance_access_control(
    ride_hub, RideTestAllianceAccessControl, Contract, deployer
):
    yield Contract.from_abi(
        "RideTestAllianceAccessControl",
        ride_hub[0].address,
        RideTestAllianceAccessControl.abi,
        deployer,
    )


@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_hasRole_false(ride_alliance_access_control, deployer):
    assert not ride_alliance_access_control.hasRole_(TEST1_ROLE, deployer)


def test_hasRole_true(ride_alliance_access_control, deployer):
    assert not ride_alliance_access_control.hasRole_(TEST1_ROLE, deployer)

    tx = ride_alliance_access_control.ssRoles(
        TEST1_ROLE, utils.ZERO_BYTES32, deployer, True, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.hasRole_(TEST1_ROLE, deployer)


def test_requireOnlyRole_revert(ride_alliance_access_control, deployer):
    print(f"AccessControl: account {deployer.address} is missing role {TEST1_ROLE}")
    with brownie.reverts():
        ride_alliance_access_control.requireOnlyRole_(TEST1_ROLE)


def test_requireOnlyRole_pass(ride_alliance_access_control, deployer):
    tx = ride_alliance_access_control.ssRoles(
        TEST1_ROLE, utils.ZERO_BYTES32, deployer, True, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.requireOnlyRole_(TEST1_ROLE)


def test_getRoleAdmin(ride_alliance_access_control, deployer):
    tx = ride_alliance_access_control.ssRoles(
        TEST1_ROLE, TEST1_ROLE_ADMIN, deployer, False, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.getRoleAdmin_(TEST1_ROLE) == TEST1_ROLE_ADMIN


def test_setRoleAdmin(ride_alliance_access_control, deployer):
    assert ride_alliance_access_control.getRoleAdmin_(TEST1_ROLE) == utils.ZERO_BYTES32

    tx = ride_alliance_access_control.setRoleAdmin_(
        TEST1_ROLE, TEST1_ROLE_ADMIN, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.getRoleAdmin_(TEST1_ROLE) == TEST1_ROLE_ADMIN


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_setRoleAdmin_event(ride_alliance_access_control, deployer):
    tx = ride_alliance_access_control.setRoleAdmin_(
        TEST1_ROLE, TEST1_ROLE_ADMIN, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["RoleAdminChanged"]["role"] == TEST1_ROLE
    assert tx.events["RoleAdminChanged"]["previousAdminRole"] == utils.ZERO_BYTES32
    assert tx.events["RoleAdminChanged"]["newAdminRole"] == TEST1_ROLE_ADMIN


def test_grantRole(ride_alliance_access_control, deployer, person1):
    assert not ride_alliance_access_control.sRolesMember(TEST1_ROLE, person1)

    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.sRolesMember(TEST1_ROLE, person1)


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_grantRole_event(ride_alliance_access_control, deployer, person1):
    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["RoleGranted"]["role"] == TEST1_ROLE
    assert tx.events["RoleGranted"]["account"] == person1
    assert tx.events["RoleGranted"]["sender"] == deployer


def test_grantRole_skipped(ride_alliance_access_control, deployer, person1):
    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert len(tx.events) == 0


def test_revokeRole(ride_alliance_access_control, deployer, person1):
    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.sRolesMember(TEST1_ROLE, person1)

    tx = ride_alliance_access_control.revokeRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert not ride_alliance_access_control.sRolesMember(TEST1_ROLE, person1)


@pytest.mark.skip(reason="event cannot fire - require debug")
def test_revokeRole_event(ride_alliance_access_control, deployer, person1):
    tx = ride_alliance_access_control.grantRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert ride_alliance_access_control.sRolesMember(TEST1_ROLE, person1)

    tx = ride_alliance_access_control.revokeRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert tx.events["RoleRevoked"]["role"] == TEST1_ROLE
    assert tx.events["RoleRevoked"]["account"] == person1
    assert tx.events["RoleRevoked"]["sender"] == deployer


def test_grantRole_skipped(ride_alliance_access_control, deployer, person1):
    tx = ride_alliance_access_control.revokeRole_(
        TEST1_ROLE, person1, {"from": deployer}
    )
    tx.wait(1)

    assert len(tx.events) == 0

