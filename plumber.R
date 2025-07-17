library(plumber)
library(readr)
library(dplyr)
library(ggplot2)
library(jsonlite)
library(listr)
library(broom)
library(gridExtra)
##se necessário instalar os pacotes
#install.packages("listr")
#install.packages("vroom")
#install.packages("farver")
#install.packages("gridExtra")
#install.packages("broom")
df <- read_csv("dados_regressao.csv")
pw <- read_csv("senhas.csv")
inferencia <- lm(y ~ x + grupo, data = df)
#* @apiTitle Regressões
 


#* Insere uma nova observação
#* @param y Variável y a ser adicionada (numérico)
#* @param x Variável x a ser adicionada relacionada a y (numérico)
#* @param grupo Variável grupo a ser adicionada relacionada a y (A,B ou C)
#* @param ident Sua identificação
#* @param senha Sua senha
#* @post /inserir
function(y,x,grupo,res,ident,senha){
  agora <- lubridate::now()
  newy <- as.numeric(y)
  newx <- as.numeric(x)
if (!(ident %in% pw$id)){
  res$body <- "Identificação não existente"
}  
else {
  if (is.na(newx)){
    res$body <- "Erro: x deve ser numérico"
  }
  else {
    if (is.na(newy)){
    res$body <- "Erro: y deve ser numérico"
  } else {
      if (!(grupo %in% c("A","B","C"))) {
      res$body <- "Erro: grupo deve ser A, B ou C"
    }
      else {
        if (subset(pw,pw$id == ident)$password == senha){
  newdataframe <- data.frame(x = newx, grupo = grupo, y = newy, momento_registro = agora)
  df <<- rbind(df,newdataframe)
  inferencia <<- lm(y ~ x + grupo, data = df)
  write_csv(rbind(df,newdataframe), file = "dados_regressao.csv")
  res$body <- "Inserção Feita com Sucesso"
  } 
        else {
   res$body = "Senha incorreta"
}
}
}
}
}
}
#* Gráfico dos dados
#* @get /plot
#* @serializer png
function() {
  graf <- ggplot(df, aes(x, y, colour = grupo)) +
    geom_point()  +
    geom_smooth(method = "lm", colour = "pink", se = FALSE)
  print(graf)
}

#* Retorna os coeficientes da inferência
#* @get /coeff
#* @serializer unboxedJSON
function(){
  coef <- coef(inferencia)
  coef <- as.list(coef)
  coef <- list_rename(coef, Beta0 = "(Intercept)")
  coef
}


#* Retorna os residuos da inferência
#* @get resid
#* @serializer unboxedJSON
function(){
  resid <- residuals(inferencia)
  as.list(resid)
}

#* Retorna os gráficos de resíduos da inferência
#* @get /graficos
#* @serializer png
function(){
  inferencia <- lm(y ~ x + grupo, data = df)
  
  # Extraindo os diagnósticos do modelo
  diagnostico <- augment(inferencia)
  
  # Criando os gráficos
  grafico1 <- ggplot(diagnostico, aes(.fitted, .resid)) +
    geom_point() +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    labs(title = "Resíduos vs Ajustados", x = "Valores Ajustados", y = "Resíduos")
  
  grafico2 <- ggplot(diagnostico, aes(sample = .std.resid)) +
    stat_qq() +
    stat_qq_line() +
    labs(title = "Q-Q Plot dos Resíduos", x = "Teóricos", y = "Amostrados")
  
  grafico3 <- ggplot(diagnostico, aes(seq_along(.cooksd), .cooksd)) +
    geom_bar(stat = "identity") +
    labs(title = "Cook's Distance", x = "Observação", y = "Cook's Distance")
  
  grafico4 <- ggplot(diagnostico, aes(.hat, .std.resid)) +
    geom_point(aes(size = .cooksd)) +
    labs(title = "Alavancagem vs Resíduos Padronizados", x = "Leverage", y = "Resíduos Padronizados")
  
  painel <- grid.arrange(grafico1, grafico2, grafico3, grafico4, nrow = 2, ncol = 2)
  print(painel)
}

#* Retorna a significância estatistica dos parâmetros
#* @get sign
#* @serializer unboxedJSON
function(){
  pval <- summary(inferencia)
  pval <- as.list(pval$coefficients[,4])
  pval <- list_rename(pval, Beta0 = "(Intercept)")
  pval
}

#* Realizar predição com o modelo ajustado
#* @param x valor numérico contínuo
#* @param grupo categórico (A, B, ou C)
#* @get /predicao
function(x, grupo) {
  x <- as.numeric(x)
  
  # Validando a entrada de 'grupo'
  if (!(grupo %in% c("A", "B", "C"))) {
    return(list(Erro = "grupo deve ser 'A', 'B', ou 'C'"))
  }
  if (is.na(x)){
    return(list(Erro = "x deve ser numérico"))
  }
  
  modelo <- inferencia
  
  # Criando um novo dataframe com os valores para predição
  novos_dados <- data.frame(x = x, grupo = grupo)
  
  
  predicao <- predict(modelo, novos_dados)
  
  return(list(Predição = predicao))
}
