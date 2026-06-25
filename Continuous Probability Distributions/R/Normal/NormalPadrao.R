# Versão Distribuição Normal Padrão
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Normal Padrão
mu    <- 0  # Média fixa em 0
sigma <- 1  # Desvio padrão fixo em 1

# Limites clássicos para cobrir 99.99% da curva padrão (4 desvios padrões)
x_min <- -4
x_max <- 4

# 2. Suporte: Valores contínuos de -4 até 4
x <- seq(x_min, x_max, length.out = 1000)

# 3. Cálculo das funções exatas e criação do data.frame
dados_normal_padrao <- data.frame(
  x  = x,
  fx = dnorm(x, mean = mu, sd = sigma), # PDF: Densidade de probabilidade
  Fx = pnorm(x, mean = mu, sd = sigma)  # CDF: Probabilidade acumulada
)

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
g1 <- ggplot(dados_normal_padrao, aes(x = x, y = fx)) +
  # Desenha a curva contínua da densidade (Sino de Gauss centrado no zero)
  geom_line(color = "steelblue", linewidth = 1) +
  # Preenche a área sob a curva para melhor visualização
  geom_area(fill = "steelblue", alpha = 0.15) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(expand = c(0, 0), breaks = -4:4) +
  scale_y_continuous(limits = c(0, max(dados_normal_padrao$fx) * 1.1), expand = c(0, 0)) +
  labs(
    title = "Função de Densidade (PDF) - Normal Padrão Z ~ N(0, 1)",
    x = "Valor (z)",
    y = "f(z)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
g2 <- ggplot(dados_normal_padrao, aes(x = x, y = Fx)) +
  # Desenha a curva contínua acumulada (Formato em S passando por 0.5 no x=0)
  geom_line(color = "darkorange", linewidth = 1) +
  # Configurações de eixos e títulos
  scale_x_continuous(expand = c(0, 0), breaks = -4:4) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2), expand = c(0, 0)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Valor (z)",
    y = "F(z) = P(Z <= z)"
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
# ggsave("figNormalPadrao.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
