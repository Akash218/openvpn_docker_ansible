#!/bin/bash

ovpn_file="$ovpn_file"
pkcs12_file="$pkcs12_file"
pass_file="$pass_file"
username="$username"
password="$password"

echo -e "$username\n$password" >password_file

function file_check {         
   
  if [ -n "$ovpn_file" ] && [ -n "$pkcs12_file" ] && [ -n "$username" ] && [ -n "$password" ]; then
        local value=6
        arr1=("$ovpn_file" "$pkcs12_file" )
        arr2=("ovpn file not found" "pkcs12 file not found" )
        for ((i = 0; i < "${#arr1[@]}"; i++)); do
                if [ ! -f /client/"${arr1[i]}" ]; then
                        echo "${arr2[i]}"
                        value=10
                fi
        done
        if [ "$value" = 6 ]; then
          nohup sudo openvpn /client/"$ovpn_file" --auth-nocache --pkcs12 /client/"$pkcs12_file" --auth-user-pass /client/password_file
        fi

  elif [ -n "$ovpn_file" ] && [ -n "$username" ] && [ -n "$password" ]; then
         arr1=("$ovpn_file")
         for i in "${arr1[@]}"
         do
           if [ -f /client/"$i" ]; then
              local value=5
           else
              echo "ovpn file not found"
              value=10
           fi
         done
         if [ "$value" = 5 ]; then
           nohup sudo openvpn /client/"$ovpn_file" --auth-user-pass /client/password_file
         fi


  elif [ -n "$ovpn_file" ] && [ -n "$pkcs12_file" ] && [ -n "$pass_file" ]; then
        local value=4
        arr1=("$ovpn_file" "$pkcs12_file" "$pass_file")
        arr2=("ovpn file not found" "pkcs12 file not found" "pass file not found")
        for ((i = 0; i < "${#arr1[@]}"; i++)); do
                if [ ! -f /client/"${arr1[i]}" ]; then
                        echo "${arr2[i]}"
                        value=10
                fi
        done
        if [ "$value" = 4 ]; then
          nohup sudo openvpn /client/"$ovpn_file" --auth-nocache --pkcs12 /client/"$pkcs12_file" --auth-user-pass /client/"$pass_file"
        fi

  elif [ -n "$ovpn_file" ] && [ -n "$pkcs12_file" ]; then
        local value=3
        arr1=("$ovpn_file" "$pkcs12_file" )
        arr2=("ovpn file not found" "pkcs12 file not found" )
        for ((i = 0; i < "${#arr1[@]}"; i++)); do
                if [ ! -f /client/"${arr1[i]}" ]; then
                        echo "${arr2[i]}"
                        value=10
                fi
        done
        if [ "$value" = 3 ]; then
          nohup sudo openvpn /client/"$ovpn_file" --auth-nocache --pkcs12 /client/"$pkcs12_file"
        fi
  
  elif [ -n "$ovpn_file" ] && [ -n "$pass_file" ]; then
        local value=2
        arr1=("$ovpn_file" "$pass_file")
        arr2=("ovpn file not found" "pass file not found")
        for ((i = 0; i < "${#arr1[@]}"; i++)); do
                if [ ! -f /client/"${arr1[i]}" ]; then
                        echo "${arr2[i]}"
                        value=10
                fi
        done
        if [ "$value" = 2 ]; then
          nohup sudo openvpn /client/"$ovpn_file" --auth-nocache --auth-user-pass /client/"$pass_file"
        fi

  elif [ -n "$ovpn_file" ]; then
    arr1=("$ovpn_file")
    for i in "${arr1[@]}"
    do
      if [ -f /client/"$i" ]; then
        local value=1
      else
        echo "ovpn file not found"
        value=10
      fi
    done
    if [ "$value" = 1 ]; then
          nohup sudo openvpn /client/"$ovpn_file"
        fi
fi
}

file_check
