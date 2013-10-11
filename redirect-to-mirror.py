#!/usr/bin/python

# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

import argparse
import os
import re
import subprocess
import textwrap

class Log:
  def __init__(self, is_on):
    self.is_on = is_on

  def p(self, message):
    if not self.is_on:
      return
    print(message)

parser = argparse.ArgumentParser(
    formatter_class = argparse.RawDescriptionHelpFormatter,
    description = textwrap.dedent('''\
        Set all submodules master branch to work with mirror repo.
        Save origin remotes to update from official branch.

        Example, 3 repo:
          1. official (far/slow remote)
          2. mirror (fast/local remote)
          3. local (local working copy, probably multiple connected to mirror)

        After clone repo:
          local/master -> official/master
              (local repo point to slow remote, if submodule updates will be
              runned, all submodules will be fetched from slow official remote)

        After run this script:
          local/master -> mirror/master
              (local repo point to fast local-mirror remote)
          local/official -> official/master
              (branch official point to slow remote for updates)
        '''
    )
)

parser.add_argument('--mirror', required=True)
parser.add_argument('--verbose', action='store_true')
parser.add_argument(
    'dirs', nargs='*', help='recursive init submodules in subdirectory'
)
args = parser.parse_args()

log = Log(args.verbose)

log.p("Redirecting all masters to mirror:\n    {}".format(args.mirror))

def check_is_subdirectory(directory):
  directory = os.path.normpath(directory)
  directory += '/'
  for x in args.dirs:
    x = os.path.normpath(x)
    x += '/'
    if os.path.commonprefix([x, directory]) == x:
      return True
  return False

mirror_root_dir = args.mirror
local_root_dir = os.getcwd()

do_check = True

# corresponding paths:
#   local_root_dir -> mirror_root_dir # root git directory
#   local_curr_dir -> mirror_curr_dir # current directory with .gitmodules file
#       to redirect (start with *_root_dir)
#   local_subm_dir -> mirror_subm_dir # current submodule to process

def process_directory(local_curr_dir):
  log.p('process directory: {}'.format(local_curr_dir))
  abs_curr_dir = os.path.join(local_root_dir, local_curr_dir)
  os.chdir(abs_curr_dir)
  out = subprocess.check_output(['git', 'submodule', 'status'])
  for local_subm_dir in out.split('\n'):
    os.chdir(abs_curr_dir) # directory can change during iteration
    if local_subm_dir == '' or not local_subm_dir.startswith('-'):
      continue
    # expected format like that:
    #-2fe25f7a52255a9e3b951fec133052c61313c397 proj-1
    #-fbf3575652578b5ddab76fa5717a7824ceef1e99 proj-2
    local_subm_dir = re.sub(r'^-[0-9a-f]* (.*)$', r'\1', local_subm_dir)
    log.p('process submodule: {}'.format(local_subm_dir))

    try:
      subm_remote = subprocess.check_output(
          ['git', 'config', 'submodule.{}.url'.format(local_subm_dir)]
      )
    except subprocess.CalledProcessError as exc:
      recursive = check_is_subdirectory(local_curr_dir)
      if not recursive:
        log.p('submodule "{}" not init'.format(local_subm_dir))
        continue

      log.p('process recursive')
      subprocess.check_output([
          'git', 'submodule', 'init', '{}'.format(local_subm_dir)
      ])
      do_check = True
      subm_remote = subprocess.check_output(
          ['git', 'config', 'submodule.{}.url'.format(local_subm_dir)]
      )

    subm_remote = re.sub('\n$', '', subm_remote)
    # don't use os.path.join, args.mirror may be not path at all
    # like: user@remote:/some/path/...
    mirror_subm_dir = '{}/{}/{}'.format(
        mirror_root_dir, local_curr_dir, local_subm_dir
    );
    mirror_subm_dir = re.sub(r'/./', '/', mirror_subm_dir)
    mirror_subm_dir = re.sub(r'//', '/', mirror_subm_dir)
    if subm_remote == mirror_subm_dir:
      log.p('skipped (already redirected)')
      continue

    log.p('redirect from "{}" to "{}"'.format(subm_remote, mirror_subm_dir))
    subprocess.check_output([
        'git',
        'config',
        'submodule.{}.url'.format(local_subm_dir),
        '{}'.format(mirror_subm_dir)
    ])
    subprocess.check_output([
        'git', 'submodule', 'update', '{}'.format(local_subm_dir)
    ])
    os.chdir(local_subm_dir)
    log.p('current dir: {}'.format(os.getcwd()))
    subprocess.check_output([
        'git', 'remote', 'add', 'official', '{}'.format(subm_remote)
    ])
    subprocess.check_output(['git', 'checkout', 'master'])
    subprocess.check_output(['git', 'fetch', 'official'])
    subprocess.check_output([
        'git', 'branch', '--track', 'official', 'official/master'
    ])

while do_check:
  do_check = False
  for (root, dirs, files) in os.walk('./'):
    if '.gitmodules' in files:
      process_directory(root)
