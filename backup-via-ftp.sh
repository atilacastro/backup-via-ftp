#!/bin/sh
############################################################################
# Script para realizar o backup e enviar via FTP
# backup-pfsense.sh 2017/06/09
#
# Autor: Atila Castro
############################################################################

DATA=`date +%Y-%m-%dx%H-%M`

MAQUINA="FW-MATRIZ-CL01"

LOG="/var/log/backup-pfsense.log"

#---- parte editável --------------------------
#coloque os diretórios que serão backapeados
DIR1="/cf"
DIR2="/etc"
DIR3="/usr"
DIR4="/var"

#  Dados do arquivo de backup - mude se desejar
ARQUIVO="backup-$MAQUINA-$DATA.tar.gz"

# Dados do servidor FTP para onde o backup sera enviado
HOST_FTP="ftp.corp.com.br"
USUARIO_FTP="ftpuser"
SENHA_FTP="XXXXXXX"

# ---- não precisa mais editar abaixo ---------
echo "$DATA - Inicio do Backup" >> $LOG

# Cria o arquivo .tar.gz no /tmp (Temporário)
cd /tmp
#find $DIRETORIOS -mtime -1 -type f -print |
echo "Compactando arquivo..." >> $LOG
find $DIR1 $DIR2 $DIR3 $DIR4 -type f -print | tar czf /tmp/$ARQUIVO -T -
echo "$ARQUIVO compactado..." >> $LOG

# Acessa o FTP e envia os arquivos de backup
echo "conectando no servidor FTP..." >> $LOG
ftp -ivn <<EOF
open $HOST_FTP
user $USUARIO_FTP $SENHA_FTP
cd /backup-pfsense
put $ARQUIVO
bye
EOF
echo "$DATA - Arquivo de backup copiado para o FTP" >> $LOG
echo "$DATA - Fim do backup" >> $LOG

# Apaga o backup em /tmp
echo "Removendo arquivo de backup do /tmp..." >> $LOG
rm -rf /tmp/backup-*.tar.gz