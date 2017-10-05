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

declare -A dict=(
  [x]=xvar
  [y]=yvar
)
defaults=(
  [xvar]="x var default"
  [yvar]="y var default"
)

options=$(bgo_get_options ${@} "$(declare -p dict)" 2>/dev/null)
eval "declare -A options=${options#*=}"
for var in ${dict[@]}
do
  eval "declare -A ${var}=${options[${var}]}"
  bgo_export_name ${var} ${!var[@]:-${defaults[$var]}}
done

echo "xvar = ${xvar[@]}"
echo "yvar = ${yvar[@]}"
