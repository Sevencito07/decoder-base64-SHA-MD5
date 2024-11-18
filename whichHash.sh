#!/bin/bash

# Script to identify and try to decode a hash

function identify_and_crack_hash() {
    local hash="$1"
    local wordlist="/usr/share/wordlists/rockyou.txt"
    local wordlist2="/home/almighty/Downloads/passwords-100k.txt"
    # Validar si es hexadecimal
    if [[ "$hash" =~ ^[a-fA-F0-9]+$ ]]; then
 
       case ${#hash} in
            32)
                echo -e "\e[35mPosible md5........\e[0m"
                echo "$hash" > hash.txt
                john --format=raw-md5 --wordlist="$wordlist" hash.txt
                ;;
            40)
               
                echo -e "\e[35mPosible SHA-1 trying with  John the Ripper...........\e[0m"
                echo "$hash" > hash.txt
                john --format=raw-sha1 --wordlist="$wordlist" hash.txt
                ;;
            56)
                echo -e "\e[35mPosible SHA-224 trying with  Hashcat............\e[0m" 
                echo "$hash" > hash.txt
                hashcat -m 1300 hash.txt "$wordlist"
                ;;
            64)
                
                echo -e "\e[35mPosible SHA-256 trying with Hashcat...........\e[0m"
                echo "$hash" > hash.txt
                hashcat -m 1400 hash.txt "$wordlist2"
                ;;
            96)
                echo -e "\e[35mPosible SHA-384 trying with Hashcat...........\e[0m"
                echo "$hash" > hash.txt
                hashcat -m 10800 hash.txt "$wordlist"
                ;;
            128)
                
                echo -e "\e[35mPosible SHA-512 or Whirlpool. trying with Hashcat...........\e[0m"
                echo "$hash" > hash.txt
                hashcat -m 1700 hash.txt "$wordlist"
                ;;
            *)
                echo -e "\e[31mUNRECOGNIZABLE HASH\e[0m" 
                ;;
        esac

    # Validar si es Base64
    elif [[ "$hash" =~ ^[A-Za-z0-9+/]+=*$ && $(( ${#hash} % 4 )) -eq 0 ]]; then
        echo -e "\e[35mPosible base64. decoding.......\e[0m"
        echo "$hash" | base64 -d 2>/dev/null || echo "\e[31mCANT BE DECODED IN BASE64 .\e[0m"

    else
        echo -e  "\e[31mINVALID INPUT .\e[0m"
    fi
}

# Verificar si se pasó un argumento
if [ -z "$1" ]; then
    echo -e "\e[93mUse: $0 <hash>\e[0m"
    exit 1
fi

# Identificar y tratar de descifrar el hash
identify_and_crack_hash "$1"
