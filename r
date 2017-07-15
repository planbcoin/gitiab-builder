#!/usr/local/bin/python

import os
import sys
import subprocess

def run(cmd):
  subprocess.Popen(cmd, shell=True).wait()


ver = open('version').read().strip()
os.environ['VERSION'] = ver
# skip bumping ver
if sys.argv == 1:
  vers = map(int, ver.split('.'))
  vers[2] += 1
  vers = map(str, vers)
  ver = '.'.join(vers)
  with open('version', 'w') as f:
    f.write(ver)

  os.environ['VERSION'] = ver

  run('cd ../planbcoin; git tag -s v$VERSION -m latest')
  run('cd ../planbcoin; git push origin --tags')

run('cd inputs; rm -rf planbcoin')
run('cd inputs; cp -r ../../planbcoin .')

run('./bin/gbuild --commit planbcoin=v$VERSION --url planbcoin=../planbcoin,signature=../gitian.sigs ../planbcoin/contrib/gitian-descriptors/gitian-osx.yml')
