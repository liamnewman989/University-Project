from connection import *
import json


def main():
    pvt_eky = "0xE2968700E59D5E57959F5861B70B577DF59888BAF53DE7BE1A202BCECC34798F"
    default_account = w3.toChecksumAddress(
        "BFCCF1d310CBC31fe2F81Bd82d3090cdd2E4F8Ef")

    contract_address = w3.toChecksumAddress(
        "0xe5919cec5da0d02a6633d594152ede79d47ebb23")
    abi = """
	[{
		"constant": false,
		"inputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "ip",
				"type": "string"
			},
			{
				"name": "chain_address",
				"type": "address"
			}
		],
		"name": "addResource",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "getResources",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_name",
				"type": "string"
			},
			{
				"name": "_ip",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "Name",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "IP",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "ChainAddress",
				"type": "address"
			}
		],
		"name": "printResourceEvent",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getOwnerAddress",
		"outputs": [
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
"""

    contract_abi = json.loads(abi)
    # print(contract_abi)

    owner_contract = w3.eth.contract(
        abi=contract_abi, address=contract_address)
    printResources(owner_contract)


# function definitions that main function will use them:
def printResources(owner_contract: w3.eth.contract):
    """
    printResources, Prints all resources of this Owner
    @param owner_contract: type: Contract-->web3.eth.contract

    """
    # event_filter = owner_contract.eventFilter(
    #     'printResourceEvent', {'fromBlock': 0, 'toBlock': 'latest'})
    # filter_value = event_filter.get_all_entries()
    # last_block = filter_value[(len(filter_value)-1)]['blockNumber']
    # for event in filter_value:
    #     if(event['blockNumber'] == last_block):
    #         print(event['args'])
    filter_value = owner_contract.events.printResourceEvent(
        {filter: {'fromBlock': 0, 'toBlock': 'latest'}})
    print(filter_value)


if __name__ == "__main__":
    main()
