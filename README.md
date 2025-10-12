# Script de Backup Automatizado para Termux

[![GitHub stars](https://img.shields.io/github/stars/Olliv3r/Backup-Termux.svg)](https://github.com/Olliv3r/Backup-Termux/stargazers)
[![GitHub license](https://img.shields.io/github/license/Olliv3r/Backup-Termux)](https://github.com/Olliv3r/Backup-Termux/blob/main/LICENSE)


Um script robusto e eficiente de automação de backup desenvolvido especificamente para Termux no Android. Este script fornece backups diários automáticos dos seus projetos com gerenciamento inteligente de arquivos e registro detalhado.

### Funcionalidades

- Backups Automatizados - Executa automaticamente em horários agendados usando Termux Job Scheduler
- Gerenciamento Inteligente - Exclui diretórios desnecessários (node_modules, .git, arquivos de cache)
- Múltiplas Versões - Mantém automaticamente até 5 backups mais recentes
- Logs Detalhados - Registros completos com timestamps e detalhes das operações
- Métodos Duplos - Usa rsync para eficiência, fallback para cp se necessário
- Notificações em Tempo Real - Notifica quando o backup inicia e finaliza (com Termux-API)
- Otimizado para Android - Desenvolvido especificamente para ambiente Termux

### Requisitos Obrigatórios

Aplicativos Necessários:

1. Termux (obrigatório) - Download na <a href="https://f-droid.org/pt_BR/packages/com.termux/" target="_blank">F-droid</a>
2. Termux:API (obrigatório para notificações) - Download na <a href="https://f-droid.org/pt_BR/packages/com.termux.api/" target="_blank">F-droid</a>

### Pacotes Termux:

```
pkg update && pkg upgrade -y
pkg install termux-api rsync -y
termux-setup-storage
```

### Configuração

#### Variáveis de Ambiente

O script usa as seguintes variáveis de ambiente. Você pode modificá-las diretamente no script:

<code>
<pre>
# Diretório do projeto para backup
readonly PROJECT_DIR="/sdcard/htdocs"

# Destino do backup (caminho do cartão SD)
readonly BACKUP_DRIVE="/storage/6136-6464/Documents"

# Localização do arquivo de log
readonly LOG_FILE="${BACKUP_DRIVE}/backup.log"

# Número de versões de backup para manter
readonly MAX_BACKUPS=5
</pre>
</code>

Como Modificar as Variáveis de Ambiente

Opção 1: Editar diretamente no script

```
nano backup_script.sh
```

Altere estas linhas:
<code>
<pre>
readonly PROJECT_DIR="/sdcard/htdocs"                    # Seu caminho do projeto
readonly BACKUP_DRIVE="/storage/6136-6464/Documents"     # Seu caminho do cartão SD
readonly MAX_BACKUPS=5                                   # Número de backups para manter
</pre>
</code>

### Sistema de Notificações

Com Termux-API instalado, você receberá:

- Notificação de Início - Quando o backup começa a ser executado
- Notificação de Sucesso - Com som e vibração quando o backup é concluído
- Notificação de Erro - Com som contínuo se ocorrer algum problema
- Estatísticas - Tamanho do backup e quantidade de arquivos copiados

### Testar Notificações:

```
# Teste se as notificações estão funcionando
termux-notification --title "Teste Backup" --content "Notificações funcionando!" --sound
```

### Como Usar

Execução Manual (com notificações)

```
bash backup_script.sh
```

### Agendamento Automático com Termux Job Scheduler

```
# Agendar backup diário às 2:00 da manhã
termux-job-scheduler \
  --script "backup_script.sh" \
  --job-id "backup_diario" \
  --period-ms 86400000 \
  --persisted true
```

### Teste Rápido (executa em 2 minutos com notificações)

```
termux-job-scheduler \
  --script "backup_script.sh" \
  --job-id "teste_backup" \
  --period-ms 120000
```

### Estrutura de Diretórios

<code>
<pre>
/storage/6136-6464/Documents/
├── backup_20231215_143000/     # Pasta de backup com timestamp
├── backup_20231216_143000/
├── backup.log                  # Logs das operações
└── (mantém os últimos 5 backups)
</pre>
</code>

### Personalização

Diretórios Excluídos

O script exclui automaticamente:

- node_modules/ - Dependências Node.js
- .git/ - Controle de versão Git
- .cache/ - Arquivos de cache
- __pycache__/ - Cache Python
- *.tmp, *.log, *.swp - Arquivos temporários

Modifique os padrões de exclusão na função get_exclude_patterns().

### Exemplo de Log e Notificações

<code>
<pre>
[2024-01-15 14:30:00] === INICIANDO SISTEMA DE BACKUP ===
📢 NOTIFICAÇÃO: "🔄 Backup Iniciado" - "Fazendo backup: htdocs"
[2024-01-15 14:30:01] ✅ Diretório criado com sucesso
[2024-01-15 14:30:05] 🔄 Usando rsync (modo profissional)
[2024-01-15 14:30:15] ✅ BACKUP CONCLUÍDO COM SUCESSO!
📢 NOTIFICAÇÃO: "✅ Backup Concluído" - "htdocs - Tamanho: 150MB - Arquivos: 245"
[2024-01-15 14:30:15] 📊 Estatísticas:
[2024-01-15 14:30:15]    • Tamanho: 150MB
[2024-01-15 14:30:15]    • Arquivos: 245
[2024-01-15 14:30:15]    • Diretórios: 15
</pre>
</code>

### Solução de Problemas

Problemas Comuns:

· "Permissão negada" - Execute termux-setup-storage
· "Diretório não encontrado" - Verifique os caminhos PROJECT_DIR e BACKUP_DRIVE
· "Backup não executa" - Verifique permissões do Termux Job Scheduler
· "Notificações não funcionam" - Instale Termux:API e teste com termux-notification

Verificar Configuração:

```
# Verificar se os diretórios existem
ls -la "/sdcard/htdocs"
ls -la "/storage/6136-6464/Documents"

Testar notificações
termux-notification --title "Teste" --content "Sistema OK" --sound

Testar execução manual
bash backup_script.sh
```

### Automação

O script foi desenvolvido para funcionar com:

- Termux Job Scheduler (recomendado) - Com notificações automáticas
- Termux:Boot + agendador personalizado
- Cron (via pacote cronie)
- Execução manual

### Importante

- Termux:API é obrigatório para receber as notificações de status do backup
- Sem o Termux:API, o backup ainda funcionará, mas sem notificações
- Configure as permissões de bateria para "Não otimizar" no Android

### Licença

Código aberto - sinta-se livre para modificar e distribuir.

### Dica Profissional

Configure seus caminhos de projeto e backup uma vez, depois automatize para sempre! Com o Termux:API, você receberá notificações sempre que o backup for executado, mantendo você informado sobre o status das suas cópias de segurança.
