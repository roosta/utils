#!/bin/sh
# Author: Daniel Berg <mail@roosta.sh>
# ----------------------------------------
# backup directory in home(.backup) with directory structure of
# source file. (~/.backup/[PATH]/FILE)
# Append dateformatted date and .bak to file (FILENAME.DATE.bak)
# TODO:
# * verbose
# * choose to follow symlinks
# * conf file?
# * move option
# * include home directory in elevated mode
# * custom location
# -----------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# user vars
backupdir=~/.backup
fdate="%Y-%m-%d_%H-%M-%S"

filecopy() {
  if [[ -f $1 ]]; then
    canon=$(readlink -f ${1})
    path=${backupdir}$(dirname ${canon})
    if [[ ! -d "$path" ]]; then
      mkdir -p "$path"
    fi
      cp "$1" "${path}/${1}-$(date +"$fdate").bak"
      echo "backed up '${1}' to ${path}"
  else
    echo "failed to backup: ${1}. Not a valid file" >&2
  fi
}

while getopts ":hw:" opt; do
  case $opt in
    h)
      echo "Help placeholder" >&2
      exit 0
      ;;
    w)
      if [[ -f $OPTARG ]]; then
        cp $OPTARG "./${OPTARG}.bak"
      else
        echo "Not a valid file" >&2
        exit 1
      fi
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


while [[ $# -ne 0 ]]; do
  filecopy $1
  shift
done
exit 0
