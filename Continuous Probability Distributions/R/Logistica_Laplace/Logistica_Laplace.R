# A distribuição Logística é frequentemente utilizada em modelos de regressão 
# logística, redes neurais (função sigmoide) e para modelar o crescimento de 
# populações. Suas caudas são ligeiramente mais pesadas que as da distribuição Normal.

# Versão Distribuição de Logística

# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado (equivalente ao plt.subplots)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Logística
location <- 0  # Parâmetro de localização (média/mediana/pico central)
scale    <- 1  # Parâmetro de escala (grau de dispersão) - Deve ser maior que 0

# Determinar limites adequados para focar no pico e cobrir ~99.8% da distribuição
# qlogis equivale à função logistic.ppf do Python
x_min <- qlogis(0.001, location = location, scale = scale)
x_max <- qlogis(0.999, location = location, scale = scale)

# 2. Suporte: Valores contínuos de x_min até x_max (equivalente ao np.linspace)
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas usando as funções nativas do R
# dlogis equivale a logistic.pdf (Densidade)
# plogis equivale a logistic.cdf (Acumulada)
dados_logistica <- data.frame(
  x  = x,
  fx = dlogis(x, location = location, scale = scale),
  Fx = plogis(x, location = location, scale = scale)
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_logistica, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Formato de sino simétrico)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), limits = c(x_min, x_max)) +
  scale_y_continuous(limits = c(0, max(dados_logistica$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Logística(location=", location, ", scale=", scale, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() + # Remove as bordas superior e direita (equivalente às spines ocultas)
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_logistica, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Formato de curva sigmoide suave em S)
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
# ggsave("figLogistica.jpeg", plot = grafico_final, width = 12, height = 5, dpi = 300)
