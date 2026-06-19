# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Binomial Negativa (Padrão R)
# ==============================================================================
# Exemplo: Lançar uma moeda até conseguir obter 'r' caras
r <- 4     # Número alvo de sucessos desejados (parâmetro 'size' do R)
p <- 0.3   # Probabilidade de sucesso em cada tentativa/ensaio (prob)

# 2. Suporte Dinâmico: Teoricamente infinito, mas limitamos para visualização prática
# Usamos a média e o desvio padrão dos fracassos para cortar a cauda longa
media_fracassos <- (r * (1 - p)) / p
dp_fracassos <- sqrt(r * (1 - p)) / p

limite_inferior <- 0
limite_superior <- round(media_fracassos + 4 * dp_fracassos)
x <- limite_inferior:limite_superior

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
# dnbinom e pnbinom calculam a PMF e a CDF com base no número de fracassos (x)
dados_nbinom <- data.frame(
  x  = x,
  fx = dnbinom(x, size = r, prob = p), # PMF
  Fx = pnbinom(x, size = r, prob = p)  # CDF
)

# Definição dinâmica do intervalo dos eixos (passo dos breaks)
amplitude <- limite_superior - limite_inferior
passo_ticks <- max(1, round(amplitude / 10))

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
g1 <- ggplot(dados_nbinom, aes(x = x, y = fx)) +
  # Desenha as linhas verticais para cada ponto do suporte
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1) +
  # Desenha os pontos no topo de cada bastão
  geom_point(color = "darkblue", size = 2.5) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(breaks = seq(limite_inferior, limite_superior, by = passo_ticks)) +
  labs(
    title = expression(paste("Função de Massa (PMF): NBin(r, ", theta, ")")),
    x = "Número de Fracassos antes do r-ésimo Sucesso (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_nbinom$x,
  xend  = dados_nbinom$x + 1, # Cada degrau horizontal anda 1 unidade para a direita
  y     = dados_nbinom$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus da escada
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados no início de cada degrau indicando continuidade à direita
  geom_point(data = dados_nbinom, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = seq(limite_inferior, limite_superior + 1, by = passo_ticks)) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Distribuição Acumulada (CDF): Binomial Negativa",
    x = "Número de Fracassos antes do r-ésimo Sucesso (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir e salvar os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2

# Salva como JPEG em alta resolução
ggsave("figNBin.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
