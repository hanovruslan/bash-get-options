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

        declare -A options_dict=(
            [x]=xvar
            [y]=yvar
        )
        declare -A options_defaults=(
            [xvar]="xvalue"
            [yvar]="y1 y2 y3"
        )
1. add args processing snippet and export vars into current process

        options=$(bgo_get_options ${#} ${@} options_dict options_defaults)
        options=$(t=${options#*=} && echo ${t:1:-1})
        declare -A options="${options}"

1. iterate over dict and export into current env

        for key in ${!options_dict[@]}
        do
            export ${options_dict[$key]}="${options[${options_dict[${key}]}]}"
        done
1. now you can use it as array values

        echo "xvar = ${xvar[@]}"
        echo "yvar = ${yvar[@]}"
        for y in ${yvar[@]}
        do
            echo ${y}
        done
