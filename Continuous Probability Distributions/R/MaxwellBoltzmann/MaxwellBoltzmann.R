# A distribuição de Maxwell-Boltzmann é usada na física para descrever a 
# velocidade de partículas em um gás ideal. Ela possui suporte não-negativo
# (v >= 0) e é caracterizada por um único parâmetro de escala (a). 
# Como o R não possui essa distribuição nativa por padrão, implementa-se as 
# fórmulas matemáticas exatas diretamente no código para a densidade (PDF) e
# a acumulada (CDF) — usando a função de erro erf() através de 
# 2 * pnorm(x * sqrt(2)) - 1 
# — evitando a necessidade de instalar pacotes adicionais.



# Versão Distribuição de Maxwell-Boltzmann
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição do parâmetro da Distribuição de Maxwell-Boltzmann
a <- 2.0  # Parâmetro de escala (depende da temperatura e da massa da partícula)

# Determinar um limite superior adequado para o gráfico (cobre ~99.9% da curva)
# Matematicamente, a velocidade máxima de visualização pode ser estimada por 5 * a
x_min <- 0
x_max <- 5 * a

# 2. Suporte: Valores contínuos de 0 até x_max (velocidades)
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
# PDF exata: sqrt(2/pi) * (x^2 * exp(-x^2 / (2 * a^2))) / a^3
pdf_maxwell <- sqrt(2 / pi) * (x^2 * exp(-x^2 / (2 * a^2))) / a^3

# CDF exata: erf(x / (sqrt(2) * a)) - sqrt(2/pi) * (x * exp(-x^2 / (2 * a^2))) / a
# No R, a função de erro erf(z) pode ser calculada via 2 * pnorm(z * sqrt(2)) - 1
z <- x / (sqrt(2) * a)
erf_z <- 2 * pnorm(z * sqrt(2)) - 1
cdf_maxwell <- erf_z - sqrt(2 / pi) * (x * exp(-x^2 / (2 * a^2))) / a

dados_maxwell <- data.frame(
  x  = x,
  fx = pdf_maxwell, # PDF: Densidade de probabilidade
  Fx = cdf_maxwell  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_maxwell, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Velocidades de partículas)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(dados_maxwell$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - Maxwell-Boltzmann(a=", a, ")"),
    x = "Velocidade (v)",
    y = "f(v)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_maxwell, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Inicia exatamente no zero)
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2), expand = c(0, 0)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Velocidade (v)",
    y = "F(v) = P(V <= v)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
# grafico_final <- g1 + g2
x11()
grafico_final
# Salvar como JPEG
# ggsave("figMaxwellBoltzmann.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)

