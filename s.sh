#!/bin/bash

log_file="mint_log.txt"
success_count=0

# 初始化日志文件
echo "Minting Script Started at $(date)" | tee -a $log_file

while true; do
    feeRate=$(curl -s 'https://explorer.unisat.io/fractal-mainnet/api/bitcoin-info/fee' | jq -r '.data.fastestFee')

    echo "正在使用当前 $feeRate 费率进行 Mint" | tee -a $log_file

    if [ "$feeRate" -gt 2550 ]; then
        echo "费率超过 2550,跳过当前循环" | tee -a $log_file
        sleep 1
        continue
    fi

    command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $feeRate"

    $command
    command_status=$?

    if [ $command_status -ne 0 ]; then
        echo "命令执行失败，退出循环" | tee -a $log_file
        exit 1
    else
        success_count=$((success_count + 1))
        echo "成功mint了 $success_count 次" | tee -a $log_file
    fi

    sleep 5
done