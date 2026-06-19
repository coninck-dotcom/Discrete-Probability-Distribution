# Carregar as bibliotecas necessárias
# Versão Uniforme Discreta
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Binomial
n <- 10   # Número de ensaios/tentativas
p <- 0.6  # Probabilidade de sucesso em cada ensaio

# 2. Suporte: A Binomial assume valores inteiros de 0 até n
x <- 0:n  

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
dados_binomial <- data.frame(
  x  = x,
  fx = dbinom(x, size = n, prob = p), # PMF
  Fx = pbinom(x, size = n, prob = p)  # CDF
)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões)
# ==============================================================================
g1 <- ggplot(dados_binomial, aes(x = x, y = fx)) +
  # Desenha as linhas verticais para cada ponto do suporte
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1) +
  # Desenha os pontos no topo de cada bastão
  geom_point(color = "darkblue", size = 2.5) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(breaks = seq(0, n, by = max(1, round(n/10)))) +
  labs(
    title =  expression(paste("Função de Massa (PMF): Bin(N",",", theta,")")),
    x = "Número de Sucessos (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos)
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_binomial$x,
  xend  = dados_binomial$x + 1, # Cada degrau horizontal anda 1 unidade para a direita
  y     = dados_binomial$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus da escada
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados (no início de cada degrau) indicando a continuidade à direita
  geom_point(data = dados_binomial, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = seq(0, n + 1, by = max(1, round(n/10)))) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Distribuição Acumulada (CDF): Binomial",
    x = "Número de Sucessos (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2
# 2. Salvar como JPEG (o R reconhece o formato pela extensão .jpeg)
ggsave("figBin1.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
