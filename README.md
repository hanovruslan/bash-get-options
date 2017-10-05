# bash-get-options #

get options from script args

try

- `./main.sh`
- `./main.sh -x foo`
- `./main.sh -y bar`
- `./main.sh -x bar -y foo`
- `./main.sh -y bar -x foo`
- `./main.sh -x bar -x foo`

## How to include into your script/project ##

1. `git clone` this repo
1. include line `source /path/to/this/repo/src/src.sh`
1. set up your args dict and defaults

        declare -A dict=(
            [x]=xvar
            [y]=yvar
        )
        declare -A defaults=(
            [xvar]="x var default"
            [yvar]="y var default"
        )
1. add args processing snippet and export vars into current process

        options=$(bgo_get_options ${@} "$(declare -p dict)" 2>/dev/null)
        eval "declare -A options=${options#*=}"
        for var in ${dict[@]}
        do
            eval "declare -A ${var}=${options[${var}]}"
            bgo_export_name ${var} ${!var[@]:-${defaults[$var]}}
        done
1. now you can use it as array values

        echo "xvar = ${xvar[@]}"
        echo "yvar = ${yvar[@]}"
        for x in ${xvar[@]}
        do
            echo ${x}
        done
