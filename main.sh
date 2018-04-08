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
## ####################

source "$(dirname $(readlink -f ${BASH_SOURCE[0]}))/src/src.sh"

declare -A options_dict=(
  [x]=xvar
  [y]=yvar
)
declare -A options_defaults=(
  [xvar]="xvalue"
  [yvar]="y1 y2 y3"
)
bgo_main ${@}
echo "xvar = ${xvar[@]}"
echo "yvar = ${yvar[@]}"
for y in ${yvar[@]}; do echo ${y}; done
