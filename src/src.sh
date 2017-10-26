#@IgnoreInspection BashAddShebang
source "$(dirname $(readlink -f ${BASH_SOURCE[0]}))/env.sh"
bgo_get_options () {
  index=${1}
  declare -A \
    dict="$(bgo_get_values ${@:(( 2 + ${index} )):1})" \
    defaults="$(bgo_get_values ${@:(( 3 + ${index} )):1})" \
    result
  values=${@:2:${index}}
  OPTSTRING=$(bgo_getopt_o ${!options_dict[@]})
  set -- $(getopt ${OPTSTRING} ${values[@]})
  shopt -s extglob # to catch opt by template
  while getopts ${OPTSTRING} key
  do
    case "${key}" in
      $(bgo_get_optcase_template))
        [ -z "${result[${dict[$key]}]}" ] \
          && result[${dict[$key]}]="${OPTARG}" \
          || result[${dict[$key]}]+="${BGO_A_DEL}${OPTARG}"
        ;;
      --) shift
        break;;
      -*) bgo_fail "Unknown options ${key}"
        break;;
      *)  bgo_fail "This is not supposed to be displayed ${key}"
        break;;
    esac
  done
  for key in "${!defaults[@]}"
  do
    [ -z "${result[${key}]}" ] && result[${key}]="${defaults[${key}]}"
  done
  declare -p result
}
bgo_get_values () (
  var=${1}
  var="$(declare -p ${var})"
  var="${var#*=}"
  echo "${var:1:-1}"
)
bgo_implode () (
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
)
bgo_get_optcase_template () (
  echo "+($(bgo_implode ${BGO_CASE_DEL} $( \
    for key in ${!options_dict[@]}
    do
      echo "${key}"
    done \
  )))"
)
bgo_getopt_o () {
  for var in "${@}"
  do
    echo -n "${var}${BGO_OPT_DEL}"
  done
}
bgo_explode () {
  echo ${1//${2}/${BGO_A_DEL}}
}
bgo_fail () {
  echo ${1} >&2; exit 1
}
bgo_export () {
  bgo_fail x
}
