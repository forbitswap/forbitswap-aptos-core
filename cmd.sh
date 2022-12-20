#!/bin/sh

# deployer address
SwapDeployer = "0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9"
ResourceAccountDeployer = "0x839caa18bb03bc24f651e3426d8f95a4020b7fc68a3e2f3576c4452baf0f69ff"
# SwapDeployer is your account, you must have its private key
# ResourceAccountDeployer is derivatived by SwapDeployer, you can refer to swap::test_resource_account to get the exact address

# publish modules
aptos move publish --package-dir uq64x64/
aptos move publish --package-dir u256/
aptos move publish --package-dir SpaceCoin/
aptos move publish --package-dir Faucet/
aptos move publish --package-dir LPResourceAccount/
# create resource account & publish LPCoin
# use this command to compile LPCoin
aptos move compile --package-dir LPCoin/ --save-metadata
# get the first arg
hexdump -ve '1/1 "%02x"' LPCoin/build/LPCoin/package-metadata.bcs
# get the second arg
hexdump -ve '1/1 "%02x"' LPCoin/build/LPCoin/bytecode_modules/LPCoinV1.mv
# This command is to publish LPCoin contract, using ResourceAccountDeployer address. Note: replace two args with the above two hex
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::LPResourceAccount::initialize_lp_account \
--args hex:064c50436f696e01000000000000000040373939424244444537444646334632384332363238323342323044414442454544344245373936323943394139374637324239393543383443393143354244308f021f8b08000000000002ff4590bb4ec4301045fb7c45941a9249fc888344b102515120dad5167e8c77a3ddd8919d0410e2dfb16111dd3ccebd7335fb59eab33ce2a17072c2f2beac9e5f1efce8aa62c31047eff2086a524355147b83333a834e8f180fc56e5e7c7c0a49f7e6c339819fe5715cb2e0b42c73bc6b9ad49e56556b3f3532c3b717a9e2b5d43e609d80eaa68cab3263c8c2dfd5e4376cec9ff195ffef9322e0967141386d0db12048cf3b4bda1e003820c38159a55aad74279485aafc4ae9a5310163ccd15f31fa3568dc69ed57b73ce27cf11ff81301de0519b494ad500a4832a096b31609edb8117660924207aab79a0b49301d653dd794b24e490b960fd6a64f7d03a569fa405701000001084c50436f696e56316b1f8b08000000000002ff5dc8b10a80201080e1bda7b80768b15122881a1b22a23deca0403d516f10f1dd2bdafab7ff3374b0465830107b85bd52c4368ee83425f4524ef34097dd04e40a9e42f4ac227cdaba73b7910cbcb32687a2863f351de452951b1e36ff316700000000000300000000000000000000000000000000000000000000000000000000000000010e4170746f734672616d65776f726b00000000000000000000000000000000000000000000000000000000000000010b4170746f735374646c696200000000000000000000000000000000000000000000000000000000000000010a4d6f76655374646c696200 \
hex:a11ceb0b0500000005010002020208070a1c0826200a460500000001000200010001084c50436f696e5631064c50436f696e0b64756d6d795f6669656c64839caa18bb03bc24f651e3426d8f95a4020b7fc68a3e2f3576c4452baf0f69ff000201020100

aptos move publish --package-dir Swap/

# admin steps
# SpaceCoin
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::initialize
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::mint_coin \
--args address:0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9 u64:20000000000000000 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::mint_coin \
--args address:0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9 u64:2000000000000 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC

# FaucetV1
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::FaucetV1::create_faucet \
--args u64:10000000000000000 u64:1000000000 u64:3600 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::FaucetV1::create_faucet \
--args u64:1000000000000 u64:10000000 u64:3600 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC

# ForbitSwapPool
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::add_liquidity_entry \
--args u64:100000 u64:10000 u64:1 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT 0x1::aptos_coin::AptosCoin

aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::add_liquidity_entry \
--args u64:1000 u64:1000 u64:1 u64:1 \
--type-args 0x686b3e9b984ec229a4d92450aca2d9ff46ddd560db68df655f8f7ae18d9452cb::TestCoinsV1::USDT 0x1::aptos_coin::AptosCoin

aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::add_liquidity_entry \
--args u64:10000000 u64:100000000 u64:1 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0x1::aptos_coin::AptosCoin
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::add_liquidity_entry \
--args u64:100000000 u64:100000000000 u64:1 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT

# user
# fund
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::FaucetV1::request \
--args address:0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT

aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::FaucetV1::request \
--args address:0x9efe87331e1543f419e5346bb6395b33da187ac05769fc6c9d7a461cc8e15a12 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC

# swap (type args shows the swap direction, in this example, swap BTC to APT)
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::swap_exact_coins_for_coins_entry \
--args u64:100 u64:1 \
--type-args 0x1::aptos_coin::AptosCoin 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC
# swap
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::swap_coins_for_exact_coins_entry \
--args u64:25 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::TestCoinsV1::BTC 0x1::aptos_coin::AptosCoin

aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::swap_coins_for_exact_coins_entry \
--args u64:100 u64:1000000000 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT
# multiple pair swap (this example, swap 100 BTC->APT->USDT)
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::swap_exact_coins_for_coins_2_pair_entry \
--args u64:100 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0x1::aptos_coin::AptosCoin 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::USDT
# add lp (if pair not exist, will auto create lp first)
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::add_liquidity_entry \
--args u64:1000 u64:10000 u64:1 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0x1::aptos_coin::AptosCoin
aptos move run --function-id 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::ForbitSwapV1::remove_liquidity_entry \
--args u64:1000 u64:1 u64:1 \
--type-args 0xa3b854a301bf4d44b6bbeb3354e50c94ab1b5cc82dd1e03a325cbd06a24e94b9::SpaceCoin::BTC 0x1::aptos_coin::AptosCoin
