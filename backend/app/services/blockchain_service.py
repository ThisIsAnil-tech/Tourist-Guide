import json
from app.config import settings
from app.logging_config import logger

_web3_client = None
_contract = None


def get_contract():
    global _web3_client, _contract
    if not settings.BLOCKCHAIN_ENABLED:
        return None

    if _contract is None:
        from web3 import Web3

        _web3_client = Web3(Web3.HTTPProvider(settings.POLYGON_RPC_URL))
        with open(settings.CONTRACT_ABI_PATH) as f:
            abi = json.load(f)
        _contract = _web3_client.eth.contract(address=settings.CONTRACT_ADDRESS, abi=abi)

    return _contract


async def store_identity_hash(user_id: str, data_hash: str):
    if not settings.BLOCKCHAIN_ENABLED:
        return None

    contract = get_contract()
    account = _web3_client.eth.account.from_key(settings.BACKEND_WALLET_PRIVATE_KEY)
    txn = contract.functions.storeIdentity(user_id, data_hash).build_transaction({
        "from": account.address,
        "nonce": _web3_client.eth.get_transaction_count(account.address),
    })
    signed = account.sign_transaction(txn)
    tx_hash = _web3_client.eth.send_raw_transaction(signed.rawTransaction)
    logger.info(f"Identity hash stored on-chain for user {user_id}")
    return tx_hash.hex()