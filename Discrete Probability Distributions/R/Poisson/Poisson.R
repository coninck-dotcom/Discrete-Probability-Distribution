# Versão Uniforme Discreta
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição do parâmetro da Distribuição de Poisson
lambda <- 6  # Taxa média de ocorrência (equivalente ao n*p da sua binomial)

# 2. Suporte: Teoricamente infinito, mas limitamos para visualização prática
# Usamos uma folga ao redor de lambda (ex: até lambda + 4 * sqrt(lambda))
limite_superior <- round(lambda + 4 * sqrt(lambda))
x <- 0:limite_superior  

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
dados_poisson <- data.frame(
  x  = x,
  fx = dpois(x, lambda = lambda), # PMF (dpois)
  Fx = ppois(x, lambda = lambda)  # CDF (ppois)
)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões)
# ==============================================================================
g1 <- ggplot(dados_poisson, aes(x = x, y = fx)) +
  # Desenha as linhas verticais para cada ponto do suporte
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1) +
  # Desenha os pontos no topo de cada bastão
  geom_point(color = "darkblue", size = 2.5) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(breaks = seq(0, limite_superior, by = max(1, round(limite_superior/10)))) +
  labs(
    # title = paste0("Função de Massa (PMF) - Pois(lambda=", lambda, ")"),
    title =  expression(paste("Função de Massa (PMF): Pois (",lambda,")")),
    x = "Número de Ocorrências (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos)
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_poisson$x,
  xend  = dados_poisson$x + 1, # Cada degrau horizontal anda 1 unidade para a direita
  y     = dados_poisson$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus da escada
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados (no início de cada degrau) indicando a continuidade à direita
  geom_point(data = dados_poisson, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = seq(0, limite_superior + 1, by = max(1, round(limite_superior/10)))) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Número de Ocorrências (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2
# 2. Salvar como JPEG (o R reconhece o formato pela extensão .jpeg)
ggsave("figPois.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
