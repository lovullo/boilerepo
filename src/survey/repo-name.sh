#!/bin/bash
# Repository name survey
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
_survey--repo-name()
{
  local default="$1"

  local name
  read -p "Enter an all-lowercase name for this repo ($default): " name
  test -n "$name" || name="$default"

  test -n "$name" \
    && echo "${name%%.git}" \
    || prompt-repo-name
}

