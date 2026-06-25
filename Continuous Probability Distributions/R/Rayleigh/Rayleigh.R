# A distribuição de Rayleigh é frequentemente usada para modelar a magnitude de 
# vetores bidimensionais cujos componentes são normais e independentes (como a 
# velocidade do vento ou ruídos de sinal). Ela possui suporte não-negativo (x >= 0)
# e é definida por um parâmetro de escala (sigma).

# Versão Distribuição de Rayleigh

# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado (equivalente ao plt.subplots)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição do parâmetro da Distribuição de Rayleigh
sigma <- 2.0  # Parâmetro de escala (controla a dispersão e o pico da curva)

# Determinar um limite superior adequado para o gráfico (cobre ~99.9% da distribuição)
# Função quantil (inversa da CDF) exata para Rayleigh: sigma * sqrt(-2 * log(1 - p))
x_min <- 0
x_max <- sigma * sqrt(-2 * log(1 - 0.999))

# 2. Suporte: Valores contínuos de 0 até x_max (equivalente ao np.linspace)
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas usando fórmulas matemáticas analíticas
# PDF exata: (x / sigma^2) * exp(-x^2 / (2 * sigma^2))
pdf_rayleigh <- (x / sigma^2) * exp(-x^2 / (2 * sigma^2))

# CDF exata: 1 - exp(-x^2 / (2 * sigma^2))
cdf_rayleigh <- 1 - exp(-x^2 / (2 * sigma^2))

dados_rayleigh <- data.frame(
  x  = x,
  fx = pdf_rayleigh,
  Fx = cdf_rayleigh
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_rayleigh, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Assimétrica positiva, inicia em zero)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, max(dados_rayleigh$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Rayleigh(sigma=", sigma, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() + # Remove as bordas superior e direita (equivalente às spines ocultas)
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_rayleigh, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Inicia exatamente no zero)
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
# ggsave("figRayleigh.jpeg", plot = grafico_final, width = 12, height = 5, dpi = 300)
