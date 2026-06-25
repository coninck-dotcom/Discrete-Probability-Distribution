# Versão Distribuição Uniforme Contínua
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Uniforme Contínua
a <- 2   # Limite inferior do suporte
b <- 8   # Limite superior do suporte

# Definir uma margem visual para mostrar a densidade antes de 'a' e depois de 'b'
margem <- (b - a) * 0.2
x_min  <- a - margem
x_max  <- b + margem

# 2. Suporte: Valores contínuos incluindo a margem externa
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
dados_uniforme_cont <- data.frame(
  x  = x,
  fx = dunif(x, min = a, max = b), # PDF: Densidade de probabilidade (Retangular)
  Fx = punif(x, min = a, max = b)  # CDF: Probabilidade acumulada (Rampa linear)
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_uniforme_cont, aes(x = x, y = fx)) +
  # Desenha a linha contínua que forma o retângulo da densidade uniforme
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob o retângulo para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), breaks = seq(round(x_min), round(x_max), by = 1)) +
  scale_y_continuous(limits = c(0, (1 / (b - a)) * 1.3), expand = c(0, 0)) +
  labs(
    title = paste0("Função de Densidade (PDF) - U(", a, ", ", b, ")"),
    x = "Valor (x)",
    y = "f(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_uniforme_cont, aes(x = x, y = Fx)) +
  # Desenha a linha contínua (0 antes de 'a', sobe em linha reta, estabiliza em 1 após 'b')
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos
  scale_x_continuous(expand = c(0, 0), breaks = seq(round(x_min), round(x_max), by = 1)) +
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
# ggsave("figUniformeContinua.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
