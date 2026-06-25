# Versão Distribuição Gaussiana (Normal Geral)
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Gaussiana (Não Padrão)
mu    <- 10  # Média (centro da distribuição)
sigma <- 3   # Desvio padrão (dispersão/largura)

# Determinar limites adequados para cobrir 99.99% da distribuição (4 sigmas)
x_min <- mu - 4 * sigma
x_max <- mu + 4 * sigma

# 2. Suporte: Valores contínuos de x_min até x_max
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
dados_gaussiana <- data.frame(
  x  = x,
  fx = dnorm(x, mean = mu, sd = sigma), # PDF: Densidade de probabilidade
  Fx = pnorm(x, mean = mu, sd = sigma)  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_gaussiana, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Sino de Gauss)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(dados_gaussiana$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Gaussiana(μ=", mu, ", σ=", sigma, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_gaussiana, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Formato em S suave)
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
# ggsave("figGaussiana.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
