Documentação da API
================
Samuel,André, Raul,Allyson
2024-10-23

## Como executar a API

Para rodar a API, execute o seguinte comando no seu RStudio, no terminal
ou em qualquer ambiente R que esteja com o pacote plumber instalado:

plumb(file=‘plumber.R’)\$run()

## Rotas Disponíveis

### 1.**Endpoints**

#### POST /inserir

**Descrição:**  
Essa rota permite inserir uma nova linha no banco de dados
`dados_regressao.csv` com um novo valor de x, y, grupo, o momento de
registro, além de validar a identidade e senha.

**Parâmetros de Query:**

- **y** (numérico): valor de y a ser adicionado.  
- **x** (numérico): valor de x a ser adicionado.  
- **grupo** (categórico): valor de grupo (A, B ou C).  
- **ident** (texto): identificação do usuário.  
- **senha** (texto): senha correspondente ao ident.

#### GET /plot

**Descrição:**

Este endpoint gera um gráfico com os dados x, y e grupo, exibindo a
linha de regressão ajustada. O gráfico exibirá os pontos coloridos por
grupo e uma linha de tendência ajustada.

#### GET /coeff

**Descrição:**

Este endpoint retorna os coeficientes do modelo de regressão ajustado.

#### GET /resid

**Descrição:**

Este endpoint retorna os resíduos do modelo de regressão.

#### GET /sign

**Descrição:**

Este endpoint retorna a significância estatística (p-valores) dos
coeficientes do modelo:

#### GET /predicao

**Descrição:**

Este endpoint faz predições baseadas no modelo ajustado. As predições
são feitas para valores de x e grupo especificados via parâmetros de
query.

**Parâmetros de Query:**

x: Valor da variável x para predição. grupo: Grupo associado à
observação (“A”, “B”, “C”).

{ “predicao”: 5.23 }

#### Considerações Finais

Para garantir a integridade do banco de dados, a API foi projetada com
validações para as variáveis x, y, grupo, além de controle de acesso por
senha. O uso dessa API deve ser feito com atenção para evitar
inconsistências nos dados. Além disso, rotas eletivas foram criadas para
expandir as funcionalidades e permitir mais flexibilidade na interação
com os dados.

## Exemplo de Requisições para a API

### Requisições:

1.  **Inserir Nova Observação**
    - Método: POST

    - Rota: /inserir

    - **Dados:** Adicione os valores de acordo com os dados que você
      tiver, utilizando ponto (.) para separação de casas decimais e
      “A”, “B” ou “C” para o grupo (letras maiúsculas).

    - **Exemplo de Requisição:**

      ``` json
      {
        "x": 4.55,
        "y":-1.22,
        "grupo": "B",
        "ident": "De acordo com o login do usuário",
        "senha": "De acordo com o login do usuário"
      }
      ```
2.  **Inferência dos Dados**
    - Método: GET
    - Rota: /inferir
    - **Não precisa adicionar nada.**
3.  **Retorna os Coeficientes da Inferência**
    - Método: GET
    - Rota: /coeff
    - **Não precisa adicionar nada.**
4.  **Retorna os Resíduos da Inferência**
    - Método: GET
    - Rota: /resid
    - **Não precisa adicionar nada.**
5.  **Retorna os Gráficos de Resíduos da Inferência**
    - Método: GET
    - Rota: /plot
    - **Não precisa adicionar nada.**
6.  **Retorna a Significância Estatística dos Dados**
    - Método: GET
    - Rota: /sign
    - **Não precisa adicionar nada.**
7.  **Realizar Predição com o Modelo Ajustado**
    - Método: GET

    - Rota: /predicao

    - **Dados:** Utilize ponto (.) para separação de casas decimais e
      “A”, “B” ou “C” para o grupo (letras maiúsculas).

    - **Exemplo de Requisição:**

      ``` json
      {
        "x": -2.55,
        "grupo": "B"
      }
      ```

### Observações

Para exemplo siga os seguintes passos, lembrando de utilizar ponto (.)
para separação de casas decimais e letra maiúscula para escolha do grupo
(A, B ou C).

Na requisição 1, “POST” adicionar valores para x e y de acordo com suas
observações, teste adicionar os valores x = -4.55, y = -1.22, grupo = B,
para identificação colocar “0” e utilizar a senha “escorpiao”. Em
seguida, observe os endpoints “PLOT”, “COEFF”, “RESID”, “GRAFICOS”,
“SIGN”. Para a parte de “PREDICAO”, adicione o valor x = -2.55 e grupo =
B e execute. Observe o resultado da predição.
