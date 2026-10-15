#!/bin/sh
# Localizador de rádios M3U para Tiny Core Linux

M3U_FILE="/home/tc/radios.m3u"

if [ ! -f "$M3U_FILE" ]; then
    echo "Arquivo $M3U_FILE não encontrado!"
    exit 1
fi

# Extrai os nomes das rádios e os links usando awk/grep
NOME_RADios=$(grep -v '^#' "$M3U_FILE" | grep 'http')

while true; do
    # Cria arrays temporários para menu
    # Usando o comando dialog para um visual limpo em modo texto
    
    # Gerando lista de opções para o dialog
    # Formato do dialog menu: tag item ...
    i=1
    MENU_ARGS=""
    
    # Lendo o arquivo m3u de forma inteligente
    # Linhas ímpares após ignorar comentários são nomes, pares são links (simplificado abaixo via arquivo temporário)
    
    grep '^#EXTINF' "$M3U_FILE" | sed 's/#EXTINF:-1,//g' > /tmp/radio_names.txt
    grep '^http' "$M3U_FILE" > /tmp/radio_urls.txt
    
    # Monta opções dinâmicas para o dialog
    ALTAS=""
    c=1
    while read -r name && read -r url <&3; do
        ALTAS="$ALTAS $c \"$name\""
        c=$((c + 1))
    done < /tmp/radio_names.txt 3< /tmp/radio_urls.txt

    # Exibe a interface com dialog
    CHOICE=$(eval dialog --menu \"Tiny Core Radio Player\" 15 50 6 $ALTAS 3>&1 1>&2 2>&3)
    
    clear
    if [ -z "$CHOICE" ]; then
        echo "Saindo do player..."
        break
    fi
    
    # Pega a URL correspondente à escolha (índice)
    SELECTED_URL=$(sed -n "${CHOICE}p" /tmp/radio_urls.txt)
    SELECTED_NAME=$(sed -n "${CHOICE}p" /tmp/radio_names.txt)
    
    echo "Conectando a: $SELECTED_NAME..."
    echo "Pressione [Ctrl+C] para parar e voltar ao menu."
    echo "----------------------------------------"
    
    # Executa o player de áudio
    mpg123 "$SELECTED_URL"
    
done

rm -f /tmp/radio_names.txt /tmp/radio_urls.txt
