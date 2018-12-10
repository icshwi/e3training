#!/bin/bash
#
#  Copyright (c) 2017 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#
#   author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : Monday, December  3 22:42:21 CET 2018
#   version : 0.0.1


SC_SCRIPT="$(realpath "$0")"
SC_SCRIPTNAME=${0##*/}
SC_TOP="${SC_SCRIPT%/*}"

KAM_TOP=${SC_TOP}/kameleon


function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }


# We have to go the toplevel of the working tree.
pushd ${SC_TOP}/../../
echo "Repo TOP %s\n" "${PWD}"
git submodule update --init --recursive ;
git submodule update --remote ;
popd 

python ${KAM_TOP}/kameleon.py --host="127.0.0.1" --file=${KAM_TOP}/simulators/gconpi/gconpi.kam
