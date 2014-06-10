#!/bin/bash
# Command line processing
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

[ -z $__INC_CMDLINE ] || return
declare -r __INC_CMDLINE=1

source conf.sh

# /usr/include/sysexits.h
declare -ri __EX_USAGE=64


##
# Parse command line options
#
_parse-cmdline()
{
  while getopts "c:" opt; do
    case "$opt" in
      c) __cmdline-conf "$OPTARG";;
      ?) exit __EX_USAGE;
    esac
  done >&2

  shift $(( OPTIND - 1 ))
}


##
# Processes a command line configuration assignment
#
# The form of the assignment is `var=val'. This will exit with an error if the
# expression is malformed.
#
__cmdline-conf()
{
  local -r expr="$1"
  local var val

  # parse assignment form `var=val'
  var="${expr%%=*}"
  val="${expr##*=}"

  test -n "$var" -a -n "$val" || {
    echo "error: malformed configuration expression: \`$expr'" >&2
    exit $__EX_USAGE
  }

  _conf-set "$var" "$val"
}

