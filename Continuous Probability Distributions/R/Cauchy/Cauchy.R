# A distribuição de Cauchy é conhecida por suas caudas extremamente pesadas 
# (o que faz com que ela não possua média ou variância definidas). 
# Seus parâmetros são a localização (location, que dita o centro e o 
# pico da distribuição) e a escala (scale, que dita a dispersão). 
# Devido às caudas longas, o código usa os quantis de 1% e 99% para 
# cortar o eixo X de forma simétrica e focar no pico da curva.

# Versão Distribuição de Cauchy
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição de Cauchy
location <- 0  # Parâmetro de localização (mediana/pico central)
scale    <- 1  # Parâmetro de escala (grau de dispersão) - Deve ser maior que 0

# Determinar limites adequados para focar no pico da distribuição
# Nota: Usamos 1% e 99% porque as caudas da Cauchy são infinitamente longas
x_min <- qcauchy(0.01, location = location, scale = scale)
x_max <- qcauchy(0.99, location = location, scale = scale)

# 2. Suporte: Valores contínuos de x_min até x_max
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
dados_cauchy <- data.frame(
  x  = x,
  fx = dcauchy(x, location = location, scale = scale), # PDF: Densidade de probabilidade
  Fx = pcauchy(x, location = location, scale = scale)  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_cauchy, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Formato de sino com caudas pesadas)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(dados_cauchy$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Cauchy(location=", location, ", scale=", scale, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_cauchy, aes(x = x, y = Fx)) +
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
# ggsave("figCauchy.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
