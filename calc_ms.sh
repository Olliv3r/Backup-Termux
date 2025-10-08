#!/data/data/com.termux/files/usr/bin/bash
# Script: calc_ms.sh
# Objetivo: calcular milissegundos para usar no termux-job-scheduler

echo "=== Conversor de Tempo para Milissegundos ==="
echo ""

# Lê os valores
read -p "Dias: " dias
read -p "Horas: " horas
read -p "Minutos: " minutos
read -p "Segundos: " segundos

# Converte tudo pra milissegundos
total_ms=$(( (dias*24*60*60*1000) + (horas*60*60*1000) + (minutos*60*1000) + (segundos*1000) ))

echo ""
echo "⏱️ Total em milissegundos: $total_ms"
echo ""
echo "👉 Use assim no termux-job-scheduler:"
echo "termux-job-scheduler --period-ms $total_ms --job-id 1 --script /data/data/com.termux/files/home/seu_script.sh"
