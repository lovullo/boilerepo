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

source conf.sh


##
# Perform survey
#
# If a second parameter is provided, the results of the survey will be stored in
# the configuation variable of that name; otherwise, the results are echoed.
#
_do-survey()
{
  local -r name="$1"
  local -r confvar="$2"
  local -r path="./survey/$name.sh"
  local -r hook="_survey--$name"

  [ -r "$path" ] || return 1
  source "$path" || return $?

  type -t "_survey--$name" &>/dev/null || return 1

  local result
  result="$( $hook )" || return $?

  if [ -n "$confvar" ]; then
    _conf-set "$confvar" "$result"
  else
    echo "$result"
  fi
}


##
# Test whether the given survey is loaded
#
__survey-loaded()
{
  local -r name="$1"
  [ -n "${__survey[$name]}" ]
}


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
