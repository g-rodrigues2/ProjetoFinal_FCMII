#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(tidyverse)

dados <- read.csv("Leitos_2021.csv")
#View(dados)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Análise de Leitos Hospitalares"),
  
  # Use tabsetPanel to create two tabs: "Leitos por Tipo" e "Leitos SUS e Existentes"
  tabsetPanel(
    tabPanel("Leitos por Tipo",  
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1]),
                 
                 # Adicione botões seletivos para os tipos de leitos
                 checkboxGroupInput("tipos_leitos_selecionados", "Selecione os Tipos de Leitos",
                                    choices = c("UTI_TOTAL_EXIST", "UTI_TOTAL_SUS",
                                                "UTI_ADULTO_EXIST", "UTI_ADULTO_SUS", "UTI_PEDIATRICO_EXIST", "UTI_PEDIATRICO_SUS",
                                                "UTI_NEONATAL_EXIST", "UTI_NEONATAL_SUS", "UTI_QUEIMADO_EXIST", "UTI_QUEIMADO_SUS",
                                                "UTI_CORONARIANA_EXIST", "UTI_CORONARIANA_SUS"),
                                    selected = NULL)
               ),
               mainPanel(
                 # Adicione um gráfico de barras
                 plotOutput("grafico_barras_media_leitos")
               )
             )
    ),
    
    tabPanel("Leitos Existentes e Leitos por tipo de instituição",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_leitos", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione gráficos para LEITOS_SUS e LEITOS_EXISTENTES
                 plotOutput("grafico_media_leitos_sus"),
                 plotOutput("grafico_media_leitos_existentes")
               )
             )),
    
    tabPanel("Distribuição de Hospitais por Região e Tipo de Unidade",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_distribuicao", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione gráficos para a distribuição de hospitais
                 plotOutput("grafico_distribuicao_hospitais")
               )
             )),
    
    tabPanel("Taxa de Leitos SUS por Tipo de Unidade",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_taxa_sus", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione um gráfico para a taxa de leitos SUS
                 plotOutput("grafico_taxa_leitos_sus")
               )
             )),
    
    tabPanel("Correlação entre Número de Leitos e Tipo de Unidade",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_correlacao", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione um gráfico para a correlação
                 plotOutput("grafico_correlacao_leitos_tipo_unidade")
               )
             )),
    tabPanel("Avaliação da Cobertura de UTI por Região",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_cobertura_uti", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione um gráfico para a avaliação de cobertura de UTI por região
                 plotOutput("grafico_cobertura_uti_regiao")
               )
             )),
    
    tabPanel("Comparação de Número de Leitos",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_comparacao_leitos", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione um gráfico para a comparação do número de leitos
                 plotOutput("grafico_comparacao_leitos")
               )
             )),
    
    tabPanel("Análise da Natureza Jurídica por UF",
             sidebarLayout(
               sidebarPanel(
                 # Adicione um seletor de mês
                 selectInput("mes_selecionado_natureza_uf", "Selecione o Mês",
                             choices = unique(substr(dados$comp, 5, 6)),
                             selected = unique(substr(dados$comp, 5, 6))[1])
               ),
               mainPanel(
                 # Adicione um gráfico para a análise da natureza jurídica por UF
                 plotOutput("grafico_natureza_uf")
               )
             ))
  )
)






# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Adicionei uma nova coluna para representar o mês pois na coluna comp ele aparece no
  # formato "202101", logo, seleciono apenas os ultimos digitos para filtrar.
  
  dados <- dados %>%
    mutate(Mes = substr(comp, 5, 6))
  
  output$grafico_barras_media_leitos <- renderPlot({
    
    # Filtrando os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado)
    
    #Criando uma lista com os tipos de leitos presentes no banco de dados
    #para o usuário conseguir selecionar.
    
    tipos_leitos_selecionados <- c("UTI_TOTAL_EXIST", "UTI_TOTAL_SUS",
                                   "UTI_ADULTO_EXIST", "UTI_ADULTO_SUS", "UTI_PEDIATRICO_EXIST", "UTI_PEDIATRICO_SUS",
                                   "UTI_NEONATAL_EXIST", "UTI_NEONATAL_SUS", "UTI_QUEIMADO_EXIST", "UTI_QUEIMADO_SUS",
                                   "UTI_CORONARIANA_EXIST", "UTI_CORONARIANA_SUS")
    
    # Calcular média de leitos por tipo selecionado
    media_leitos <- dados_filtrados %>%
      group_by(DESC_NATUREZA_JURIDICA, DS_TIPO_UNIDADE) %>%
      summarise(across(all_of(tipos_leitos_selecionados), mean, na.rm = TRUE))
    
    # Transformar o dataframe para o formato longo (tidy)
    media_leitos_long <- pivot_longer(media_leitos, cols = starts_with("UTI"), names_to = "Tipo_Leito", values_to = "Media_Leitos")
    
    # Filtrar os tipos de leitos selecionados pelo usuário
    
    media_leitos_long <- filter(media_leitos_long, Tipo_Leito %in% input$tipos_leitos_selecionados)
    
    ggplot(media_leitos_long, aes(x = DS_TIPO_UNIDADE, y = Media_Leitos, fill = Tipo_Leito)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Média de Leitos por Tipo e Natureza Jurídica",
           x = "Tipo de Unidade",
           y = "Média de Leitos") +
      theme_minimal() +
      theme(legend.position = "top")
  })
  
  # Crie gráficos separados para LEITOS_SUS e LEITOS_EXISTENTES
  
  output$grafico_media_leitos_sus <- renderPlot({
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_leitos)
    
    # Calcular a média de LEITOS_SUS por tipo de unidade
    media_leitos_sus <- dados_filtrados %>%
      group_by(DS_TIPO_UNIDADE) %>%
      summarise(Media_LEITOS_SUS = mean(LEITOS_SUS, na.rm = TRUE))
    
    # Criar gráfico de barras
    ggplot(media_leitos_sus, aes(x = DS_TIPO_UNIDADE, y = Media_LEITOS_SUS, fill = DS_TIPO_UNIDADE)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Média de LEITOS_SUS por Tipo de Unidade",
           x = "Tipo de Unidade",
           y = "Média de LEITOS_SUS") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_media_leitos_existentes <- renderPlot({
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_leitos)
    
    # Calcular a média de LEITOS_EXISTENTES por tipo de unidade
    media_leitos_existentes <- dados_filtrados %>%
      group_by(DS_TIPO_UNIDADE) %>%
      summarise(Media_LEITOS_EXISTENTES = mean(LEITOS_EXISTENTE, na.rm = TRUE))
    
    # Criar gráfico de barras
    ggplot(media_leitos_existentes, aes(x = DS_TIPO_UNIDADE, y = Media_LEITOS_EXISTENTES, fill = DS_TIPO_UNIDADE)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Média de LEITOS_EXISTENTES por Tipo de Unidade",
           x = "Tipo de Unidade",
           y = "Média de LEITOS_EXISTENTES") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_distribuicao_hospitais <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_distribuicao)
    
    # Calcular a contagem de hospitais por região e tipo de unidade
    distribuicao_hospitais <- dados_filtrados %>%
      group_by(REGIAO, DS_TIPO_UNIDADE) %>%
      summarise(Count = n())
    
    # Criar gráfico de barras
    ggplot(distribuicao_hospitais, aes(x = DS_TIPO_UNIDADE, y = Count, fill = REGIAO)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Distribuição de Hospitais por Região e Tipo de Unidade",
           x = "Tipo de Unidade",
           y = "Número de Hospitais") +
      theme_minimal() +
      theme(legend.position = "top")
  })
  
  output$grafico_taxa_leitos_sus <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_taxa_sus)
    
    # Calcular a taxa de leitos SUS por tipo de unidade
    taxa_leitos_sus <- dados_filtrados %>%
      group_by(DS_TIPO_UNIDADE) %>%
      summarise(Taxa_LEITOS_SUS = sum(LEITOS_SUS) / sum(LEITOS_EXISTENTE))
    
    # Criar gráfico de barras
    ggplot(taxa_leitos_sus, aes(x = DS_TIPO_UNIDADE, y = Taxa_LEITOS_SUS, fill = DS_TIPO_UNIDADE)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Taxa de Leitos SUS por Tipo de Unidade",
           x = "Tipo de Unidade",
           y = "Taxa de Leitos SUS") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_correlacao_leitos_tipo_unidade <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_correlacao)
    
    # Realizar a correlação entre o número de leitos e o tipo de unidade
    correlacao_leitos_tipo_unidade <- dados_filtrados %>%
      group_by(DS_TIPO_UNIDADE) %>%
      summarise(Correlacao_Leitos = cor(LEITOS_EXISTENTE, LEITOS_SUS, use = "complete.obs"))
    
    # Criar gráfico de barras
    ggplot(correlacao_leitos_tipo_unidade, aes(x = DS_TIPO_UNIDADE, y = Correlacao_Leitos, fill = DS_TIPO_UNIDADE)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Correlação entre Número de Leitos e Tipo de Unidade",
           x = "Tipo de Unidade",
           y = "Correlação") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_cobertura_uti_regiao <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_cobertura_uti)
    
    # Calcular a cobertura de UTI por região
    cobertura_uti_regiao <- dados_filtrados %>%
      group_by(REGIAO) %>%
      summarise(Cobertura_UTI = sum(UTI_TOTAL_EXIST, na.rm = TRUE) / sum(LEITOS_EXISTENTE, na.rm = TRUE))
    
    # Criar gráfico de barras
    ggplot(cobertura_uti_regiao, aes(x = REGIAO, y = Cobertura_UTI, fill = REGIAO)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Avaliação da Cobertura de UTI por Região",
           x = "Região",
           y = "Cobertura de UTI") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_comparacao_leitos <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_comparacao_leitos)
    
    # Calcular a média de leitos por tipo de unidade
    comparacao_leitos <- dados_filtrados %>%
      group_by(DESC_NATUREZA_JURIDICA) %>%
      summarise(Media_Leitos = mean(LEITOS_EXISTENTE, na.rm = TRUE))
    
    # Criar gráfico de barras
    ggplot(comparacao_leitos, aes(x = DESC_NATUREZA_JURIDICA, y = Media_Leitos, fill = DESC_NATUREZA_JURIDICA)) +
      geom_bar(stat = "identity", color = "white", size = 1.5) +  # Adiciona bordas brancas
      labs(title = "Comparação de Número de Leitos entre Hospitais Públicos e Privados",
           x = "Tipo de Unidade",
           y = "Média de Leitos") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "none")  # Remove a legenda
  })
  
  output$grafico_natureza_uf <- renderPlot({
    
    # Filtrar os dados com base no mês selecionado
    dados_filtrados <- filter(dados, Mes == input$mes_selecionado_natureza_uf)
    
    # Calcular a média de leitos por natureza jurídica e UF
    analise_natureza_uf <- dados_filtrados %>%
      group_by(DESC_NATUREZA_JURIDICA, UF) %>%
      summarise(Media_Leitos = mean(LEITOS_EXISTENTE, na.rm = TRUE))
    
    # Criar gráfico de barras
    ggplot(analise_natureza_uf, aes(x = UF, y = Media_Leitos, fill = DESC_NATUREZA_JURIDICA)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Análise da Natureza Jurídica por UF",
           x = "UF",
           y = "Média de Leitos") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotaciona os rótulos do eixo x
            plot.title = element_text(hjust = 0.5),  # Centraliza o título
            legend.position = "top")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)