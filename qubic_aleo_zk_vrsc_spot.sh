#!/bin/bash

# Параметры
GPU_WALLET="aleo1zkreqe78k0muf596jqx7cccxewltg65nd7gkjq9lzluqc8dlwsrqpgmrdz"
GPU_POOL="aleo.hk.zk.work:10003"
CPU_WALLET="RAL8b8ULU1SmconmbUdiB8CwqfCc2nL9Cs"
CPU_POOL="ap.luckpool.net:3956"
CPU_ALGO="verushash"
CORES="20"
WORKER="$(hostname)"
DIR="/home/user/123"
QUBIC_GPU_SCRIPT="$DIR/QUBICdualGPU.sh"
QUBIC_CPU_SCRIPT="$DIR/QUBICdualCPU.sh"
LOG_FILE="/var/log/miner/apoolminer_hiveos_autoupdate/apoolminer.log"

# Проверка наличия директории и создание, если отсутствует
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    echo "Создана папка: $DIR"
fi

# Проверка наличия скрипта QUBICdualGPU.sh
if [ ! -f "$QUBIC_GPU_SCRIPT" ]; then
    cat <<EOF > "$QUBIC_GPU_SCRIPT"
#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/hive/lib/

while true; do
 /home/user/123/aleo_prover/aleo_prover --pool $GPU_POOL --address $GPU_WALLET --custom_name $WORKER &

  PID=\$!

  sleep 20m

  kill \$PID

  sleep 5s

done;
EOF
    chmod +x "$QUBIC_GPU_SCRIPT"
    echo "Создан файл: $QUBIC_GPU_SCRIPT"
fi

# Проверка наличия скрипта QUBICdualCPU.sh
if [ ! -f "$QUBIC_CPU_SCRIPT" ]; then
    echo -e "#!/bin/bash\n/hive/miners/srbminer/2.6.9/SRBMiner-MULTI --disable-gpu --algorithm $CPU_ALGO --pool $CPU_POOL --wallet $CPU_WALLET.$WORKER --cpu-threads $CORES" > "$QUBIC_CPU_SCRIPT"
    chmod +x "$QUBIC_CPU_SCRIPT"
    echo "Создан файл: $QUBIC_CPU_SCRIPT"
fi

# Функция для мониторинга процесса miner
monitor_miner() {
    local miner_running=false
    local mining_state=""
    local idle_start_time=0

    # Проверка наличия файла лога
    while [ ! -f "$LOG_FILE" ]; do
        echo "Лог-файл не найден: $LOG_FILE. Ожидание появления файла..."
        sleep 10  # Ждем перед следующей проверкой
    done

    echo "Лог-файл найден: $LOG_FILE. Начинаем мониторинг..."

    while true; do
        if pgrep -f "SCREEN.*miner" > /dev/null; then
            if [ "$miner_running" = false ]; then
                echo "Процесс miner запущен. Начинаем мониторинг лога..."
                miner_running=true
            fi

            sleep 30  # Ждем перед проверкой лога

            # Получаем последние 35 строк из лог-файла
            last_lines=$(tail -n 35 "$LOG_FILE")

            if echo "$last_lines" | grep -q "qubic mining idle now!"; then
                if [ "$mining_state" != "idle" ]; then
                    echo "$(date): Aleo mining now"
                    screen -dmS QUBICdualGPU bash "$QUBIC_GPU_SCRIPT"
                    #screen -dmS QUBICdualCPU bash "$QUBIC_CPU_SCRIPT"
                    mining_state="idle"
                    miner restart  # Перезапускаем miner после запуска процессов
                    idle_start_time=$(date +%s)  # Запоминаем время перехода в состояние idle
                    sleep 60
                    miner start
                    #nvtool --setcoreoffset 300 --setclocks 2500 --setmemoffset 0 --setmem 5001
                fi
            elif echo "$last_lines" | grep -q "qubic mining work now!"; then
                if [ "$mining_state" != "work" ]; then
                    echo "$(date): Qubic mining now"
                    screen -S QUBICdualGPU -X quit
                    #screen -S QUBICdualCPU -X quit
                    mining_state="work"
                    miner restart  # Перезапускаем miner после остановки процессов
                    #sleep 30
                    #nvtool --setcoreoffset 300 --setclocks 2400 --setmemoffset 0 --setmem 0
                fi
            elif echo "$last_lines" | grep -q "out of memory"; then
                if [ "$mining_state" != "work" ]; then
                    echo "$(date): Out of memory detected"
                    screen -S QUBICdualGPU -X quit
                    #screen -S QUBICdualCPU -X quit
                    mining_state="work"
                    miner restart  # Перезапускаем miner после остановки процессов
                    #sleep 30
                    #nvtool --setcoreoffset 300 --setclocks 2400 --setmemoffset 0 --setmem 0
                fi
            fi

            # Проверяем, прошло ли 1 час и 5 минут с момента перехода в состояние idle
            if [ "$mining_state" = "idle" ]; then
                current_time=$(date +%s)
                elapsed_time=$((current_time - idle_start_time))

                if [ "$elapsed_time" -ge $((33 * 60)) ]; then  # 65 минут в секундах
                    echo "$(date): Время ожидания истекло, завершаем процессы."
                    screen -S QUBICdualGPU -X quit
                    #screen -S QUBICdualCPU -X quit
                    miner restart
                    mining_state=""  # Сбрасываем состояние майнинга после завершения процессов
                    #sleep 30
                    #nvtool --setcoreoffset 300 --setclocks 2400 --setmemoffset 0 --setmem 0
                fi
            fi

        else
            if [ "$miner_running" = true ]; then
                echo "Процесс miner не запущен."
                miner_running=false

                # Останавливаем процессы QUBICdualGPU и QUBICdualCPU, если miner не запущен, только один раз
                if [ "$mining_state" != "" ]; then
                    screen -S QUBICdualGPU -X quit
                    #screen -S QUBICdualCPU -X quit
                    mining_state=""  # Сбрасываем состояние майнинга после завершения процессов
                fi
            fi

        fi

        sleep 30  # Проверяем каждые 30 секунд, запущен ли процесс miner
    done
}

# Запуск мониторинга
monitor_miner
