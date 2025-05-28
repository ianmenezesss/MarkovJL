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
            println("\nEscolha o tamanho da matriz para modelar:")
            println("1. Matriz 2x2")
            println("2. Matriz 3x3")
            println("3. Matriz 4x4")
            println("4. Matriz 5x5")
            print("Digite sua escolha: ")
            tamanho = readline()
            
            if tamanho == "1"
                _init_2x2()
            elseif tamanho == "2"
                _init_3x3()
            elseif tamanho == "3"
                _init_4x4()
            elseif tamanho == "4"
                _init_5x5()
            else
                error("Tamanho inválido.")
            end
            
        elseif tipo == "2"
            println("\nEscolha o tamanho da matriz padrão:")
            println("1. Matriz 2x2")
            println("2. Matriz 3x3")
            println("3. Matriz 4x4")
            println("4. Matriz 5x5")
            print("Digite sua escolha: ")
            tamanho = readline()
            
            if tamanho == "1"
                _init_padrao_2x2()
            elseif tamanho == "2"
                _init_padrao_3x3()
            elseif tamanho == "3"
                _init_padrao_4x4()
            elseif tamanho == "4"
                _init_padrao_5x5()
            else
                error("Tamanho inválido.")
            end
        else
            error("Opção inválida")
        end
        
        n = size(transition_matrix, 1)
        estado = zeros(1, n)
        estado[1, end] = 1.0
        padrao = n
        
        new(transition_matrix, estado, padrao)
    end
end

# Manual initialization functions
function _init_2x2()
    println("Defina as probabilidades da matriz de transição 2x2 por linhas: ")
    
    a = _probabilidades_de_transicao("Probabilidade a00: ")
    c = _probabilidades_de_transicao("Probabilidade a01: ")
    b = _probabilidades_de_transicao("Probabilidade a10: ")
    d = _probabilidades_de_transicao("Probabilidade a11: ")
    
    if !isapprox(a + c, 1) || !isapprox(b + d, 1)
        error("As linhas da matriz devem somar 1!")
    end
    
    transicao = [a c; b d]
    println("Matriz de transição 2x2 definida:")
    println(transicao)
    
    return transicao
end

function _init_3x3()
    println("Defina as probabilidades da matriz de transição 3x3 por linhas: ")
    
    a = _probabilidades_de_transicao("Probabilidade a00: ")
    d = _probabilidades_de_transicao("Probabilidade a01: ")
    g = _probabilidades_de_transicao("Probabilidade a02: ")
    b = _probabilidades_de_transicao("Probabilidade a10: ")
    e = _probabilidades_de_transicao("Probabilidade a11: ")
    h = _probabilidades_de_transicao("Probabilidade a12: ")
    c = _probabilidades_de_transicao("Probabilidade a20: ")
    f = _probabilidades_de_transicao("Probabilidade a21: ")
    i = _probabilidades_de_transicao("Probabilidade a22: ")

    if !isapprox(a + d + g, 1) || !isapprox(b + e + h, 1) || !isapprox(c + f + i, 1)
        error("As linhas da matriz devem somar 1!")
    end
    
    transicao = [a d g; b e h; c f i]
    println("Matriz de transição 3x3 definida:")
    println(transicao)
    
    return transicao
end

function _init_4x4()
    println("Defina as probabilidades da matriz de transição 4x4 por linhas: ")
    
    a = _probabilidades_de_transicao("Probabilidade a00: ")
    e = _probabilidades_de_transicao("Probabilidade a01: ")
    i = _probabilidades_de_transicao("Probabilidade a02: ")
    m = _probabilidades_de_transicao("Probabilidade a03: ")
    b = _probabilidades_de_transicao("Probabilidade a10: ")
    f = _probabilidades_de_transicao("Probabilidade a11: ")
    j = _probabilidades_de_transicao("Probabilidade a12: ")
    n = _probabilidades_de_transicao("Probabilidade a13: ")
    c = _probabilidades_de_transicao("Probabilidade a20: ")
    g = _probabilidades_de_transicao("Probabilidade a21: ")
    k = _probabilidades_de_transicao("Probabilidade a22: ")
    o = _probabilidades_de_transicao("Probabilidade a23: ")
    d = _probabilidades_de_transicao("Probabilidade a30: ")
    h = _probabilidades_de_transicao("Probabilidade a31: ")
    l = _probabilidades_de_transicao("Probabilidade a32: ")
    p = _probabilidades_de_transicao("Probabilidade a33: ")

    if !isapprox(a + e + i + m, 1) || !isapprox(b + f + j + n, 1) || 
       !isapprox(c + g + k + o, 1) || !isapprox(d + h + l + p, 1)
        error("As linhas da matriz devem somar 1!")
    end
    
    transicao = [a e i m; b f j n; c g k o; d h l p]
    println("Matriz de transição 4x4 definida:")
    println(transicao)
    
    return transicao
