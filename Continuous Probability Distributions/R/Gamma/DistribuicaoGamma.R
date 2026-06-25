# Versão Distribuição Gamma
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Gamma
shape <- 2  # Parâmetro de forma (k ou alfa)
rate  <- 0.5 # Parâmetro de taxa (beta) - Nota: scale = 1/rate

# Determinar um limite superior adequado para o gráfico (99.9% da distribuição)
x_max <- qgamma(0.999, shape = shape, rate = rate)

# 2. Suporte: Valores contínuos de 0 até x_max
x <- seq(0, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
dados_gamma <- data.frame(
  x  = x,
  fx = dgamma(x, shape = shape, rate = rate), # PDF: Densidade de probabilidade
  Fx = pgamma(x, shape = shape, rate = rate)  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_gamma, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(dados_gamma$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Gamma(shape=", shape, ", rate=", rate, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_gamma, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2), expand = c(0, 0)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Valor (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2
x11()
grafico_final
# Salvar como JPEG
# ggsave("figGamma.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
