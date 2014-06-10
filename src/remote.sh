#!/bin/bash
# Interaction with remote host
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

[ -z $__INC_REMOTE ] || return
declare -r __INC_REMOTE=1

source conf.sh


declare _ruser _rhost


##
# Create and initialize a new bare repository on the remote host
#
_create-repo()
{
  local -r path="$1"
  local user host

  _conf-require user=remote.user host=remote.host

  ssh "$user@$host" "mkdir -p '$path' && git init --bare '$path'"
}


##
# Clone remote repository
#
_clone-repo()
{
  local -r path="$1"
  local -r clonepath="$2"
  local user host

  _conf-require user=remote.user host=remote.host

  git clone "$user@$host:$path" "$clonepath"
}

