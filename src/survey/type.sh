#!/bin/bash
# Repository type survey
#
#  Copyright (C) 2014 LoVullo Associates, Inc.
#
#  This file is part of boilerepo.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##


##
# Survey hook
#
_survey--type()
{
  local ok=n
  until [ "$ok" == y ]; do
    type="$( __prompt-type $(__get-type-list) )"

    __get-type-readme "$type"
    echo

    echo 'Here are the existing repositories of this type:'
    __list-type-repos "$type"
    echo

    read -p 'Is this the type of repository you want (y/N)? ' ok
  done >&2

  echo "$type"
}


##
# Retrieve available repository types
#
__get-type-list()
{
  local user host
  _conf-require user=remote.user host=remote.host

  ssh "$user@$host" find . -type d -maxdepth 2 \! -name '".*"' \
    | grep -v .git \
    | sed 's#^./##g'
}


##
# Prompt for the repository type
#
__prompt-type()
{
  echo 'Please select a repo to view its description' >&2

  local -r PS3='What type of repo? '
  local type

  select type; do
    test -n "$type" || {
      echo "Invalid type"
      continue
    }

    break
  done >&2

  echo "$type"
}


##
# Retrieve README for a repository type
#
__get-type-readme()
{
  local -r type="$1"
  local user host

  _conf-require user=remote.user host=remote.host

  ssh "$user@$host" cat "./$type/README" 2>/dev/null \
    '||' echo No description available.
}


##
# List all repos of a given type
#
__list-type-repos()
{
  local -r type="$1"
  local user host

  _conf-require user=remote.user host=remote.host

  ssh "$user@$host" ls "'./$type/'" \
    | grep .git$ \
    | sed 's/^/  /g'
}

