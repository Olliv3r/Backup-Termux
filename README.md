# Script de Backup Automatizado para Termux

Um script robusto e completo de automação de backups desenvolvido especificamente para Termux em dispositivos Android. Oferece backups automáticos e agendados dos seus projetos com recursos profissionais e sistema de logs abrangente.

## 🚀 Funcionalidades

- **🕒 Agendamento Inteligente** - Horários configuráveis através de variáveis de ambiente
- **📦 Backup Eficiente** - Usa `rsync` para transferências otimizadas com fallback para `cp`
- **🧹 Limpeza Automática** - Mantém apenas os backups mais recentes (quantidade configurável)
- **📊 Logs Detalhados** - Registros completos com timestamps e detalhes das operações
- **🚫 Exclusões Inteligentes** - Exclui automaticamente diretórios desnecessários (`node_modules`, `.git`, `.cache`, etc.)
- **🔔 Suporte a Notificações** - Integração opcional com Termux:API para notificações no Android
- **⚡ Otimizado em Performance** - Uso mínimo de recursos com operações de arquivo eficientes

## 🛠️ Começo Rápido

### Uso Básico
```bash
# Tornar executável
chmod +x backup_script.sh

# Executar imediatamente
./backup_script.sh
```

Configuração via Variáveis de Ambiente

```bash
export BACKUP_PROJECT_DIR="$HOME/seu_projeto"
export BACKUP_DRIVE_DIR="/storage/seu-cartao-sd"
export BACKUP_MAX_COPIES=7

./backup_script.sh
```

⚙️ Configuração

Variável Descrição Padrão
BACKUP_PROJECT_DIR Diretório de origem para backup $HOME
BACKUP_DRIVE_DIR Local de destino do backup $PREFIX/tmp
BACKUP_MAX_COPIES Número de backups para reter 7

📁 Estrutura do Backup

```
destino_do_backup/
├── backup_20231215_143000/
│   ├── seus_arquivos...
│   └── seus_diretorios...
├── backup_20231214_143000/
└── backup.log
```

🔧 Funcionalidades Avançadas

Padrões de Exclusão

Exclui automaticamente:

· node_modules/, .git/, .cache/, __pycache__/
· *.tmp, *.log, *.swp, .DS_Store

Sistema de Logs Profissional

```log
[2023-12-15 14:30:00] === INICIANDO SISTEMA DE BACKUP ===
[2023-12-15 14:30:05] ✅ BACKUP CONCLUÍDO COM SUCESSO!
[2023-12-15 14:30:05] 📊 Estatísticas:
[2023-12-15 14:30:05]    • Tamanho: 150MB
[2023-12-15 14:30:05]    • Arquivos: 245
[2023-12-15 14:30:05]    • Diretórios: 15
```

🎯 Casos de Uso

· 📱 Desenvolvimento Mobile - Backup de projetos de programação em movimento
· 🔧 Administração de Sistemas - Backups automatizados de configurações
· 📚 Projetos de Estudantes - Manter trabalhos escolares seguros
· 💼 Documentos de Trabalho - Backup automático de arquivos importantes

🔄 Integração

Com Termux Job Scheduler

```bash
termux-job-scheduler \
  --script "backup_script.sh" \
  --job-id "backup_diario" \
  --period-ms 86400000 \
  --persisted true
```

Com Cron (Termux)

```bash
# Adicionar ao crontab -e
0 2 * * * /data/data/com.termux/files/home/backup_script.sh
```

🛡️ Recursos de Confiabilidade

· ✅ Verificações pré-execução - Valida diretórios e permissões
· 🔄 Mecanismos de fallback - Degradação rsync → cp
· 📝 Tratamento abrangente de erros - Mensagens de erro detalhadas e códigos de saída
· 🔍 Verificação de dependências - Verifica ferramentas necessárias

📊 Exemplo de Saída

```
[2023-12-15 14:30:00] 🚀 === INICIANDO SISTEMA DE BACKUP ===
[2023-12-15 14:30:01] ✅ Diretório criado com sucesso
[2023-12-15 14:30:02] 🔄 Usando rsync (modo profissional)
[2023-12-15 14:30:05] ✅ BACKUP CONCLUÍDO COM SUCESSO!
[2023-12-15 14:30:05] 📊 Estatísticas:
[2023-12-15 14:30:05]    • Tamanho: 150MB
[2023-12-15 14:30:05]    • Arquivos: 245
[2023-12-15 14:30:05]    • Diretórios: 15
[2023-12-15 14:30:05]    • Local: backup_20231215_143000
[2023-12-15 14:30:06] 🎉 BACKUP FINALIZADO COM SUCESSO!
```

🎯 Agendamento Automático

Comando Simples para Backup Diário

```bash
termux-job-scheduler \
  --script "backup_script.sh" \
  --job-id "meu_backup" \
  --period-ms 86400000 \
  --persisted true
```

Variáveis de Ambiente para Agendamento

```bash
export BACKUP_SCHEDULE_HOUR="14"
export BACKUP_SCHEDULE_MINUTE="30"
export BACKUP_SCHEDULE_WINDOW="15"
```

🤝 Contribuindo

Sinta-se à vontade para enviar issues e solicitações de melhoria! Este script foi projetado para ser modular e facilmente extensível.

📄 Licença

Código aberto - sinta-se livre para modificar e distribuir conforme necessário.

---

Nunca mais perca seu trabalho! 🎉
