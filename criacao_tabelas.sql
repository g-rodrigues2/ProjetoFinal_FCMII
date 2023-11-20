CREATE TABLE estabelecimentos_2020(
    COMP CHAR(100),
    REGIAO CHAR(100),
    UF CHAR(2),
    MUNICIPIO CHAR(100),
    MOTIVO_DESABILITACAO CHAR(200),
    CNES CHAR(100),
    NOME_ESTABELECIMENTO CHAR(255),
    RAZAO_SOCIAL CHAR(255),
    TP_GESTAO CHAR(10),
    CO_TIPO_UNIDADE CHAR(100),
    DS_TIPO_UNIDADE CHAR(100),
    NATUREZA_JURIDICA CHAR(100),
    DESC_NATUREZA_JURIDICA CHAR(255),
    NO_LOGRADOURO CHAR(255),
    NU_ENDERECO CHAR(100),
    NO_COMPLEMENTO CHAR(255),
    NO_BAIRRO CHAR(100),
    CO_CEP CHAR(100),
    NU_TELEFONE CHAR(150),
    NO_EMAIL CHAR(255),
    LEITOS_EXISTENTES INT,
    LEITOS_SUS INT,
    UTI_TOTAL_EXIST INT,
    UTI_TOTAL_SUS INT,
    UTI_ADULTO_EXIST INT,
    UTI_ADULTO_SUS INT,
    UTI_PEDIATRICO_EXIST INT,
    UTI_PEDIATRICO_SUS INT,
    UTI_NEONATAL_EXIST INT,
    UTI_NEONATAL_SUS INT,
    UTI_QUEIMADO_EXIST INT,
    UTI_QUEIMADO_SUS INT,
    UTI_CORONARIANA_EXIST INT,
    UTI_CORONARIANA_SUS INT
);

SELECT *
FROM estabelecimentos_2020