# A distribuição Lognormal é usada quando os logaritmos dos valores seguem 
# uma distribuição normal (comum em dados de renda, tamanhos de arquivos ou geologia).
# Ela possui suporte estritamente positivo (x > 0).

# Versão Distribuição Lognormal

# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado (equivalente ao plt.subplots)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Lognormal
meanlog <- 0.0  # Média do logaritmo da variável (μ)
sdlog   <- 0.5  # Desvio padrão do logaritmo da variável (σ)

# Determinar um limite superior adequado para o gráfico (99.9% da distribuição)
# qlnorm equivale à função lognorm.ppf do Python
x_min <- 0
x_max <- qlnorm(0.999, meanlog = meanlog, sdlog = sdlog)

# 2. Suporte: Valores contínuos de 0 até x_max (equivalente ao np.linspace)
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas usando as funções nativas do R
# dlnorm equivale a lognorm.pdf (Densidade)
# plnorm equivale a lognorm.cdf (Acumulada)
dados_lognormal <- data.frame(
  x  = x,
  fx = dlnorm(x, meanlog = meanlog, sdlog = sdlog),
  Fx = plnorm(x, meanlog = meanlog, sdlog = sdlog)
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_lognormal, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Assimétrica positiva)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, max(dados_lognormal$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Lognormal(meanlog=", meanlog, ", sdlog=", sdlog, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() + # Remove as bordas superior e direita (equivalente às spines ocultas)
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_lognormal, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Começa tangenciando o zero)
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos (seq equivale ao np.arange)
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
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

# Abre a janela gráfica (Equivalente ao plt.show())
x11(width = 12, height = 5)
grafico_final

# Salvar como JPEG (Equivalente ao plt.savefig)
# ggsave("figLognormal.jpeg", plot = grafico_final, width = 12, height = 5, dpi = 300)
