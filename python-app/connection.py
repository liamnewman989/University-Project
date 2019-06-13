import web3
from web3 import Web3
from web3.middleware import geth_poa_middleware
from web3.middleware import pythonic_middleware, attrdict_middleware

HTTPUrl = "http://127.0.0.1:8545"
ipc_address = ""
ws = ""
# create connection
w3 = Web3(Web3.HTTPProvider(HTTPUrl))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)
w3.middleware_stack.add(pythonic_middleware)
w3.middleware_stack.add(attrdict_middleware)


def connectionStatus():
    if w3.isConnected():
        print("Connected")
    else:
        print("Not Connected")
