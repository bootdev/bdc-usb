echo "Welcome BDC mining"
cd %cd%\geth

IF NOT EXIST data GOTO INITGENSIS
  echo "USB already setup before, just restart the session, launch the console now"
  geth --verbosity "0" --datadir data --networkid 39999 --identity "BDC USB TOOL" --bootnodes=enode://fc2a69664eb95ea32ec1df6734b8f7cd360852835ea3aa948e0891cc33c2522702fbc16352c69300e2d9a3a978cf01f1d244c441a71b950825726d3ffac8b85a@119.236.206.130:30303,enode://1d444fcd490e4dfada615a90d66aabb72b581ec7c6b64c0ad2bcb582a2657e7b337a8ec1e187deae84917ad3e0a65d41ea6228227035ba20af59c25a657e0219@218.250.15.14:30303 console
  GOTO EOF

:INITGENSIS
  echo "Init genesis block and create data directory"
  geth --datadir data init genesis.json

  echo "Setup machine"
  echo "Setup machine 1: Connect to Chain"

  @start /b cmd /c geth --verbosity "0" --datadir data --networkid 39999 --identity "BDC USB TOOL" --bootnodes=enode://fc2a69664eb95ea32ec1df6734b8f7cd360852835ea3aa948e0891cc33c2522702fbc16352c69300e2d9a3a978cf01f1d244c441a71b950825726d3ffac8b85a@119.236.206.130:30303,enode://1d444fcd490e4dfada615a90d66aabb72b581ec7c6b64c0ad2bcb582a2657e7b337a8ec1e187deae84917ad3e0a65d41ea6228227035ba20af59c25a657e0219@218.250.15.14:30303 &

  echo "Setup machine 2: Create account"
  #bdc-init-account need change to user input
  for /f %%a in ('geth --datadir data --networkid 39999 --exec "personal.newAccount('bdc-init-account')" attach') do set dow=%%a
  
  echo "Setup machine 3: add account to wallet "
  geth --datadir data --networkid 39999 --exec "miner.setEtherbase('%dow%')" attach

  echo "Setup machine 4: Start mining #Wait to mine a little bit, also peers ready"
  geth --datadir data --networkid 39999 --exec "miner.start(1)" attach

  timeout 61
  echo "Setup machine 5: Send entrance fee to the peers and enter the network #Send entrance fee to Becky Zhang 0xab788230c8ca102cbf59a0fd7621917f63bdeecd"

  echo "Check if peers ready"
  for /f %%a in (' geth --exec "loadScript('sendmoney.js'); checkpeers()" attach ') do set peers=%%a
  echo %peers%

  for /f %%a in ('geth --datadir data --networkid 39999 --exec "personal.unlockAccount('%dow%', 'bdc-init-account' )" attach') do set unlock=%%a

  IF %unlock% equ true GOTO SENTENTRANCEFEE
  :SENTENTRANCEFEE
    geth --exec "loadScript('sendmoney.js'); sendEntranceFee('%dow%')" attach

GOTO EOF

echo "Done"

:EOF
pause

"0xf85a6fcd606548bbc31ba46eaa1a4ccdb0b56e6a"