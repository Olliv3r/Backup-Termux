#!/bin/bash
#
#

# ========================================
#  SCRIPT DE BACKUP AUTOMÁTICO
#  AUTOR: Olliv3r
#  VERSÃO 0.0.2
# ========================================

# CONFIGURAÇÕES PRINCIPAIS
readonly PROJECT_DIR="/sdcard/htdocs"
readonly BACKUP_DRIVE="/storage/6136-6464/Documents"
readonly LOG_FILE="${BACKUP_DRIVE}/backup.log"
readonly MAX_BACKUPS=5

# VARIÁVEIS GLOBAIS
BACKUP_DIR=""
BACKUP_RESULT=0

# ========================================
# FUNÇÕES PRINCIPAIS
# ========================================

# Função: Registrar mensagens de log
log_message() {
	local message="$1"

	if [ -z "$message" ]; then
		echo "Função precisa de argumento"
		return 1
	else
		data=$(date +'%Y-%m-%d %H:%M:%S')
		echo "[$data] $message" | tee -a "$LOG_FILE"
		return 0
	fi
}

# Função: Verificar se diretório existe e se é acessível
check_directory() {
	local dir_path="$1"
	local dir_name="$2"

	if [ ! -d "$dir_path" ]; then
		log_message "Erro: $dir_name não encontrado: $dir_path"
		return 1
	fi

	if [ ! -r "$dir_path" ]; then
		log_message "Erro: Sem permissão de leitura em: $dir_path"
		return 1
	fi
	
	if [ ! -w "$dir_path" ] && [ "$dir_name" != "PROJETO" ]; then
		log_message "Erro: Sem permissão de escrita em: $dir_path"
		return 1
	fi

	return 0
}

create_backup_diretory() {
	local timestamp=$(date +%Y%m%d_%H%M%S)
	BACKUP_DIR="$BACKUP_DRIVE/backup_$timestamp"

	log_message "Criando diretório de backup $(basename "$BACKUP_DIR")"

	if mkdir -p "$BACKUP_DIR"; then
		log_message "Sucesso: Diretório criado com sucesso"
		return 0
	else
		log_message "Erro: Falha ao criar o diretório"
		return 1
	fi
}

# Função: Obter lista de exclusões
get_exclude_patterns() {
	echo "--exclude=node_modules/"
	echo "--exclude=.git/"
	echo "--exclude=.cache/"
	echo "--exclude=__pycache__/"
	echo "--exclude=*.tmp"
	echo "--exclude=*.log"
	echo "--exclude=*.swp"
	echo "--exclude=.Ds_Store"
}

# Função: Fazer backup com rsync (modo profissional)
backup_with_rsync() {
	log_message "Usando rsync (modo profissional)"

	# Construir comando rsync com exclusões
	local rsync_cmd="rsync -av --delete"

	while IFS= read -r pattern; do
		[ -n "$pattern" ] && rsync_cmd="$rsync_cmd $pattern"
	done < <(get_exclude_patterns)

	rsync_cmd="$rsync_cmd \"$PROJECT_DIR/\" \"$BACKUP_DIR/\""

	# Executar rsync
	log_message "Comando: $rsync_cmd"
	eval "$rsync_cmd" 2>&1 | tee -a "$LOG_FILE"

	return ${PIPESTATUS[0]}
}

