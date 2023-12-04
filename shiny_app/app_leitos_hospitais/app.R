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
View(dados)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Análise de Leitos Hospitalares"),
  
  sidebarLayout(
    sidebarPanel(
      # Adicione um seletor de mês
      selectInput("mes_selecionado", "Selecione o Mês",
                  choices = unique(substr(dados$comp, 5, 6)),
                  selected = unique(substr(dados$comp, 5, 6))[1]),
      
      # Adicione botões seletivos para os tipos de leitos
      checkboxGroupInput("tipos_leitos_selecionados", "Selecione os Tipos de Leitos",
                         choices = c("LEITOS_EXISTENTE", "LEITOS_SUS", "UTI_TOTAL_EXIST", "UTI_TOTAL_SUS",
                                     "UTI_ADULTO_EXIST", "UTI_ADULTO_SUS", "UTI_PEDIATRICO_EXIST", "UTI_PEDIATRICO_SUS",
                                     "UTI_NEONATAL_EXIST", "UTI_NEONATAL_SUS", "UTI_QUEIMADO_EXIST", "UTI_QUEIMADO_SUS",
                                     "UTI_CORONARIANA_EXIST", "UTI_CORONARIANA_SUS"),
                         selected = c("LEITOS_EXISTENTE", "LEITOS_SUS"))
    ),
    mainPanel(
      # Adicione um gráfico de barras
      plotOutput("grafico_barras_media_leitos")
    )
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
    
    tipos_leitos_selecionados <- c("LEITOS_EXISTENTE", "LEITOS_SUS", "UTI_TOTAL_EXIST", "UTI_TOTAL_SUS",
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
  
}

# Run the application 
shinyApp(ui = ui, server = server)