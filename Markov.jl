using LinearAlgebra

mutable struct Markov
    matriz_transicao::Matrix{Float64}
    estado::Matrix{Float64} 
    padrao::Int
    
    function Markov()
        println("Selecione o tipo de configuração da matriz de transição:\n") #Menu pra Ler a opção do usuario
        println("1. Modelar Matriz Manualmente")
        println("2. Utilizar Matriz Padrão")
        print("Digite sua escolha: ")
        tipo = readline()
        
        matriz_transicao = if tipo == "1" #Tipo 1 leva o tamanho pra funcao que modela
            println("\nDigite o tamanho N da matriz N×N:")
            print("Tamanho N = ")
            n = parse(Int, readline())
            modelo_matriz(n)
            
        elseif tipo == "2" #Tupo 2 leva pra o outro menu de escolha
            println("\nEscolha o tamanho da matriz padrão:")
            println("1. Matriz 2x2")
            println("2. Matriz 3x3")
            println("3. Matriz 4x4")
            println()
            print("Digite sua escolha: ") #As escolhas levam para a funcao de cada tamanho de matriz ja pronta
            tamanho = readline()
                                        
            if tamanho == "1"  
                _init_padrao_2x2()
            elseif tamanho == "2"
                _init_padrao_3x3()
            elseif tamanho == "3"
                _init_padrao_4x4()
            else
                error("Tamanho inválido.")
            end
        else
            error("Opção inválida")
        end
        
        n = size(matriz_transicao, 1) #Pega tamanho da matriz (N linhas)
        estado = zeros(1, n) #Cria vetor de estado zerado
        estado[1, end] = 1.0  #Define último estado como 100% (estado inicial)
        
        new(matriz_transicao, estado, tipo == "2" ? n : 0)  #Se usou matriz tipo 2, guarda o tamanho n. Senão, guarda 0.
    end
end

function modelo_matriz(n::Int)  #Funcao que vai fazer a matriz nxn solicitada 
    #Ela utiliza dois for (um pra linha e outro pra coluna), variaves podem ser geradas automaticamente para facilitar todos os testes, caso voce aperte apenas enter ele ja vai completar automaticamente.
    println("\nDefinindo matriz $n×$n (digite as probabilidades por Linha)")
    transicao = zeros(n, n) #Inicializa matriz de transição com toda zero

    for lin in 1:n #For da linha
        println("\nLinha $lin:")
        soma = 0.0
        
        for col in 1:n-1 #For da coluna e a ultima é automatica pra ser gerada automaticamente
            while true  #While pra verificar se o valor é valido e não cancelar o programa
                try
                    print("Probabilidade a$lin$col (0-1, padrão 0): ")
                    input = readline()
                    val = isempty(input) ? 0.0 : parse(Float64, input)  #Se so clicar enter vai ser 0
                    
                    if val < 0 || val > 1  #Verificação se a entraada é entre 0 e 1
                        println("Valor deve estar entre 0 e 1!")
                        continue
                    end
                    
                    if (soma + val) > 1.0 #A soma geral nao pode exceder 1
                        println("Soma parcial excede 1! Máximo possível: $(1.0 - soma)")
                        continue
                    end
                    
                    transicao[lin, col] = val
                    soma += val
                    break
                catch e
                    if isa(e, ArgumentError)
                        println("Valor inválido! Digite um número ou Enter para 0.")
                    else
                        rethrow(e)
                    end
                end
            end
        end
        
        p_final = 1.0 - soma  #Calculo automatico e atribuição da ultima variavel 
        if p_final < 0
            error("A soma das probabilidades da linha $lin excede 1!")
        end
        transicao[lin, n] = p_final
        println("Probabilidade a$lin$n (padrão restante: $(round(p_final, digits=4)): $(round(p_final, digits=4))")
    end
    
    println("\nMatriz de transição definida (soma por linhas = 1):")
    _print_da_matriz(transicao)
    
    return transicao
end

function _init_padrao_2x2() #Funcao que já guarda uma matriz 2x2 pra teste
    println("Usando matriz de transição 2x2 padrão")
    
    transicao = [0.7 0.3;
                 0.6 0.4]
    
    println("Matriz de transição 2x2 padrão definida:")
    _print_da_matriz(transicao)
    
    return transicao
end

function _init_padrao_3x3() #Funcao que já guarda uma matriz 3x3 pra teste
    println("Usando matriz de transição 3x3 padrão")
    
    transicao = [0.8 0.2 0.0;
                 0.1 0.8 0.1;
                 0.0 0.2 0.8]
    
    println("Matriz de transição 3x3 padrão definida:")
    _print_da_matriz(transicao)
    
    return transicao
