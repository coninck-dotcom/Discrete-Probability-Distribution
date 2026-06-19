# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Hipergeométrica (Padrão R)
# ==============================================================================
# Exemplo: Retirar cartas de um baralho ou bolas de uma urna
m <- 20   # Número de elementos de sucesso na população
n <- 30   # Número de elementos de fracasso na população (População total M = m + n = 50)
k <- 10   # Tamanho da amostra retirada sem reposição

# 2. Suporte Dinâmico: O número mínimo e máximo possível de sucessos na amostra
limite_inferior <- max(0, k - n)
limite_superior <- min(m, k)
x <- limite_inferior:limite_superior

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
# dhyper e phyper calculam a PMF e a CDF respectivamente
dados_hiper <- data.frame(
  x  = x,
  fx = dhyper(x, m = m, n = n, k = k), # PMF
  Fx = phyper(x, m = m, n = n, k = k)  # CDF
)

# Definição dinâmica do intervalo dos eixos (passo dos breaks)
amplitude <- limite_superior - limite_inferior
passo_ticks <- max(1, round(amplitude / 10))

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
g1 <- ggplot(dados_hiper, aes(x = x, y = fx)) +
  # Desenha as linhas verticais para cada ponto do suporte
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1) +
  # Desenha os pontos no topo de cada bastão
  geom_point(color = "darkblue", size = 2.5) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(breaks = seq(limite_inferior, limite_superior, by = passo_ticks)) +
  labs(
    title = expression(paste("Função de Massa (PMF): Hiper(m, n, k)")),
    x = "Número de Sucessos na Amostra (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_hiper$x,
  xend  = dados_hiper$x + 1, # Cada degrau horizontal anda 1 unidade para a direita
  y     = dados_hiper$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus da escada
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados no início de cada degrau indicando continuidade à direita
  geom_point(data = dados_hiper, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = seq(limite_inferior, limite_superior + 1, by = passo_ticks)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Distribuição Acumulada (CDF): Hipergeométrica",
    x = "Número de Sucessos na Amostra (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2

# Salva como JPEG em alta resolução
ggsave("figHiper.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
