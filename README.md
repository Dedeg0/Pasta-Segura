"PastaSegura - Gerenciador Persistente"

O script "PastaSegura" tem como objetivo proteger e gerenciar uma pasta do usuário com senha e funcionalidades de bloqueio e desbloqueio. Ele cria um ambiente persistente de segurança usando criptografia simples (XOR) para proteger a senha e a configuração de acesso à pasta.
Funções principais:

    Configuração e Criação de Pasta:
        O script permite ao usuário escolher uma pasta existente ou criar uma nova pasta onde os arquivos serão armazenados.
        Ao configurar a pasta, a localização e outros parâmetros são salvos em um arquivo de configuração no diretório de dados do usuário (%APPDATA%\PastaSegura).

    Bloqueio da Pasta:
        O script permite bloquear a pasta, tornando-a invisível e com um nome alterado para um identificador especial de "Control Panel".
        A pasta é protegida com um arquivo de configuração criptografado que armazena o caminho da pasta e a senha de segurança.

    Desbloqueio da Pasta:
        O script solicita a senha criptografada para desbloquear a pasta.
        Se a senha fornecida pelo usuário for correta, a pasta é restaurada ao seu estado original e visível. Caso contrário, uma mensagem de erro é exibida.

    Criptografia XOR:
        O script usa uma técnica simples de criptografia XOR para criptografar e descriptografar a senha, o que impede que a senha seja armazenada em texto simples.

Como usar:

    Configuração Inicial:
        Ao rodar o script pela primeira vez, ele pedirá para o usuário escolher ou criar uma pasta para proteger.
        Após escolher ou criar a pasta, o script solicitará uma senha para proteger essa pasta. A senha será criptografada e salva.

    Menu Principal:
        O script oferece um menu com as seguintes opções:
            Bloquear a pasta: Torna a pasta invisível e protegida.
            Desbloquear a pasta: Solicita a senha e, se estiver correta, desbloqueia a pasta.
            Sair: Encerra o script.

    Bloqueio e Desbloqueio:
        Para bloquear a pasta, o script move e renomeia a pasta para um identificador "Control Panel", tornando-a invisível.
        Para desbloquear, o script solicita a senha criptografada e, se a senha for correta, restaura a pasta ao seu nome original.

    Armazenamento Persistente:
        Todas as configurações e senhas são armazenadas em um arquivo de configuração (PastaSeguraConfig.cfg), que é mantido no diretório de dados do usuário (%APPDATA%\PastaSegura) para persistência entre as execuções do script.

Exemplo de uso:

    Passo 1: Execute o script.
    Passo 2: Escolha se deseja selecionar uma pasta existente ou criar uma nova pasta.
    Passo 3: Crie uma senha para proteger a pasta.
    Passo 4: Use o menu para bloquear ou desbloquear a pasta conforme necessário.

Considerações:

    O script utiliza criptografia básica e não é recomendado para uso em ambientes que exigem alta segurança.
    Certifique-se de manter o arquivo de configuração (PastaSeguraConfig.cfg) em um local seguro.

Este script é útil para quem deseja proteger suas pastas de maneira simples e eficaz, com um mecanismo básico de criptografia e ocultação de arquivos.
