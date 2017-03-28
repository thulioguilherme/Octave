## Copyright (C) 2016 Jesus
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} AESTRELA (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Jesus <Jesus@JESUS-PC>
## Created: 2016-09-19

function [retval] = AESTRELA (origem, destino, tamanho)
  
  #leitura dos grafo
  grafo = fopen("graph.txt", "r");
  #leitura das distancias
  distancias = fopen("distance.txt", "r");
  
  #verificando a abertura dos arquivos
  if (~grafo) || (~distancias)
    printf("erro ao abrir o arquivo\n");
  endif
  
  #recebendo os dados
  G = fscanf(grafo,"%f",[tamanho tamanho]);
  D = fscanf(distancias,"%f",[tamanho tamanho]);
  
  #Converter de comprimento para tempo
  D = (D / 30) * 60;
  
  printf("Partida: E%d - Destino: E%d\n", origem, destino);
    
  cont = 1;
  gasto = 1;
  atual = origem;
  caminho = [origem];
  acumulado = 0;

  while(gasto ~= 0)
  
    #verificando os nos da mesma linha que o atual
    i = 1;
    estacoes = [];
    while(i <= tamanho)
      estacoes = [estacoes,G(atual, i)];
      ++i;
    endwhile
    
    #print(estacoes);
    #estacoes
    
    #verificando os nos que sao vizinhos
    cont = 1;
    estacoesAtuais = [];
    
    while(cont <= length(estacoes))
      if(estacoes(cont) == 1)
        estacoesAtuais = [estacoesAtuais, cont];
      endif
      cont = (cont+1);
    endwhile
    
    #printf("estacoes escolhidas");
    #estacoesAtuais
    
    #calculando a Heuristica 
    valores = [];
    cont = 1;
    while(cont <= length(estacoesAtuais))
      valor = D(atual,estacoesAtuais(cont)) + acumulado+ D(destino,estacoesAtuais(cont));
      valores = [valores, valor];
      cont = (cont+1);
    endwhile
    
    if(length(valores) == 0)
      printf("Nao ha nenhum caminho possivel.\n");
      break;
    endif
    
    #verificando o que tem melhor custo
    if(length(valores) >= 1)
      menorValor = valores(1);
      menorIndice = estacoesAtuais(1);
    endif
    
    cont = 2;
    while(cont <= length(valores)) 
      if(valores(cont) < menorValor)
        menorValor = valores(cont);
        menorIndice = estacoesAtuais(cont);
      endif
      cont = cont+1;
    endwhile
    
    acumulado = acumulado + D(atual,menorIndice);
    atual = menorIndice;
    caminho = [caminho, atual];
    
    if(atual == destino)
      gasto = 0;
      break;
    endif
    
  endwhile
  printf("Caminho com o menor custo de tempo:\n");
  for i = 1:(columns(caminho) - 1)
    printf("E%d -> ", caminho(i));
  endfor
  printf("E%d\n", destino);
  
  total = 0;
  for i = 2:columns(caminho)
    total = total + D(caminho(i - 1), caminho(i));
  endfor
  printf("Tempo gasto dentro do metro: %d minutos\n", total);
  printf("Tempo gasto em baldeacao: %d minutos\n", 4*(columns(caminho) - 2));
  total = total + 4*(columns(caminho) - 2);
  printf("Custo total: %d minutos\n", total);

endfunction