end

function _init_padrao_4x4() #Funcao que já guarda uma matriz 4x4 pra teste
    println("Usando matriz de transição 4x4 padrão")
    
    transicao = [0.2 0.3 0.0 0.5;
                 0.0 0.7 0.1 0.2;
                 0.0 0.0 0.5 0.5;
                 1.0 0.0 0.0 0.0]
    
    println("Matriz de transição 4x4 padrão definida:")
    _print_da_matriz(transicao)
    
    return transicao
end

function _print_da_matriz(mat) #Funcao que vai printar a matriz de uma forma mais legivel
    rows, cols = size(mat)
    for i in 1:rows
        print("[")
        for j in 1:cols
            val = mat[i,j]
            print(val)
            j < cols && print(" ")
        end
        i < rows && println("]")
    end
    println("]")
end

function simular(markov::Markov, interacoes::Int)  #Funcao que vai fazer a simulacao da cadeia
    println("\nResultados da Simulação:")
    for i in 1:interacoes
        markov.estado = markov.estado * markov.matriz_transicao #Faz o processo de cadeias de markov 
                                                                #Multiplicacao do estado pela matriz transição
        n = size(markov.estado, 2)
        estados_str = join(["Estado $j = $(round(markov.estado[1,j], digits=4))" for j in 1:n], ", ")
        println("Interação $i: $estados_str") #Faz o print de estado a estado a partir de todo o processo
    end

    println("\nDistribuição Final:") #Impressao do resultado final de estado apos todas as interações
    for j in 1:size(markov.estado, 2)
        prob = markov.estado[1,j]
        println("Probabilidade do Estado $j: $(round(prob*100, digits=2))%") #Impressao como porcentagem 
    end
end

function ler_estado(cadeia::Markov) 
    n = size(cadeia.estado, 2)
    println("\nDefina as probabilidades iniciais:")
    
    probabilidades = zeros(1, n)
    soma = 0.0
    
    for i in 1:n-1  #For para definir probabilidades de cada estado (exceto o último)
        while true
            try
                print("Probabilidade do Estado $i inicial (0-1, padrão 0): ")#Usuario bota a probabilidade do estado atual
                input_val = readline()
                p = isempty(input_val) ? 0.0 : parse(Float64, input_val)
                
                if p < 0 || p > 1 #Validação do valor
                    println("Valor deve estar entre 0 e 1!")
                    continue
                end
                
                if soma + p > 1   #Validação da soma
                    println("A soma das probabilidades não pode exceder 1!")
                    continue
                end
                
                probabilidades[1,i] = p
                soma += p
                break
            catch e
                if isa(e, ArgumentError)
                    println("Digite um número válido!")
                else
                    rethrow(e)
                end
            end
        end
    end

    p_final = 1 - soma
    if p_final < 0  #Calculo automatico e atribuição da ultima variavel 
        error("A soma das probabilidades iniciais não pode exceder 1!")
    end
    probabilidades[1,end] = p_final
    println("Probabilidade do Estado $n inicial (padrão restante $(round(p_final, digits=4)): $(round(p_final, digits=4))")
    
    return probabilidades
end

function main()
    try
        println("Simulação de Cadeia de Markov")
        cadeia = Markov() 
        
        cadeia.estado = ler_estado(cadeia)
        #Determinação das interacoes padrao pra teste
        default_interacoes = if cadeia.padrao == 2 #10 interacoes pra cadeia 2x2 que já chega na forma de repeticao 
            10  
        elseif cadeia.padrao == 3 # 5 interacoes pra 3x3 para responder a questao que achei e esta na documentacao
            5   
        elseif cadeia.padrao == 4 # 20 pra 4x4 pra chegar na forma repeticao
            20  
        else
            100 # Para as que o usuario modela 100 é o padrao de interacoes
        end
        
        print("\nQuantas interações deseja simular? (padrão $default_interacoes Interações) ") #Caso o usuario queira escolher o numero de interacoes
        input_val = readline()
        interacoes = isempty(input_val) ? default_interacoes : parse(Int, input_val)
        
        println("\nIniciando simulação para $interacoes interações...")
        simular(cadeia, interacoes) #Utiliza a funcao simular para simular a cadeia na quantidade de interacoes
        
    catch e
        println("\nErro: ", e)
    end
end

main()