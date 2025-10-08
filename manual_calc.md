📖 Manual de Uso — calc_ms.sh

🧩 Descrição

Script utilitário para converter tempo (dias, horas, minutos e segundos) em milissegundos, ideal para configurar o parâmetro --period-ms do termux-job-scheduler.

⚙️ Modo de uso

./calc_ms.sh

O script será executado em modo interativo, pedindo os valores de tempo que você deseja converter:

=== Conversor de Tempo para Milissegundos ===

Dias: 1
Horas: 0
Minutos: 0
Segundos: 0

📤 Saída esperada

Após informar os valores, o script exibirá o total de milissegundos e um exemplo pronto para copiar e usar no Termux Job Scheduler:

⏱️ Total em milissegundos: 86400000

👉 Exemplo de uso:
termux-job-scheduler --period-ms 86400000 --job-id 1 --script /data/data/com.termux/files/home/seu_script.sh

🧠 Parâmetros

Este script não usa parâmetros de linha de comando (é interativo), mas recebe inputs manuais:

Entrada	Descrição	Exemplo

Dias	Quantos dias quer converter	1
Horas	Quantas horas quer converter	12
Minutos	Quantos minutos quer converter	30
Segundos	Quantos segundos quer converter	45

💡 Exemplos de uso

Exemplo 1 — Executar a cada 24 horas

Dias: 1
Horas: 0
Minutos: 0
Segundos: 0

Saída:

Total em milissegundos: 86400000
termux-job-scheduler --period-ms 86400000 --job-id 1 --script /data/data/com.termux/files/home/backup_diario.sh

Exemplo 2 — Executar a cada 12 horas

Dias: 0
Horas: 12
Minutos: 0
Segundos: 0

Saída:

Total em milissegundos: 43200000
termux-job-scheduler --period-ms 43200000 --job-id 2 --script /data/data/com.termux/files/home/sincronizar.sh

Exemplo 3 — Executar a cada 15 minutos

Dias: 0
Horas: 0
Minutos: 15
Segundos: 0

Saída:

Total em milissegundos: 900000
termux-job-scheduler --period-ms 900000 --job-id 3 --script /data/data/com.termux/files/home/notificar.sh

⚠️ Observações importantes

O intervalo mínimo permitido pelo Termux Job Scheduler é 15 minutos (900000 ms).

Sempre use um --job-id diferente pra cada tarefa agendada.

Use --persisted true se quiser que o job continue após reiniciar o aparelho.

O caminho do script precisa ser absoluto, ex:
/data/data/com.termux/files/home/backup.sh

🧰 Exemplo completo do comando final

termux-job-scheduler \
  --period-ms 86400000 \
  --persisted true \
  --job-id 1 \
  --script /data/data/com.termux/files/home/backup_diario.sh
