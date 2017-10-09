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

_source="$(dirname $(readlink -f ${BASH_SOURCE[0]}))/src"
source "${_source}/env.sh"
source "${_source}/src.sh"

declare -A options_dict=(
  [x]=xvar
  [y]=yvar
)
declare -A options_defaults=(
  [xvar]="xvalue"
  [yvar]="y1 y2 y3"
)
options=$(bgo_get_options ${#} ${@} options_dict options_defaults)
options=$(t=${options#*=} && echo ${t:1:-1})
declare -A options="${options}"
for key in ${!options_dict[@]}
do
  export ${options_dict[$key]}="${options[${options_dict[${key}]}]}"
done
echo "xvar = ${xvar[@]}"
echo "yvar = ${yvar[@]}"
for _y in ${yvar[@]}; do echo ${_y}; done