end

function _init_5x5()
    println("Defina as probabilidades da matriz de transição 5x5 por linhas: ")
    
    a = _probabilidades_de_transicao("Probabilidade a00: ")
    f = _probabilidades_de_transicao("Probabilidade a01: ")
    k = _probabilidades_de_transicao("Probabilidade a02: ")
    p = _probabilidades_de_transicao("Probabilidade a03: ")
    u = _probabilidades_de_transicao("Probabilidade a04: ")
    b = _probabilidades_de_transicao("Probabilidade a10: ")
    g = _probabilidades_de_transicao("Probabilidade a11: ")
    l = _probabilidades_de_transicao("Probabilidade a12: ")
    q = _probabilidades_de_transicao("Probabilidade a13: ")
    v = _probabilidades_de_transicao("Probabilidade a14: ")
    c = _probabilidades_de_transicao("Probabilidade a20: ")
    h = _probabilidades_de_transicao("Probabilidade a21: ")
    m = _probabilidades_de_transicao("Probabilidade a22: ")
    r = _probabilidades_de_transicao("Probabilidade a23: ")
    w = _probabilidades_de_transicao("Probabilidade a24: ")
    d = _probabilidades_de_transicao("Probabilidade a30: ")
    i = _probabilidades_de_transicao("Probabilidade a31: ")
    n = _probabilidades_de_transicao("Probabilidade a32: ")
    s = _probabilidades_de_transicao("Probabilidade a33: ")
    x = _probabilidades_de_transicao("Probabilidade a34: ")
    e = _probabilidades_de_transicao("Probabilidade a40: ")
    j = _probabilidades_de_transicao("Probabilidade a41: ")
    o = _probabilidades_de_transicao("Probabilidade a42: ")
    t = _probabilidades_de_transicao("Probabilidade a43: ")
    y = _probabilidades_de_transicao("Probabilidade a44: ")

    if !isapprox(a + f + k + p + u, 1) || !isapprox(b + g + l + q + v, 1) ||
       !isapprox(c + h + m + r + w, 1) || !isapprox(d + i + n + s + x, 1) ||
       !isapprox(e + j + o + t + y, 1)
        error("As linhas da matriz devem somar 1!")
    end
    
    transicao = [a f k p u; b g l q v; c h m r w; d i n s x; e j o t y]
    println("Matriz de transição 5x5 definida:")
    println(transicao)
    
    return transicao
end

# Standard initialization functions
function _init_padrao_2x2()
    println("Usando matriz de transição 2x2 padrão")
    
    transicao = [0.7 0.3;
                 0.6 0.4]
    
    println("Matriz de transição 2x2 padrão definida:")
    println(transicao)
    
    return transicao
end

function _init_padrao_3x3()
    println("Usando matriz de transição 3x3 padrão")
    
    transicao = [0.8 0.2 0.0;
                 0.1 0.8 0.1;
                 0.0 0.2 0.8]
    
    println("Matriz de transição 3x3 padrão definida:")
    println(transicao)
    
    return transicao
end

function _init_padrao_4x4()
    println("Usando matriz de transição 4x4 padrão")
    
    transicao = [0.2 0.3 0.0 0.5;
                 0.0 0.7 0.1 0.2;
                 0.0 0.0 0.5 0.5;
                 1.0 0.0 0.0 0.0]
    
    println("Matriz de transição 4x4 padrão definida:")
    println(transicao)
    
    return transicao
end

function _init_padrao_5x5()
    println("Usando matriz de transição 5x5 padrão")
    
    transicao = [0.3 0.7 0.0 0.0 0.0;
                 0.5 0.5 0.0 0.0 0.0;
                 0.0 0.0 1.0 0.0 0.0;
                 0.0 0.0 0.2 0.8 0.0;
                 1.0 0.0 0.0 0.0 0.0]
    
    println("Matriz de transição 5x5 padrão definida:")
    println(transicao)
    
    return transicao
end

# Helper functions
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
        
        probabilidades = zeros(1, n)  # Vetor linha
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
        
        default_interacoes = if n == 2 && cadeia.padrao == 2
            10
        elseif n == 3 && cadeia.padrao == 3
            5
        elseif n == 4 && cadeia.padrao == 4
            20
        elseif n == 5 && cadeia.padrao == 5
            100
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
