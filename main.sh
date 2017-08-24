#!/usr/bin/env bash

## ####################
## $ ./main.sh
## or
## $ ./main.sh -x foo
## or
## $ ./main.sh -y bar
## or
## $ ./main.sh -x bar -y foo
## or
## $ ./main.sh -y bar -x foo

self_dir="$(dirname $(readlink -f ${0}))/src"

source "${self_dir}/src.sh"

x=xvar
y=yvar
declare -A dict=(
 [x]=${x}
 [y]=${y}
)

options=$(bgo_get_options ${@} "$(declare -p dict)" 2>/dev/null)
eval "declare -A options=${options#*=}"
bgo_export_name ${x} ${xvar:-"x var default"}
bgo_export_name ${y} ${yvar:-"NOT x var default"}
echo "${x} = "${!x}
echo "${y} = ${!y}"
