#!/data/data/com.termux/files/usr/bin/bash
# Script: calc_period_ms.sh
# Objetivo: Converter um intervalo de repetição para usar em:
#   termux-job-scheduler --period-ms
#
# IMPORTANTE:
# --period-ms = intervalo fixo entre execuções.
# NÃO define horário. Define apenas o tempo entre uma execução e outra.

echo "=== Conversor para period-ms (Termux Job Scheduler) ==="
echo ""
echo "Este conversor cria um INTERVALO DE REPETIÇÃO."
echo "O job será executado repetidamente a cada X dias/horas/minutos."
echo ""
echo "Exemplos:"
echo "  • 24 horas  → roda 1 vez por dia"
echo "  • 12 horas  → roda 2x por dia"
echo "  • 30 minutos → roda a cada meia hora"
echo ""
echo "IMPORTANTE:"
echo "O intervalo começa CONTANDO após a última execução."
echo "NÃO existe horário exato (tipo 'rodar às 01:00 da manhã')."
echo ""

# Entrada explicada
echo "Informe o intervalo desejado (quanto tempo deve se passar entre execuções):"
read -p "Dias (ex: 1 para 24h): " dias
read -p "Horas (0–23): " horas
read -p "Minutos (0–59): " minutos
read -p "Segundos (0–59): " segundos

# Converte para ms
total_ms=$(( (dias*24*60*60*1000) + (horas*60*60*1000) + (minutos*60*1000) + (segundos*1000) ))

echo ""
echo "⏱️ Intervalo total em milliseconds (period-ms): $total_ms"
echo ""
echo "👉 Exemplo de uso:"
echo "termux-job-scheduler \\"
echo "  --period-ms $total_ms \\"
echo "  --job-id 1 \\"
echo "  --script /data/data/com.termux/files/home/seu_script.sh"
echo ""
echo "⚠️ O job rodará continuamente nesse intervalo."
echo "   Nunca em um horário exato, apenas de X em X tempo."
