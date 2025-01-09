@ECHO OFF
title PastaSegura - Configuração Persistente

:: Configurações globais
set "config_folder=%APPDATA%\PastaSegura"
set "main_config=%config_folder%\PastaSeguraConfig.cfg"
set "log_file=%config_folder%\PastaSeguraLog.log"
set "key=123"

:: Garantir que a pasta de configuração exista
if NOT EXIST "%config_folder%" (
    mkdir "%config_folder%"
    if errorlevel 1 (
        echo [%date% %time%] Erro ao criar o diretório de configuração. >> "%log_file%"
        echo Erro: Não foi possível criar o diretório de configuração.
        pause
        exit /b
    )
    echo [%date% %time%] Diretório de configuração criado: %config_folder% >> "%log_file%"
)

:: Inicializa o log
echo [%date% %time%] Script iniciado. >> "%log_file%"

:: Verificação do arquivo de configuração
if NOT EXIST "%main_config%" (
    echo [%date% %time%] Arquivo de configuração não encontrado. Configurando agora. >> "%log_file%"
    goto CONFIGURE
)

:: Carregar as configurações salvas
call :LOAD_CONFIG
if "%folder_path%"=="" (
    echo [%date% %time%] Caminho da pasta não configurado. Configurando novamente. >> "%log_file%"
    goto CONFIGURE
)

if NOT EXIST "%folder_path%" (
    if NOT EXIST "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}" (
        echo [%date% %time%] Caminho configurado não encontrado: %folder_path%. >> "%log_file%"
        echo Erro: A pasta configurada foi movida ou excluída.
        pause
        goto CONFIGURE
    )
    set "folder_path=Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
)

goto MENU

:MENU
cls
echo ---------------------------------------
echo       PastaSegura - Menu Principal      
echo ---------------------------------------
echo [1] Bloquear a pasta
echo [2] Desbloquear a pasta
echo [3] Reconfigurar pasta
echo [4] Sair
echo ---------------------------------------
set /p "choice=Selecione uma opção (1/2/3/4): "

if "%choice%"=="1" goto LOCK
if "%choice%"=="2" goto UNLOCK
if "%choice%"=="3" goto CONFIGURE
if "%choice%"=="4" (
    echo [%date% %time%] Script encerrado pelo usuário. >> "%log_file%"
    exit /b
)
echo Opção inválida. Tente novamente.
pause
goto MENU

:LOCK
:: Bloqueia a pasta
if NOT EXIST "%folder_path%" (
    echo [%date% %time%] Caminho configurado não encontrado ao bloquear: %folder_path% >> "%log_file%"
    echo Caminho configurado não encontrado. Reconfigure.
    pause
    goto CONFIGURE
)

:: Procedimento para bloquear a pasta
move "%main_config%" "%folder_path%\PastaSeguraConfig.cfg" >nul 2>&1
attrib +h "%folder_path%\PastaSeguraConfig.cfg"
ren "%folder_path%" "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
attrib +h +s "Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
set "folder_path=Control Panel.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
call :SAVE_CONFIG
echo [%date% %time%] Pasta bloqueada com sucesso: %folder_path% >> "%log_file%"
echo Pasta bloqueada com sucesso!
pause
goto MENU

:UNLOCK
:: Verifica se a pasta bloqueada existe
if NOT EXIST "%folder_path%" (
    echo [%date% %time%] Pasta bloqueada não encontrada. >> "%log_file%"
    echo A pasta não está bloqueada ou não foi encontrada.
    pause
    goto MENU
)

:: Procedimento para desbloquear a pasta
echo Digite a senha para desbloquear a pasta:
set /p "pass=Senha: "

call :XOREncrypt "%pass%" user_encrypted
if "%user_encrypted%"=="%encrypted_pass%" (
    attrib -h -s "%folder_path%"
    ren "%folder_path%" "%original_name%"
    set "folder_path=%~dp0%original_name%"
    move "%folder_path%\PastaSeguraConfig.cfg" "%main_config%" >nul 2>&1
    attrib -h "%main_config%"
    call :SAVE_CONFIG
    echo [%date% %time%] Pasta desbloqueada com sucesso: %folder_path% >> "%log_file%"
    echo Pasta desbloqueada com sucesso!
    pause
    goto MENU
) else (
    echo [%date% %time%] Tentativa de desbloqueio falhou: senha incorreta. >> "%log_file%"
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
set /p "folder_path=Digite o caminho completo da pasta existente: "
if NOT EXIST "%folder_path%" (
    echo [%date% %time%] Caminho inválido: %folder_path%. >> "%log_file%"
    echo Caminho inválido. Certifique-se de que a pasta existe.
    pause
    goto CONFIGURE
)
for %%A in ("%folder_path%") do set "original_name=%%~nxA"
call :SAVE_CONFIG
echo [%date% %time%] Pasta configurada: %folder_path% >> "%log_file%"
pause
goto CREATE_PASSWORD

:CREATE_NEW_FOLDER
set /p "folder_name=Digite o nome da nova pasta: "
md "%folder_name%"
set "folder_path=%CD%\%folder_name%"
set "original_name=%folder_name%"
call :SAVE_CONFIG
echo [%date% %time%] Nova pasta criada: %folder_path% >> "%log_file%"
pause
goto CREATE_PASSWORD

:CREATE_PASSWORD
cls
echo Crie uma nova senha para proteger sua pasta.
set /p "new_pass=Digite a nova senha: "
call :XOREncrypt "%new_pass%" encrypted_pass
call :SAVE_CONFIG
echo [%date% %time%] Senha criada e salva. >> "%log_file%"
pause
goto MENU

:SAVE_CONFIG
(
    echo folder_path:%folder_path%
    echo encrypted_pass:%encrypted_pass%
    echo original_name:%original_name%
) > "%main_config%"
echo [%date% %time%] Configurações salvas no arquivo. >> "%log_file%"
goto :eof

:LOAD_CONFIG
for /f "tokens=1,* delims=:" %%a in ('type "%main_config%"') do (
    if "%%a"=="folder_path" set "folder_path=%%b"
    if "%%a"=="encrypted_pass" set "encrypted_pass=%%b"
    if "%%a"=="original_name" set "original_name=%%b"
)
goto :eof

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
