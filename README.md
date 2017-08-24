# bash-get-options #

get options from script args 

try 

- `./main.sh`
- `./main.sh -x foo`
- `./main.sh -y bar`
- `./main.sh -x bar -y foo`
- `./main.sh -y bar -x foo`

## How to include into your script/project ##

1. `git clone` this repo
1. include line `source /path/to/this/repo/src/src.sh`
1. set up your args dict 

        code block
        declare -A dict=(
          [f]=foo
          [b]=bar
        )
1. add args processing snippet

        options=$(bgo_get_options ${@} "$(declare -p dict)" 2>/dev/null)
        eval "declare -A options=${options#*=}"
1. export vars into current process

        bgo_export_name foo ${foo:-"foo default value"}
        bgo_export_name bar ${bar:-"bar default value"}
1. now you can use it