# Função: Fazer backup com cp (modo básico)
backup_with_cp() {
	log_message "Usando cp (modo básico)"

	# Copiar arquivos
	if cp -rv "$PROJECT_DIR"/* "$BACKUP_DRIVE/" 2>&1 | tee -a "$LOG_FILE"; then
		# Remover diretórios excluídos manualmente
		clean_unwanted_files
		return p
	else
		return 1
	fi
}

# Função: Limpar arquivos não desejados (modo cp)
clean_unwanted_files() {
	log_message "Limpando arquivos desnecessários..."

	local excluded_dirs=("node_modules" ".git" ".cache" "__pycache__")

	for dir in "${excluded_dirs[@]}"; do
		if [ -d "${BACKUP_DIR}/${dir}" ]; then
			rm -rf "${BACKUP_DIR}/${dir}"
			log_message "Removido: $dir"
		fi
	done

	# Remover arquivos temporários
	find "$BACKUP_DIR" -name "*.tmp" -delete 2>/dev/null
	find "$BACKUP_DIR" -name "*.log" -delete 2>/dev/null
	find "$BACKUP_DIR" -name "*.swp" -delete 2>/dev/null
	find "$BACKUP_DIR" -name ".Ds_Store" -delete 2>/dev/null
}

# Função: Executar backup principal
platform_backup() {
	termux-notification -t "Backup iniciado" -c "Cópia de arquivos sendo feita nesse momento..."
	log_message "Iniciando cópia dos arquivos..."

	command -v rsync >/dev/null 2>&1 && backup_with_rsync || backup_with_cp
	BACKUP_RESULT=$?
}

# Função: Calcular estatísticas do backup
calculate_backup_stats() {
	local size=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
	local file_count=$(find "$BACKUP_DIR" -type f 2>/dev/null | wc -l)
	local dir_count=$(find "$BACKUP_DIR" -type d 2>/dev/null | wc -l)

	echo "$size|$file_count|$dir_count"
}

# Função: Mostrar relatório final
show_backup_report() {
	stats=$(calculate_backup_stats)
	size=$(echo "$stats" | cut -d "|" -f1)
	files=$(echo "$stats" | cut -d "|" -f2)
	dirs=$(echo "$stats" | cut -d "|" -f3)

	if [ "$BACKUP_RESULT" -eq 0 ]; then
		log_message "BACKUP CONCLUÍDO COM SUCESSO!"
		log_message "Estatísticas:"
		log_message "  • Tamanho: ${size:-'N/A'}"
		log_message "  • Arquivos: $files"
		log_message "  • Diretórios: $((dirs -1))"
		log_message "  • Local: $(basename "$BACKUP_DIR")"
		termux-notification -t "Backup finalizado" -c "Cópia de arquivos feita com sucesso"
	else
		termux-notification -t "Backup falhou" -c "Cópia de arquivos falhou (status: $?)"
		log_message "Erro: Falha no backup - Status $BACKUP_RESULT"
	fi
}

# Função: Limpar backups antigos
clean_old_backups() {
	log_message "Verificando backups antigos..."

	local backup_count=$(find "$BACKUP_DRIVE" -maxdepth 1 -name "backup_*" -type d | wc -l)
	local backups_to_remove=$((backup_count - MAX_BACKUPS))

	if [ "$backups_to_remove" -gt 0 ]; then
		log_message "Removendo backups $backups_to_remove backup(s) antigo(s)..."
		find "$BACKUP_DRIVE" -maxdepth 1 -name "backup_*" -type d | sort | head -n "$backups_to_remove" | while read -r old_backup; do
			local backup_name=$(basename "$old_backup")
			log_message "Removendo: $backup_name"
			rm -rf "$old_backup"
		done

		log_message "Limpaza concluída"
		log_message "Backups existentes: $backup_count (limite: $MAX_BACKUPS)"
		log_message "Não precisa limpar"

	fi
}

# Função: Verificar dependências
check_dependencies() {
	local deps=("bash" "mkdir" "cp" "rm" "find" "du")
	local missing_deps=()

	for dep in "${deps[@]}"; do
		! command -v "$dep" >/dev/null 2>&1 && missing_deps+=("$dep")
	done

	if [ ${#missing_deps[@]} -gt 0 ]; then
		log_message "Aviso: Dependências missing: ${missing_deps[*]}"
		return 1
	fi

	return 0
}

# ========================================
#  FUNÇÃO PRINCIPAL
# ========================================

main() {
	log_message "=== Inicializado Sistema de Backup ==="

	# Verificar dependências básicas
	check_dependencies

	# Verificar diretório de destino
	if ! check_directory "$BACKUP_DRIVE" "CARTÃO SD"; then
		exit 1
	fi

	# Verificar diretório de origem
	if ! check_directory "$PROJECT_DIR" "PROJETO"; then
		exit 1	
	fi

	# Criar diretório de backup
	if ! create_backup_diretory; then
		exit 1
	fi

	# Executar backup
	platform_backup

	# Mostrar relatório
	show_backup_report

	# Limpar backups antigos (apenas se foi bem sucedido)
	if [ "$BACKUP_RESULT" -eq 0 ]; then
		clean_old_backups
	fi

	# Resultado final
	if [ "$BACKUP_RESULT" -eq 0 ]; then
		log_message "Backup finalizado com sucesso!"
	else
		log_message "Backup falhou - verifique os logs!"
	fi

	log_message "========================================="

	>>"$LOG_FILE"

	exit "$BACKUP_RESULT"
}

# ========================================
# EXECUÇÃO DO SCRIPT
# ========================================

# Verificar se o script está sendo executado diretamente
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
	main "$@"
fi
