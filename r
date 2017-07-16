#!/usr/local/bin/python

import os
import sys
import subprocess

def run(cmd):
  subprocess.Popen(cmd, shell=True).wait()

def get(cmd):
  p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
  out, err = p.communicate()
  return out


run('cd ../planbcoin && git pull --no-edit')
ver = get('cd ../planbcoin && git describe --abbrev=0').strip().replace('v', '', 1)
os.environ['VERSION'] = ver

if len(sys.argv) == 1:
  print 'bumping version to', ver
  vers = map(int, ver.split('.'))
  vers[2] += 1
  run('cd ../planbcoin; sed -i -E "s/(_CLIENT_VERSION_REVISION,) [0-9]+/\\1 {}/" configure.ac'.format(vers[2]))
  vers = map(str, vers)
  ver = '.'.join(vers)

  os.environ['VERSION'] = ver

  run('cd ../planbcoin; git tag -s v$VERSION -m latest')
  run('git commit -am set_ver_$VERSION')
  run('cd ../planbcoin; git push origin --tags')

run('cd inputs; rm -rf planbcoin')
run('cd inputs; cp -r ../../planbcoin .')

run('./bin/gbuild --commit planbcoin=v$VERSION --url planbcoin=../planbcoin,signature=../gitian.sigs ../planbcoin/contrib/gitian-descriptors/gitian-osx.yml')
run('scp -i ./var/id_rsa -P 2223 root@localhost:/home/ubuntu/out/*.dmg ~/Downloads')
