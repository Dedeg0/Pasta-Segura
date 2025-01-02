PastaSegura - Gerenciador Persistente de Pastas

PastaSegura é uma solução simples e prática para proteger e gerenciar suas pastas importantes. Com funcionalidades de bloqueio e desbloqueio de pastas, este script garante que seus dados permaneçam seguros, ocultos e protegidos por senha, utilizando criptografia básica para garantir a confidencialidade da senha.
Funcionalidades

    Configuração inicial fácil:
        Crie ou selecione uma pasta existente para proteção.
        Defina uma senha segura que será criptografada e armazenada de forma persistente.

    Bloqueio de Pasta:
        Torne a pasta invisível, alterando seu nome para um identificador especial ("Control Panel"), protegendo seus arquivos de acesso não autorizado.

    Desbloqueio de Pasta:
        Solicite a senha para desbloquear a pasta.
        A pasta será restaurada ao seu nome original quando a senha correta for fornecida.

    Criptografia XOR:
        A senha é criptografada utilizando a técnica XOR, garantindo que a senha não seja armazenada em texto claro.

    Persistência de Configurações:
        As configurações e a senha criptografada são armazenadas em um arquivo de configuração, garantindo que os dados sejam preservados entre as execuções do script.

Como Usar

    Configuração Inicial:
        Ao executar o script pela primeira vez, você será solicitado a escolher ou criar uma pasta para proteção.
        Uma senha será solicitada para proteger essa pasta. A senha será criptografada e salva no arquivo de configuração.

    Menu Principal:
        O menu oferece três opções:
            Bloquear a Pasta: Torna a pasta invisível e protegida.
            Desbloquear a Pasta: Solicita a senha e, se correta, desbloqueia a pasta.
            Sair: Encerra o script.

    Bloqueio e Desbloqueio:
        Bloquear: Move e renomeia a pasta para um identificador especial, garantindo que ela fique oculta.
        Desbloquear: Solicita a senha, e se a senha fornecida for correta, a pasta será restaurada ao seu estado original.

    Persistência:
        As configurações (como o caminho da pasta e a senha criptografada) são armazenadas em um arquivo de configuração (PastaSeguraConfig.cfg) no diretório de dados do usuário (%APPDATA%\PastaSegura), garantindo que as configurações sejam mantidas entre reinícios do sistema ou execuções do script.

Exemplo de Uso

    Execute o script.
    Selecione ou crie uma pasta para proteger.
    Defina uma senha para proteger a pasta.
    Use o menu para bloquear ou desbloquear a pasta conforme necessário.

Considerações

    Segurança: O script utiliza criptografia simples (XOR) e não é recomendado para ambientes que exigem alta segurança. É uma solução prática e simples para proteção básica de dados.
    Persistência: O arquivo de configuração (PastaSeguraConfig.cfg) é essencial para o funcionamento contínuo do script. Certifique-se de mantê-lo em um local seguro.

PastaSegura é ideal para quem deseja proteger suas pastas pessoais de forma simples e eficaz. A solução oferece uma combinação de criptografia básica e ocultação de pastas, com um fácil fluxo de uso para bloquear e desbloquear dados importantes.
