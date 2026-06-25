# Versão Distribuição Weibull de 2 parâmetros (Original)
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Weibull de 2 Parâmetros
shape <- 2.0   # Parâmetro de forma (k) - Controla a assimetria da curva
scale <- 5.0   # Parâmetro de escala (lambda) - Controla a dispersão

# Determinar os limites de visualização baseados nos quantis (0% até 99.9%)
# O ponto inicial exato da distribuição original é zero
x_min <- 0
x_max <- qweibull(0.999, shape = shape, scale = scale)

# 2. Suporte: Valores contínuos de 0 até x_max
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas nativas e criação do data.frame
dados_weibull2 <- data.frame(
  x  = x,
  fx = dweibull(x, shape = shape, scale = scale), # PDF: Densidade de probabilidade
  Fx = pweibull(x, shape = shape, scale = scale)  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_weibull2, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(dados_weibull2$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Weibull(shape=", shape, ", scale=", scale, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_weibull2, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Inicia exatamente no zero)
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

# Salvar como JPEG
ggsave("figWeibull2P.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
