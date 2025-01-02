@ECHO OFF
title PastaSegura - Gerenciador Persistente

:: Configuração global
set "config_folder=%APPDATA%\PastaSegura"
set "main_config=%config_folder%\PastaSeguraConfig.cfg"
set "key=123"

:: Cria o diretório de configuração, se não existir
if NOT EXIST "%config_folder%" (
    mkdir "%config_folder%"
)

:: Carrega configurações persistentes
if EXIST "%main_config%" (
    for /f "tokens=1,2 delims=:" %%a in ('type "%main_config%"') do (
        if "%%a"=="folder_path" set "folder_path=%%b"
        if "%%a"=="encrypted_pass" set "encrypted_pass=%%b"
        if "%%a"=="original_name" set "original_name=%%b"
    )
) else (
    set "folder_path="
    set "encrypted_pass="
    set "original_name="
)

:: Verifica se a configuração está completa
if "%folder_path%"=="" goto CONFIGURE
if "%encrypted_pass%"=="" goto CREATE_PASSWORD
if NOT EXIST "%folder_path%" (
    if NOT EXIST "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}" goto CONFIGURE
)

goto MENU

:MENU
cls
echo ---------------------------------------
echo       PastaSegura - Menu Principal      
echo ---------------------------------------
echo [1] Bloquear a pasta
echo [2] Desbloquear a pasta
echo [3] Sair
echo ---------------------------------------
set /p "choice=Selecione uma opção (1/2/3): "

if "%choice%"=="1" goto LOCK
if "%choice%"=="2" goto UNLOCK
if "%choice%"=="3" exit
echo Opção inválida. Tente novamente.
pause
goto MENU

:LOCK
:: Bloqueia a pasta
if NOT EXIST "%folder_path%" (
    echo A pasta configurada não foi encontrada. Verifique o caminho: "%folder_path%"
    pause
    goto CONFIGURE
)
move "%main_config%" "%folder_path%\PastaSeguraConfig.cfg" >nul 2>&1
attrib +h "%folder_path%\PastaSeguraConfig.cfg"
ren "%folder_path%" "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
attrib +h +s "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
call :SAVE_CONFIG
echo Pasta bloqueada com sucesso!
pause
goto MENU

:UNLOCK
:: Desbloqueia a pasta
if NOT EXIST "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}" (
    echo A pasta não está bloqueada ou não foi encontrada.
    pause
    goto MENU
)
echo Digite a senha para desbloquear a pasta:
set /p "pass=Senha: "

:: Criptografa a entrada do usuário com XOR para comparação
call :XOREncrypt "%pass%" user_encrypted

:: Compara as senhas
if "%user_encrypted%"=="%encrypted_pass%" (
    echo Senha correta!
    attrib -h -s "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
    ren "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}" "%original_name%"
    set "folder_path=%~dp0%original_name%"
    move "%folder_path%\PastaSeguraConfig.cfg" "%main_config%" >nul 2>&1
    attrib -h "%main_config%"
    echo Pasta desbloqueada com sucesso!
    pause
    goto MENU
) else (
    echo Senha incorreta!
    pause
    goto MENU
)

:CONFIGURE
cls
echo ---------------------------------------
echo       PastaSegura - Configuração      
echo ---------------------------------------
echo Deseja selecionar uma pasta existente ou criar uma nova?
echo [1] Selecionar uma pasta existente
echo [2] Criar uma nova pasta
echo ---------------------------------------
set /p "folder_choice=Selecione uma opção (1/2): "

if "%folder_choice%"=="1" goto CHOOSE_EXISTING_FOLDER
if "%folder_choice%"=="2" goto CREATE_NEW_FOLDER
echo Opção inválida. Tente novamente.
pause
goto CONFIGURE

:CHOOSE_EXISTING_FOLDER
:: Solicita ao usuário o caminho da pasta existente
set /p "folder_path=Digite o caminho completo da pasta existente: "
if NOT EXIST "%folder_path%" (
    echo Caminho inválido. Certifique-se de que a pasta existe.
    pause
    goto CONFIGURE
)
for %%A in ("%folder_path%") do set "original_name=%%~nxA"
echo Pasta selecionada com sucesso: "%folder_path%"
call :SAVE_CONFIG
pause
goto CREATE_PASSWORD

:CREATE_NEW_FOLDER
:: Cria uma nova pasta
set /p "folder_name=Digite o nome da nova pasta: "
md "%folder_name%"
set "folder_path=%CD%\%folder_name%"
set "original_name=%folder_name%"
echo Nova pasta criada: "%folder_path%"
call :SAVE_CONFIG
pause
goto CREATE_PASSWORD

:CREATE_PASSWORD
cls
echo --------------------------------------------------
echo Não foi detectada uma senha criptografada existente.
echo Por favor, crie uma nova senha para proteger sua pasta.
echo --------------------------------------------------
set /p "new_pass=Digite a nova senha: "

:: Criptografa a nova senha
call :XOREncrypt "%new_pass%" encrypted_pass
call :SAVE_CONFIG

echo --------------------------------------------------
echo Sua senha foi criptografada e salva no sistema.
echo Certifique-se de proteger este arquivo contra alterações.
echo --------------------------------------------------
pause
goto MENU

:: Função para salvar configurações persistentes
:SAVE_CONFIG
(
    echo folder_path:%folder_path%
    echo encrypted_pass:%encrypted_pass%
    echo original_name:%original_name%
) > "%main_config%"
if NOT EXIST "%main_config%" (
    echo [ERRO] Falha ao salvar o arquivo de configuração.
    pause
)
goto :eof

:: Função XOR para criptografar/descriptografar
:XOREncrypt
setlocal enabledelayedexpansion
set "input=%~1"
set "output="
for /l %%i in (0,1,%=strlen(input)-1%) do (
    set "char=!input:~%%i,1!"
    for %%A in (!char!) do (
        set /a "xor=%%A ^ %key%"
        set "output=!output!!xor!"
    )
)
endlocal & set "%2=%output%"
goto :eof
