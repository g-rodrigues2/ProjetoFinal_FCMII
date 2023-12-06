# Análise de dados de leitos gerais e complementares de estabelecimentos hospitalares

## Introdução
O conjunto de dados utilizados neste projeto consiste em dados gerais dos hospitais distribuídos em todo o território nacional, com endereço, telefone e e-mail, bem como a quantidade de leitos gerais e complementares disponíveis em cada estabelecimento hospitalar. As bases de dados utilizadas são referentes aos anos de 2020, 2021 e 2022, sendo que as informações foram disponibilizadas por competência mensal em cada ano. 

A análise descritiva desses dados pode auxiliar na compreensão do quadro geral de disponibilização de leitos gerais e complementares, possibilitando observar, entre outras coisas, a variação na quantidade desses leitos no decorrer dos meses e dos anos.

## Sobre os bancos de dados

Coletamos três bancos de dados oriundos do repositório [openDataSUS](https://opendatasus.saude.gov.br/dataset/hospitais-e-leitos) referentes a disponibilização de leitos gerais e complementares em estabelecimentos hospitalares públicos e privados distribuídos em todo o território nacional nos anos de 2020, 2021 e 2022, e cada banco apresenta dados separados por mês. Os dados presentes nos bancos podem ser separados em três classes: 

   - **Informações gerais**: nome do estabelecimento, razão social, tipo de gestão (municipal, estadual, dupla ou sem gestão), natureza jurídica (público ou privado), CNES (código do Cadastro Nacional dos Estabelecimentos de Saúde e único para cada estabelecimento).

   - **Endereço e contato**: região, município, UF, logradouro, número, complemento, bairro, cep, telefone, e-mail.

   - **Quantidade de leitos existentes:** leitos existentes, leitos SUS, total de leitos de UTI, total  de leitos de UTI do SUS, UTI adulto, UTI adulto do SUS, UTI pediátrica, UTI pediátrica do SUS, UTI neonatal, UTI neonatal do SUS, UTI de queimados, UTI de queimados do SUS, UTI coronariana e UTI coronariana do SUS.

## Metodologia
### Análises utilizando o PostgreSQL

Para o estudo do conjunto de dados propomos duas análises principais:

  1. Fazer comparações entre os conjuntos de dados de 2020, 2021 e 2022 com o intuito de observar se houvera variações na disponibilidade de leitos ao longo dos três anos.

  2. Criar tabelas relacionais a partir do conjunto de dados de 2021, ano auge da pandemia de Covid-19, analisar os dados a partir dessas tabelas relacionais.

Utilizando as tabelas relacionais citadas no item 2 acima, realizar, dentre outras, as seguintes análises:

  - Número total de leitos por região.

  - Municípios com o maior número de leitos do SUS.

  - Hospitais com o maior número de leitos complementares.

  - Percentual de leitos SUS em relação ao total de leitos por tipo de unidade.

  - Número de hospitais por tipo de gestão.

  - Municípios sem hospitais.

### Criação do Aplicativo Shiny R

Considerando os dados de 2021, criamos um aplicativo Shiny com algumas análises descritivas. Os resultados podem ser acessados  [AQUI](https://grodrigues.shinyapps.io/app_leitos_hospitais/)

O aplicativo ainda está em construção e planejamos implementar de modo que o usuário possa fazer upload do banco de dados de leitos hospitalares de qualquer outro ano para que as análises sejam exibidas.
