@echo off

:: Feito por Marcos Rodrigues
:: https://github.com/marcosjohnny

echo Bloqueando sites indesejados...

:: Define o caminho para o arquivo hosts
set hostspath=%SystemRoot%\System32\drivers\etc\hosts

:: Faz um backup do arquivo hosts
copy %hostspath% %hostspath%.bak

:: Baixa o arquivo de sites
echo Baixando o arquivo de sites...
:: curl -o sites.txt https://raw.githubusercontent.com/marcosjohnny/block-sites/main/sites.txt
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/marcosjohnny/block-sites/main/sites.txt -OutFile sites.txt"

:: Verifica se o arquivo de sites foi baixado
if not exist sites.txt (
    echo O arquivo sites.txt nao foi encontrado.
    pause
    exit /b
)

:: Adiciona entradas para bloquear sites
for /f "usebackq delims=" %%a in ("sites.txt") do (
    echo 127.0.0.1 %%a >> %hostspath%
    echo 127.0.0.1 www.%%a >> %hostspath%
)

:: Atualiza o cache DNS
ipconfig /flushdns

echo Sites bloqueados com sucesso!
:: pause

:: Exclui os arquivos temporários
echo Excluindo arquivos temporarios...
del sites.txt
del %~f0
