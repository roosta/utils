#!/usr/bin/env bash

# Copyright (C) 2019 Daniel Berg <mail@roosta.sh>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This script is used with fzf as a preview script. It expects 2
# arguments, $1 full match, $2 query, here is an example
# of its usage:

# rg --smart-case --line-number --no-heading . | fzf -d ":" --preview="fzf-preview {} {q}")

# it shows a preview window that is sized based on FZF_PREVIEW_LINES
# with the match in the middle, and highlights the search query


file=$(echo "$1" | cut -d':' -f1)
linum=$(echo "$1" | cut -d':' -f2)
total=$(wc -l < "$file")
partial_match=$(echo "$1" | cut -d':' -f3-)
half_lines=$(( FZF_PREVIEW_LINES / 2))


[[ $(( linum - half_lines )) -lt 1 ]] && start=1 || start=$(( linum - half_lines ))
[[ $(( linum + half_lines )) -gt $total ]] && end=$total || end=$(( linum + half_lines ))
[[ $start -eq 1 &&  $end -ne $total ]] && end=$FZF_PREVIEW_LINES

context=$(sed -n "${start},${end}p" "$file")

echo "$context" | \
  rg -N --colors 'match:fg:green' --smart-case --pretty --context -A "$end" -B "$start" "$2" || \
  echo "$context" | rg -F -N --colors 'match:fg:green' --pretty -A "$end" -B "$start" "$partial_match"
