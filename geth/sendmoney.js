function sendEntranceFee(fromaddr) {
    var toaddr = '0xab788230c8ca102cbf59a0fd7621917f63bdeecd';
    var amount = web3.toWei(0.1, 'ether');
    return eth.sendTransaction({from: fromaddr.toString(), to: toaddr, value: amount})
};

function checkpeers() {
    return admin.peers.forEach(function(value){console.log(value.network.remoteAddress+"\t"+value.name)})
};
