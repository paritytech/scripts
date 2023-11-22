import os
import logging
import argparse

parser = argparse.ArgumentParser(description='Substrate session keys grabber')

parser.add_argument('keystore', type=str, help='A path to the keystore')
args = parser.parse_args()

logger = logging.getLogger('session_keys_grabber')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

keystore_path = args.keystore

def parse_session_key(dir):
  # variants of key prefixes in the right order
  key_formats = (
    ['6772616e', '62616265', '696d6f6e', '70617261', '61756469'], # validator keys (gran,babe,imon,para,audi)
    ['6772616e', '62616265', '696d6f6e', '70617261', '6173676e', '61756469', '62656566'], # validator keys (gran,babe,imon,para,asgn,audi,beef)
    ['6772616e', '62616265', '696d6f6e', '70617261', '6173676e', '61756469'], # validator keys (gran,babe,imon,para,asgn,audi)
    ['61757261'] # collator keys (aura)
    )
  possible_prefixes = list(set([j for i in key_formats for j in i]))
  if os.path.isdir(dir):
    os.chdir(dir)
    files = os.listdir('.')
    files = [i for i in files if len(i) == 72 and i[0:8] in possible_prefixes]
    if not files:
      return None
    # find creation time of the newest key
    time_of_last_key = sorted(list(set([int(os.path.getmtime(i)) for i in files])))[-1]
    # parse the newest public keys and prefix them with the names of files.
    # make sure to only pick up the keys created within 1 second interval
    keys = {i[0:8]: i[8:] for i in files if int(os.path.getmtime(i)) in [time_of_last_key - 1, time_of_last_key, time_of_last_key + 1]}
    logger.debug('keys were found: ' + str(keys) + ' in the keystore path: ' + dir)
    for key_format in key_formats:
      if set(keys.keys()) == set(key_format):
        # build the session key
        session_key = '0x' + ''.join([keys[i] for i in key_format])
        return(session_key)
    logger.error('Error parsing the session key')
  return None

session_key = parse_session_key(keystore_path)
if session_key:
  print(session_key)
