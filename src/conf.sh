#!/bin/bash
# Configuration abstraction
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

[ -z $__INC_CONFIG ] || return
declare -r __INC_CONFIG=1


declare -A __conf=(
  [remote.user]=git
  [remote.host]=
  [remote.port]=22
)

declare -Ar __conf_desc=(
  [remote.user]="Username to access remote host over SSH"
  [remote.host]="Repository host providing SSH"
  [remote.port]="Remote SSH port"
)



_conf-get()
{
  local -r name="$1"
  local -r default="$2"

  echo "${__conf[$name]:-$default}"
}


_conf-read-or()
{
  local -r or="$1"
  local name value
  shift

  while (($#)); do
    assign="${1%%=*}"
    name="${1##*=}"

    value="$( _conf-get "$name" )"
    read "$assign" <<< "$value"
    shift

    if [ -z "$value" ]; then
      $or "$name" || return $?
      continue
    fi
  done
}


_conf-require()
{
  _conf-read-or __conf-fatal "$@"
}


__conf-fatal()
{
  local -r name="$1"
  local -ri code="${2:-1}"

  echo "fatal: configuration value \`$name' is not set" >&2
  exit $code
}


_conf-set()
{
  local -r name="$1"
  local -r value="$2"

  __conf[$name]="$value"
}


_conf-set-nonempty()
{
  local -r name="$1"
  local -r value="$2"

  [ -n "$value" ] || return

  _conf-set "$name" "$value"
}

