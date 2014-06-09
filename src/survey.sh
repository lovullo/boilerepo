#!/bin/bash
# Survey the user for repository information
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
# Prompt for the repository name
#
# Will recurse until a name is entered, but will default to the name entered on
# the command line.
#
prompt-repo-name()
{
  local default="$1"

  local name
  read -p "Enter an all-lowercase name for this repo ($default): " name

  # use what they entered on the command line if nothing here was entered
  [ -n "$name" ] || name="$default"

  test -n "$name" \
    && echo "${name%%.git}" \
    || prompt-repo-name
}


##
# Prompt for the repository type
#
# After a selection is made, the type README will be displayed, along with a
# list of all repositories of that type (as examples). If the user indicates
# that they do not want this selection, then they will be asked to choose
# another.
#
prompt-type()
{
  echo 'Please select a repo to view its description' >&2

  local -r PS3='What type of repo? '
  local -r types=($@)
  local type

  select type; do
    test -n "$type" || {
      echo "Invalid type"
      continue
    }

    get-type-readme "$type"
    echo

    echo 'Here are the existing repositories of this type:'
    list-type-repos "$type"
    echo

    local ok=n
    read -p 'Is this the type of repository you want (y/N)? ' ok

    test "$ok" == y || continue
    break
  done >&2

  echo "$type"
}

