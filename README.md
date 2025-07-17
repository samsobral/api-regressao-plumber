# API para Regressão Linear com `plumber` em R

Projeto desenvolvido para a disciplina **ME918 - Produto de Dados** (2º Semestre de 2024), cujo objetivo foi criar uma API REST utilizando o pacote `plumber` para manipular dados, ajustar modelos de regressão linear e realizar predições.

## 📌 Funcionalidades da API

- Inserção de novos dados via POST
- Visualização dos dados com gráfico e reta de regressão
- Extração dos coeficientes estimados (JSON)
- Obtenção de resíduos e gráfico de resíduos (JSON + imagem)
- Predição para novos dados via GET ou JSON (vários registros)

## 🚀 Rotas disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/inserir` | Adiciona uma nova linha ao banco de dados |
| `GET`  | `/grafico` | Retorna gráfico com os pontos e a regressão |
| `GET`  | `/coeficientes` | Retorna os coeficientes do modelo (JSON) |
| `GET`  | `/residuos` | Retorna todos os resíduos (JSON) |
| `GET`  | `/grafico_residuos` | Retorna gráfico dos resíduos |
| `GET`  | `/significancia` | Retorna os p-valores dos coeficientes |
| `GET`  | `/prever` | Retorna a predição para `x` e `grupo` fornecidos |
| `POST` | `/prever_lote` | (eletivo) Recebe JSON com várias observações e retorna predições |

## 🛠️ Como utilizar

1. Execute o `plumber.R` com o botão "Run API" no RStudio
2. Acesse: `http://127.0.0.
