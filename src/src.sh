function bgo_export_name () {
  local option_name=${1}
  local default_value=${2}

  [[ -z ${options[${option_name}]} ]] \
  && export ${option_name}="${default_value}" \
  || export ${option_name}="$(eval declare -A option=${options[${option_name}]} && echo ${option})"
}
function bgo_get_options {
  local dict=${@: -1};
  local result;
  local sep_val=":"
  local sep_case='|'
  local opt_pat;
  local opt_case=();
  local reg=();
  local cnt;

  declare -A cnt=()
  declare -A result=()

  eval "declare -A dict="${dict#*=}
  for key in ${!dict[@]}
  do
    opt_pat=${opt_pat}${key}${sep_val}
    opt_case+=(${key})
  done
  opt_case=$(printf "${sep_case}%s" "${opt_case[@]}")
  opt_case='@('${opt_case:${#sep_case}}')'

  # `shopt -s extglob` enable var substitution in the case "${opt_case})"
  shopt -q extglob; extglob_set=$?
  ((extglob_set)) && shopt -s extglob
  while getopts ${opt_pat} opt_value
  do
    case $opt_value in
      ${opt_case})
      optarg=(${OPTARG//${sep_val}/ })
      var=${dict[${opt_value}]}
      key=${optarg[0]}
      value=${optarg[1]:-${key}}
      if [ -z "${!var}" ]; then
        reg+=(${var})
        cnt+=([${var}]=0)
      fi
      _value=$( [ "${key}" == "${value}" ] && echo [${cnt[${var}]}]=${value} || echo [${key}]=${value} )
      cnt[${var}]=$(( ${cnt[${var}]}+1 ));
      eval "${var}=${!var:-${sep_val}}${_value}${sep_val}"
      ;; *)
         echo 'Unknown options'
         exit 1
      ;;
    esac
  done
  for key in ${reg[@]}
  do
    value=$(echo ${!key}|sed "s/^\\${sep_val}//;s/\\${sep_val}$//")
    value=(${value//:/ })
    result[${key}]="(${value[@]})"
  done
  # revert back to previous value
  ((extglob_set)) && shopt -u extglob

  declare -p result
}
