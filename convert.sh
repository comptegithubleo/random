#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ "$#" -lt 1 ]; then
  echo "Usage: ./convert [mode] [operands...]
    ./convert help" >&2
  exit 1
fi

help() {
    mode=${1-}
    case $mode in
        bit)
            echo "Usage: ./convert [xor|and] arg1 arg2
ARG FORMATS:
- If leading '0x', treated as hexadecimal : 0x01, 0x2, 0xff
- If leading zero, treated as binary : 01, 001, 0101
- If leading special or non-special character, treated as ASCII : aBc, BCa, z!&_
- If leading decimal except zero, treated as decimal : 123, 321, 990" >&2
            exit 1
            ;;
        *)
            echo "Usage: ./convert help [MODE]
MODE:
    - bit (bitwise operations: xor)
EXAMPLES:
    ./convert xor 0x123 ABCD
    ./convert and 01010111 776766" >&2
           exit 1
            ;;
    esac
    
}

arg_nbr_equals() {
    # If total arg given != required nbr of args, print help
    if ! [ $1 -eq $2 ]; then
        help bit
    fi
}

# Todo - Stronger checks if valid binary / valid hexa etc
arg_type() {
    if [[ $1 =~ ^[0-9]+$ ]] ; then
        echo 10
    else
        case $1 in
            0x*)
                echo 16
                ;;
            0*)
                echo 2
                ;;
            [[:ascii:]]*)
                echo "Error : ASCII need to be converted"
                exit 1
                ;;
            *)
                echo "Error : could not identify argument type for $1"
                exit 1
                ;;
        esac
    fi
}

xor() {
    printf "%d\n" $(($(arg_type $1)#$1 ^ $(arg_type $2)#$2))
}

main() {
    # Intuition :
    # 
    #                           Case function 1 -   -   -v                      Case conversion 1   -   -v
    #                           ^                        |                      ^                        |
    #                           |                        v                      |                        v
    # Initial switchcase -> Sanitize args -> Store result(s) in array -> Handle output parameters -> Output
    #                       & Convert args               ^                      |                        ^
    #                           |                        |                      v                        |
    #                           v                        |                      Case conversion 2   -   -^
    #                           Case function 2 -   -   -^

    mode=${1-}

    results=()

    case $mode in
        xor|and)
            arg_nbr_equals $# 3 $mode
            arg1=${2-}
            arg2=${3-}
            $mode $arg1 $arg2
            ;;
        and)
            ;;
        help)
            mode=${2-}
            help $mode
            ;;
        *)
            ;;
    esac
}

main $@