# Interesting Chains

0. Bitcoin (no smart contracts)
0. Ethereum - uses nakamoto concensus mechanism, NCM (smart contracts)

0. Cardano (uses Haskell smart contracts)
0. Polkadot (launch Solidity smart contracts via Moonbeam)
1. Polygon, NCM (can launch solidity smart contracts)
2. Avalanche - uses diff avalanche/snowman concesus mechanism (can launch solidity smart contracts)
3. Near, NCM (on Layer 2, Aurora layer) (launch solidity smart contract via Aurora)
4. The Graph ( mainly for indexing )
5. Filecoin
6. Chainlink
7. Arbitrum
8. Optimium
9. Algorand

# Ride Payment System

 in general, different tokens bridge a bit differently from Ethereum to Polygon. Do RideHub only supports PoS, unless token only has Plasma (like MATIC) or which ever more popular.
 
 Ride Payment System – Summary

1. Currently focus on 1 chain - Polygon. This means Mapping/Bridging concepts do not have to be considered for now.
2. By default, contracts deployed on Polygon are using PoS security model: https://docs.polygon.technology/docs/home/architecture/security-models/
Note that this means RIDE token created on Polygon is by default PoS (unless customized, see link)
3. Which type of security model token should RideHub support? 
Ans: Tokens can be bridged from Ethereum to Polygon via PoS or Plasma security model. The effects of the different security model is mainly seen during withdrawal of Polygon to Ethereum chain. Hence, RideHub can support any type of security model. More on bridging: https://docs.polygon.technology/docs/develop/ethereum-polygon/getting-started

4. Refer to this mapping link to check which tokens that were bridged from Ethereum to Polygon are PoS/Plasma: https://docs.polygon.technology/docs/develop/network-details/mapped-tokens/

5. In future if want to bridge RIDE from Polygon to Ethereum, it is recommended to use PoS if security is not a major concern.

6. What factors influence which token to support by RideHub? Mainly popularity and probability of it being used/utilized rather than being "hodl". https://polygonscan.com/tokens

ERC20 Tokens for RideHub to support:
(chain native token)
1. MATIC | Plasma | https://polygonscan.com/address/0x0000000000000000000000000000000000001010

(stable tokens)
2. USDT | PoS | https://polygonscan.com/address/0xc2132d05d31c914a87c6611c10748aeb04b58e8f
3. USDC | PoS | https://polygonscan.com/address/0x2791bca1f2de4661ed88a30c99a7a9449aa84174
4. UST | check, not bridged?
5. DAI | PoS & Plasma, PoS seems more volume | PoS: https://polygonscan.com/address/0x8f3cf7ad23cd3cadbd9735aff958023239c6a063 | Plasma: https://polygonscan.com/address/0x84000b263080BC37D1DD73A29D92794A6CF1564e

(other tokens)
6. wETH | PoS & Plasma, PoS seems more volume | PoS: https://polygonscan.com/address/0x7ceb23fd6bc0add59e62ac25578270cff1b9f619 | Plasma: https://polygonscan.com/address/0x8cc8538d60901d19692F5ba22684732Bc28F54A3
7. wBTC | PoS | https://polygonscan.com/address/0x1bfd67037b42cf73acf2047067bd4f2c47d9bfd6

(RideHub native)
8. RIDE | PoS | to-be-deployed

A note on RIDE:
1. Should only be deployed on one chain, this case Polygon.
2. If want to use on other chain, go through bridge, probably use PoS security model.
3. Study if need add special functions to Ride.sol if in future want make it mappable/bridgeable to Ethereum: https://docs.polygon.technology/docs/develop/ethereum-polygon/mintable-assets#what-are-the-requirements-to-be-satisfied

Questions:
1. If deploy protocol on one security model, can switch to another?

# RIDE Token Specs

 1. ERC20
 2. ERC20Permit (single transaction)
 3. ERC20Votes (governance compatible)
 4. Non-Upgradable (no proxy, no diamond)
 5. if want extend functionality in future, use ERC20Wrapper
 
Typical way to increase allowance is to call approve more than once. Safe way to do is call approve then increaseAllowance/decreaseAllowance.

### ERC20 notes

Tutorial: https://ethereum.org/en/developers/tutorials/erc20-annotated-code/

