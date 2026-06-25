# A distribuição de Pareto é conhecida pelo "Princípio de Pareto" ou regra do 80/20.
# É amplamente utilizada para modelar a distribuição de renda, tamanho de cidades
# e ocorrências de sinistros em seguros. Ela possui suporte limitado à esquerda (x >= scale).

# Versão Distribuição de Pareto

# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado (equivalente ao plt.subplots)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição de Pareto
shape <- 3.0  # Parâmetro de forma (alfa) - Deve ser maior que 0
scale <- 2.0  # Parâmetro de escala (xm / limite mínimo) - Deve ser maior que 0

# Determinar os limites de visualização baseados nos quantis (0% até 99.9%)
# O ponto inicial exato da distribuição é o valor do próprio parâmetro de escala
# Função quantil (inversa da CDF) exata para Pareto: xm / (1 - p)^(1 / alfa)
x_min <- scale
x_max <- scale / (1 - 0.999)^(1 / shape)

# 2. Suporte: Valores contínuos iniciando a partir do limite mínimo (scale) até x_max
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas usando fórmulas matemáticas analíticas
# PDF exata: (alfa * xm^alfa) / x^(alfa + 1)
pdf_pareto <- (shape * (scale^shape)) / (x^(shape + 1))

# CDF exata: 1 - (xm / x)^alfa
cdf_pareto <- 1 - (scale / x)^shape

dados_pareto <- data.frame(
  x  = x,
  fx = pdf_pareto,
  Fx = cdf_pareto
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_pareto, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Decai rapidamente a partir do pico em x_min)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, max(dados_pareto$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Pareto(shape=", shape, ", scale=", scale, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() + # Remove as bordas superior e direita (equivalente às spines ocultas)
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_pareto, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Inicia exatamente no valor de scale)
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
# ggsave("figPareto.jpeg", plot = grafico_final, width = 12, height = 5, dpi = 300)
