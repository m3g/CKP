
## Modules e Revise

A forma mais prática de desenvolver códigos em Julia, quando estes
começam a ficar mais elaborados, é usar módulos e o pacote `Revise`.  

(para quem usa Visual Studio Code parece que o `Revise` já é instalado
e carregado por padrão). Para instalar `Revise`, use:

```julia
julia> ] add Revise
```

A fluxo de trabalho, com estas ferramentas, é:

- Crie um arquivo com uma função de interesse, por exemplo:
  `f.jl`

```julia
function f(x)
  y = 2*x
  return y
end
```

- Crie um arquivo, por exemplo "MyModule.jl", no qual você define um
  módulo de mesmo nome, e inclua os arquivos com as definições de suas
  funções.

```julia
module MyModule
  include("./f.jl")  
  export f
end
```

O comando `export f` faz com que a função possa ser usada diretamente,
como `f(1)`, em lugar de `MyModule.f(1)`. Exportar ou não as funções é
opcional. 

Agora inicie o Julia, e carregue seu módulo com os seguintes comandos
(você também pode colocar estes comandos em uma arquivo simples `.jl` e
carregar ele com `julia -i arquivo.jl`):

```julia
using Revise
push!(LOAD_PATH,"/path/to/MyModule")
using MyModule
```

Isto vai carregar o módulo com suas funções. Como o módulo foi carregado após 
o carregamento de `Revise`, as modificações feitas nos arquivos que
definem as funções do módulo serão automaticamente atualizadas.
 
Ou seja:

```julia
julia> using Revise

julia> push!(LOAD_PATH,"/path/to/MyModule")

julia> using MyModule

julia> f(1)
2
```

Agora modifico o arquivo `f.jl` fazendo com que a função multiplique
o valor de `x` por 5 (e salvo, claro):

```julia
julia> f(1)
5

```

Ou seja, o REPL pode ficar aberto e posso modificar/corrigir a função
(testar suas alocações, imprimir coisas para debugar, etc.) e executar a
função sucessivamente sem ter que recarregar nenhum arquivo.












