# 📖 Manual de Uso: backup_script.sh

## 📋 Visão Geral
Script de backup automatizado para Termux que utiliza variáveis de ambiente para configuração flexível.

## ⚙️ Variáveis de Ambiente Suportadas

### 🔧 Variáveis Principais (OBRIGATÓRIAS)

#### `BACKUP_PROJECT_DIR`
**Descrição:** Diretório de origem do backup  
**Formato:** Caminho absoluto  
**Padrão:** `$HOME`  
**Exemplo:**
```bash
export BACKUP_PROJECT_DIR="$HOME/meus_projetos"
export BACKUP_PROJECT_DIR="/sdcard/Documentos"
export BACKUP_PROJECT_DIR="$HOME/workspace/app"
```

BACKUP_DRIVE_DIR

Descrição: Diretório de destino do backup
Formato: Caminho absoluto
Padrão: $PREFIX/tmp
Exemplo:

```bash
export BACKUP_DRIVE_DIR="/storage/ABCD-1234"
export BACKUP_DRIVE_DIR="/sdcard/Backups"
export BACKUP_DRIVE_DIR="$HOME/external_backup"
```

🔧 Variáveis Opcionais

BACKUP_MAX_COPIES

Descrição: Número máximo de backups a manter
Padrão: 7
Exemplo:

```bash
export BACKUP_MAX_COPIES="5"    # Mantém 5 backups
export BACKUP_MAX_COPIES="14"   # Mantém 14 backups
export BACKUP_MAX_COPIES="30"   # Mantém 30 backups
```

🚀 Métodos de Configuração

Método 1: Terminal (Sessão Atual)

```bash
# Definir variáveis
export BACKUP_PROJECT_DIR="$HOME/meu_projeto"
export BACKUP_DRIVE_DIR="/storage/ABCD-1234"
export BACKUP_MAX_COPIES="7"

# Executar backup
./backup_script.sh
