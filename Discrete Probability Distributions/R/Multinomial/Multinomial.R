# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Multinomial
# ==============================================================================
# Exemplo: Uma urna com 3 cores de bolas. Extraímos N elementos com reposição.
n_ensaios <- 10                      # Número total de tentativas/extrações
probs <- c(0.5, 0.3, 0.2)             # Vetor de probabilidades (deve somar 1)

# Cenários teóricos para o Gráfico 1 (Comparando a probabilidade de composições específicas)
cenarios_x <- list(
  c(5, 3, 2), # Exato esperado pela média
  c(6, 2, 2),
  c(4, 4, 2),
  c(7, 2, 1),
  c(3, 4, 3),
  c(10, 0, 0) # Cenário extremo
)

# Rótulos textuais para os cenários do gráfico
nomes_cenarios <- sapply(cenarios_x, function(v) paste0("(", paste(v, collapse=","), ")"))

# Cálculo da PMF exata usando dmultinom()
prob_cenarios <- sapply(cenarios_x, function(v) {
  dmultinom(x = v, size = n_ensaios, prob = probs)
})

dados_pmf <- data.frame(
  Cenario = factor(nomes_cenarios, levels = nomes_cenarios),
  fx = prob_cenarios
)

# ==============================================================================
# 2. Distribuição Marginal (Para o gráfico de CDF)
# ==============================================================================
# A distribuição marginal de qualquer categoria individual em uma Multinomial é uma Binomial.
# Vamos focar na Categoria 2 (probabilidade p = 0.3)
p_marginal <- probs[2]
x_marginal <- 0:n_ensaios

dados_cdf <- data.frame(
  x = x_marginal,
  Fx = pbinom(x_marginal, size = n_ensaios, prob = p_marginal)
)

# ==============================================================================
# Gráfico 1: PMF de Cenários de Vetores - g1
# ==============================================================================
g1 <- ggplot(dados_pmf, aes(x = Cenario, y = fx)) +
  geom_segment(aes(xend = Cenario, yend = 0), color = "steelblue", linewidth = 1.2) +
  geom_point(color = "darkblue", size = 3) +
  labs(
    title = expression(paste("PMF Multinomial: dmultinom(x, n, ", boldsymbol(theta), ")")),
    x = "Cenários de Vetores Resultantes (x1, x2, x3)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1) # Inclina rótulos dos vetores
  )

# ==============================================================================
# Gráfico 2: CDF Marginal da Categoria 2 - g2
# ==============================================================================
dados_degraus <- data.frame(
  x = dados_cdf$x,
  xend = dados_cdf$x + 1,
  y = dados_cdf$Fx
)

g2 <- ggplot() +
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  geom_point(data = dados_cdf, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  scale_x_continuous(breaks = 0:(n_ensaios + 1)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "CDF Marginal (Foco na Categoria 2)",
    x = "Número de Sucessos na Categoria 2 (x2)",
    y = "F(x2) = P(X2 <= x2)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2

ggsave("figMultinom.jpeg", plot = grafico_final, width = 11, height = 6, dpi = 300)
  