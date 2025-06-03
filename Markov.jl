using LinearAlgebra

mutable struct Markov
    transition_matrix::Matrix{Float64}
    estado::Matrix{Float64} 
    padrao::Int
    
    function Markov()
        println("Selecione o tipo de configuração da matriz de transição:\n")
        println("1. Modelar Matriz Manualmente")
        println("2. Utilizar Matriz Padrão")
        print("Digite sua escolha: ")
        tipo = readline()
        
        transition_matrix = if tipo == "1"
            println("\nDigite o tamanho N da matriz N×N:")
            print("Tamanho N = ")
            n = parse(Int, readline())
            modelo_matriz(n)
            
        elseif tipo == "2"
            println("\nEscolha o tamanho da matriz padrão:")
            println("1. Matriz 2x2")
            println("2. Matriz 3x3")
            println("3. Matriz 4x4")
            println()
            print("Digite sua escolha: ")
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
        
        n = size(transition_matrix, 1)
        estado = zeros(1, n)
        estado[1, end] = 1.0
        
        new(transition_matrix, estado, tipo == "2" ? n : 0)
    end
end

function modelo_matriz(n::Int)
    println("\nDefinindo matriz $n×$n (digite as probabilidades por Linha)")
    transicao = zeros(n, n)
    
    for lin in 1:n
        println("\nLinha $lin:")
        soma = 0.0
        
        for col in 1:n-1
            while true
                try
                    print("Probabilidade a$lin$col (0-1, padrão 0): ")
                    input = readline()
                    val = isempty(input) ? 0.0 : parse(Float64, input)
                    
                    if val < 0 || val > 1
                        println("Valor deve estar entre 0 e 1!")
                        continue
                    end
                    
                    if (soma + val) > 1.0
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
        
        p_final = 1.0 - soma
        if p_final < 0
            error("A soma das probabilidades da linha $lin excede 1!")
        end
        transicao[lin, n] = p_final
        println("Probabilidade a$lin$n (padrão restante: $(round(p_final, digits=4)): $(round(p_final, digits=4))")
    end
    
    println("\nMatriz de transição definida (soma por linhas = 1):")
    print_matrix_clean(transicao)
    
    return transicao
end

function _init_padrao_2x2()
    println("Usando matriz de transição 2x2 padrão")
    
    transicao = [0.7 0.3;
                 0.6 0.4]
    
    println("Matriz de transição 2x2 padrão definida:")
    print_matrix_clean(transicao)
    
    return transicao
end

function _init_padrao_3x3()
    println("Usando matriz de transição 3x3 padrão")
    
    transicao = [0.8 0.2 0.0;
                 0.1 0.8 0.1;
                 0.0 0.2 0.8]
    
    println("Matriz de transição 3x3 padrão definida:")
    print_matrix_clean(transicao)
    
    return transicao
end

function _init_padrao_4x4()
    println("Usando matriz de transição 4x4 padrão")
    
    transicao = [0.2 0.3 0.0 0.5;
                 0.0 0.7 0.1 0.2;
                 0.0 0.0 0.5 0.5;
                 1.0 0.0 0.0 0.0]
    
    println("Matriz de transição 4x4 padrão definida:")
    print_matrix_clean(transicao)
    
    return transicao
end

function _probabilidades_de_transicao(mensagem)
    while true
        try
            print(mensagem)
            valor = parse(Float64, readline())
            if 0 ≤ valor ≤ 1
                return valor
            end
            println("Valor deve estar entre 0 e 1!")
        catch e
            if isa(e, ArgumentError)
                println("Digite um número válido!")
            else
                rethrow(e)
            end
        end
    end
end

function print_matrix_clean(mat)
    print("[")
    rows, cols = size(mat)
    for i in 1:rows
        for j in 1:cols
            val = mat[i,j]
            print(val)
            j < cols && print(" ")
        end
        i < rows && println(";")
    end
    println("]")
end

function simular(markov::Markov, interacoes::Int)
    println("\nResultados da Simulação:")
    for i in 1:interacoes
        markov.estado = markov.estado * markov.transition_matrix
        
        n = size(markov.estado, 2)
        estados_str = join(["Estado $j = $(round(markov.estado[1,j], digits=4))" for j in 1:n], ", ")
        println("Interação $i: $estados_str")
    end

    println("\nDistribuição Final:")
    for j in 1:size(markov.estado, 2)
        prob = markov.estado[1,j]
        println("Probabilidade do Estado $j: $(round(prob*100, digits=2))%")
    end
end

function main()
    try
        println("Simulação de Cadeia de Markov")
        cadeia = Markov()
        
        n = size(cadeia.estado, 2)
        println("\nDefina as probabilidades iniciais:")
        
        probabilidades = zeros(1, n)
        soma = 0.0
        
        for i in 1:n-1
            while true
                try
                    print("Probabilidade do Estado $i inicial (0-1, padrão 0): ")
                    input_val = readline()
                    p = isempty(input_val) ? 0.0 : parse(Float64, input_val)
                    
                    if p < 0 || p > 1
                        println("Valor deve estar entre 0 e 1!")
                        continue
                    end
                    
                    if soma + p > 1
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
        if p_final < 0
            error("A soma das probabilidades iniciais não pode exceder 1!")
        end
        probabilidades[1,end] = p_final
        println("Probabilidade do Estado $n inicial (padrão restante $(round(p_final, digits=4)): $(round(p_final, digits=4))")
        
        cadeia.estado = probabilidades
        
        default_interacoes = if cadeia.padrao == 2
            10
        elseif cadeia.padrao == 3
            5
        elseif cadeia.padrao == 4
            20
        else
            100
        end
        
        print("\nQuantas interações deseja simular? (padrão $default_interacoes Interações) ")
        input_val = readline()
        interacoes = isempty(input_val) ? default_interacoes : parse(Int, input_val)
        
        println("\nIniciando simulação para $interacoes interações...")
        simular(cadeia, interacoes)
        
    catch e
        println("\nErro: ", e)
    end
end

main()

#= 
Cadeias de markov são cadeias de probabilidades que como a matriz de probabilidade de transição é regular
elas chegam a um ponto que as probabilidades nao dependem mais do estado inicial 
assim chegando a forma de matriz estocástica

[a c] . [pi1]  =  [p1]    ->   [a c] . [p1] = [p1]  ... = [pe]
[b d]   [pi2]     [p2]         [b d]   [p2]   [p2]        [pe]

[acbd] = matriz transição
pi = probabilidade inicial
p = probabilidade de condição
pe = probabilidade estocástica
=#
