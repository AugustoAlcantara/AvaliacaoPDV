Projeto: AvaliacaoPDV
	Este projeto consiste em uma aplicação desktop desenvolvida em Delphi VCL, utilizando POO, MVC,
	Clean Code e acesso a banco de dados MySQL com FireDAC. O objetivo é permitir o cadastro e gravação de pedidos de venda, 
	conforme especificações técnicas fornecidas.

Funcionalidades

* Inclusão de pedidos com cliente e produtos.
* Digitação manual do produto: código, quantidade e valor unitário.
* Produtos adicionados em grid com:
* Edição com ENTER (quantidade e valor unitário)
* Exclusão com DEL (com confirmação)
* Navegação com setas ↑ ↓
* Permite produtos repetidos.
* Cálculo automático do valor total do pedido.
* Gravação do pedido em duas tabelas (pedido e itens_pedido) com transações.
* Suporte a reabertura e cancelamento de pedidos já gravados.
* Conexão dinâmica via arquivo .ini.
* Uso de SQL direto em INSERT, UPDATE e DELETE.
* Dump SQL incluído.

Tecnologias
* Delphi VCL
* MySQL 8+
* FireDAC
* POO, MVC e Clean Code
* SQL puro
* Sem uso de componentes de terceiros

Estrutura do Projeto

/AvaliacaoPDV/
├── bin/                   ← Executável, ini e DLL
│   ├── libmysql.dll       ← Biblioteca do MySQL
│   ├── config.ini         ← Configurações de conexão
│   └── AvaliacaoPDV.exe   ← Executável
├── src/                   ← Código-fonte do Delphi
│   ├── U_Principal.pas    ← Tela principal
│   ├── U_DM.pas           ← DataModule com conexão
│   └── ...                ← Outras units e pasta com controler
├── dump/                  ← Dump do banco
│   ├── banco_dump.sql     ← Dump do banco com tabelas e dados
├── Win32/                 ← Compilação dos arquivos gerados pelo Delphi
│   ├── Debug              ← Pasta da compilação em modo de debug
└── README.md              ← Este arquivo


Configuração do Banco
Instale o MySQL 8.0 ou superior

Edite o arquivo config.ini com seus dados:

[DATABASE]
Server=localhost
Port=3306
Database=avaliacaopdv
Username=root
Password=admin
VendorLib=libmysql.dll
Copie a libmysql.dll para a pasta do executável (/bin)

Execução
Ao compilar ou executar a aplicação temos a tela inicial do programa, basta pressionar ENTER para abrir o caixa

A tela principal permite:
* Informar o Cliente
* Inserir produtos
* Editar com ENTER
* Excluir com DEL
* Gravar pedido
* Carregar e cancelar pedidos já gravados 
