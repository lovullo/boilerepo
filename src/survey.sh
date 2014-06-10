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
# The result of the survey is assigned to the given configuration variable name.
#
_do-survey()
{
  local -r name="$1"
  local -r confvar="$2"
  shift 2

  # if the configuration var is already set, then there's no need to re-survey
  local curval
  _conf-read curval="$confvar"
  test -z "$curval" || return

  local -r path="./survey/$name.sh"
  local -r hook="_survey--$name"

  [ -r "$path" ] || return 1
  source "$path" || return $?

  type -t "_survey--$name" &>/dev/null || return 1

  local result
  result="$( $hook "$@" )" || return $?

  _conf-set "$confvar" "$result"
}


##
# Test whether the given survey is loaded
#
__survey-loaded()
{
  local -r name="$1"
  [ -n "${__survey[$name]}" ]
}

