## README - Simulação de Cadeias de Markov em Julia  

### 📌 Integrantes  
- **Ian Freire**  
- **Jadson**  
- **Ian Menezes**  

---

### 🔍 Descrição  
Implementação de uma simulação de **Cadeias de Markov** em Julia, com:  
- Modelagem manual de matrizes de transição  
- Matrizes pré-definidas (2x2, 3x3, 4x4)  
- Cálculo de probabilidades de estado após *n* iterações  

---

### ⚙️ Funcionalidades  
- **Menu interativo** para configuração:  
  - Escolha entre matriz personalizada ou padrão  
  - Validação de probabilidades (soma = 1 por linha)  
- **Simulação passo a passo**:  
  - Exibe probabilidades por estado a cada iteração  
  - Mostra distribuição estacionária final  

---

### 📦 Estrutura do Código  
#### Principais funções:  
- `Markov()`: Construtor da cadeia (define matriz de transição)  
- `modelo_matriz(n)`: Cria matriz manualmente (tamanho *n×n*)  
- `simular()`: Executa as iterações e exibe resultados  
- Matrizes padrão (`_init_padrao_2x2()`, etc.)  

---

### 🚀 Como Executar  
1. Instale [Julia](https://julialang.org/downloads/)  
2. Execute no REPL:  
   ```julia
   include("markov.jl")
   main()
Siga os prompts no terminal!

📊 Exemplo de Saída
plaintext
Interação 5: Estado 1 = 0.352, Estado 2 = 0.648  
Distribuição Final:  
Estado 1: 35.2%  
Estado 2: 64.8%  
📚 Teoria
Cadeias de Markov convergem para uma distribuição estacionária quando a matriz de transição é regular:

[ a  c ]   [ π₁ ]     [ p₁ ]  
[ b  d ] ∙ [ π₂ ]  =  [ p₂ ]  →  [ p₁  p₂ ] = [ πₑ  πₑ ]  
📝 Licença
Projeto acadêmico - livre para uso e modificação.


### ✨ Destaques  
- **Entrada segura**: Validação de inputs do usuário  
- **Visualização clara**: Formatação de matrizes e resultados  
- **Extensível**: Adicione novos padrões facilmente  

--- 