1. use SafeERC20 library (we need in case non-compliant tokens like BNB or OMG is used in contract? - see transfer fn: https://etherscan.io/address/0xb8c77482e45f1f44de1745f52c74426c631bdd52#code)

https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#SafeERC20

https://forum.openzeppelin.com/t/safeerc20-tokentimelock-wrappers/396/2

https://forum.openzeppelin.com/t/making-sure-i-understand-how-safeerc20-works/2940

https://blog.goodaudience.com/binance-isnt-erc-20-7645909069a4

2. Permit
https://ethereum.stackexchange.com/questions/110157/why-do-we-grant-access-to-our-funds-instead-of-just-sending-them-to-the-smart-co

https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20Permit
https://github.com/OpenZeppelin/openzeppelin-contracts/issues/3145
https://forum.openzeppelin.com/t/erc20permit-and-eip-still-in-draft-why/21136
https://soliditydeveloper.com/erc20-permit
https://eips.ethereum.org/EIPS/eip-2612
https://github.com/ethereum/EIPs/issues/2613
https://eips.ethereum.org/EIPS/eip-712

# ERC777

 1. default operator would be RideHub contract address
 
 2. for current scope, does NOT need to use authorizeOperator as currently RIDE only affiliated with RideHub.
 
3. Note On Gas Consumption
Dapps and wallets SHOULD first estimate the gas required when sending, minting, or burning tokens —using `eth_estimateGas` —to avoid running out of gas during the transaction.

4. for "deposit" into RideHub
- externally, "send" [YES]
- externally, "operatorSend" [x] (functionally the same as "send", might as well use send)
- implemented within RideHub fn, "send" [x] (from == RideHub, as to also RideHub, so just sending funds from RideHub to RideHub, no use)
- implemented within RideHub fn, "operatorSend" [x] (functionally the same as external "send", might as well use "send"), (would fail if ppl revoke RideHub as operator, but then whats the point?)

5. for "withdraw" from RideHub
- externally "send" & "operatorSend" [x] (holder always caller, cannot withdraw anything from RideHub)
- implemented within RideHub fn, "send" [YES]
- implemented within RideHub fn, "operatorSend" [x] (functionally, no different from implemented within RideHub fn, "send")

# Diamond Pattern

[Do I Need To Do Anything Besides Standard Deployment Of Diamond? - DINTDABSDOD?] 

1. DiamondLoupeFacet.sol
 - all functions for purpose of analyzing a Diamond. Usually used in explorer/scanning tools like The Loupe.
 - DINTDABSDOD? No.
 
 2. DiamondCutFacet.sol
 -  contains only an external "shell" fn of diamondCut of which, implementation in LibDiamond.sol
  - DINTDABSDOD? No. Unless making immutable Diamond, then use remove fn to remove DiamondCutFacet.sol itself.
  
  3. Diamond.sol
  - the constructor sets contract (Diamond.sol) owner.. AND manually adds "initial" facets. By default, adds DiamondCutFacet.sol because without this facet, cannot add other facets dynamically after Diamond deployment. Note can add other facets via constructor as well, but best practice to add after (dynamically).
  - fallback fn to call facets fn (actively used during production).
  - can receive base coin via receive fn
  - DINTDABSDOD? No. Only use THIS address with facet's abi during production.
  
  4. DiamondInit.sol - init stuff on every cut through the main contract address (delegateCall). If called externally (not through main contract's delegateCall), the states it changes wont register on main contract.
  
  5. OwnershipFacet.sol
  - sets contract (Diamond.sol) owner AND returns current owner of contract
   - DINTDABSDOD? Currently is like onlyOwner, Need edit for multisig/governance ownership. See PieDAO? Ask?
  
  6. LibDiamond.sol
  - contains Diamond.sol 's struct Diamond Storage (DS) and fns
  - contains basic owner / set owner fns
  - contains diamond cut fns
  - contains initialization fns
  - basically Standard Deployment Of Diamond related contract fns (as above)
     - DINTDABSDOD? No. (Unless want use to store custom facet's fn in a DS pattern? - research needed on DS pattern, note facet fns can sit in their own contracts like normal)
  
     
NOTE: any facet that is not cut into the diamond (main) can NOT affect the diamond's facet state variable. Example, `diamondInit.init`
