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

##
# Retrieve available repository types
#
# This script does not permit creating your own; you must manually do so on
# the remote host.
#
get-type-list()
{
  ssh "$user@$host" find . -type d -maxdepth 2 \! -name '".*"' \
    | grep -v .git \
    | sed 's#^./##g'
}


##
# Retrieve README for a repository type
#
get-type-readme()
{
  local -r type="$1"
  ssh "$user@$host" cat "./$type/README" 2>/dev/null \
    '||' echo No description available.
}


##
# List all repos of a given type
#
list-type-repos()
{
  ssh "$user@$host" ls "'./$type/'" \
    | grep .git$ \
    | sed 's/^/  /g'
}


##
# Create and initialize a new bare repository on the remote host
#
create-repo()
{
  local -r path="$1"
  ssh "$user@$host" "mkdir -p '$path' && git init --bare '$path'"
}

