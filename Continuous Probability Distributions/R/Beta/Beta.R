# A distribuição Beta é uma família de distribuições contínuas definida no intervalo 
# fechado. Ela é muito utilizada na estatística bayesiana para modelar a 
# distribuição de probabilidades ou proporções.

# Versão Distribuição Beta

# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado (equivalente ao plt.subplots)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Beta
shape1 <- 2.0  # Parâmetro de forma 1 (alfa) - Deve ser maior que 0
shape2 <- 5.0  # Parâmetro de forma 2 (beta) - Deve ser maior que 0

# O suporte da distribuição Beta é fixado rigorosamente entre 0 e 1
x_min <- 0.0
x_max <- 1.0

# 2. Suporte: Valores contínuos de 0 até 1 (equivalente ao np.linspace)
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas usando as funções nativas do R
# dbeta equivale a beta.pdf (Densidade)
# pbeta equivale a beta.cdf (Acumulada)
dados_beta <- data.frame(
  x  = x,
  fx = dbeta(x, shape1 = shape1, shape2 = shape2),
  Fx = pbeta(x, shape1 = shape1, shape2 = shape2)
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_beta, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização (alpha equivale ao do Python)
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, max(dados_beta$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Beta(shape1=", shape1, ", shape2=", shape2, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() + # Estilo visual limpo sem as bordas superior e direita
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_beta, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Inicia em 0 e termina cravada no 1)
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos (seq de 0 a 1 de 0.2 em 0.2 equivale ao np.arange)
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2), expand = c(0, 0)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Valor (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() + # Estilo visual limpo sem as bordas superior e direita
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2

# Abre a janela gráfica (Equivalente ao plt.show())
x11(width = 12, height = 5)
grafico_final

# Salvar como JPEG (Equivalente ao plt.savefig)
# ggsave("figBeta.jpeg", plot = grafico_final, width = 12, height = 5, dpi = 300)
