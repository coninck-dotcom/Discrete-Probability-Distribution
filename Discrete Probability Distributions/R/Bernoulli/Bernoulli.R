# Carregar as bibliotecas necessárias
# Versão Uniforme Discreta
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição de Bernoulli
p <- 0.6  # Probabilidade de sucesso (ajuste este valor como desejar)

# 2. Suporte: Bernoulli assume apenas os valores 0 (fracasso) e 1 (sucesso)
x <- 0:1  

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
# Como o R não tem dbernoulli/pbernoulli nativos, usamos dbinom/pbinom com n=1
dados_bernoulli <- data.frame(
  x  = x,
  fx = dbinom(x, size = 1, prob = p), # PMF
  Fx = pbinom(x, size = 1, prob = p)  # CDF
)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões)
# ==============================================================================
g1 <- ggplot(dados_bernoulli, aes(x = x, y = fx)) +
  # Desenha as linhas verticais
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1.2) +
  # Desenha os pontos no topo
  geom_point(color = "darkblue", size = 3) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = x, limits = c(-0.5, 1.5)) +
  labs(
    title =  expression(paste("Função de Massa (PMF): Ber (", theta,")")),
    x = "Resultado (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos)
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_bernoulli$x,
  xend  = dados_bernoulli$x + 1, # Cada degrau anda 1 unidade para a direita
  y     = dados_bernoulli$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados no início de cada degrau
  geom_point(data = dados_bernoulli, aes(x = x, y = Fx), 
             color = "chocolate", size = 2.5) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = 0:2, limits = c(-0.5, 2)) +
  scale_y_continuous(limits = c(0, 1.05)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Resultado (x)",
    y = "F(x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2
# 2. Salvar como JPEG (o R reconhece o formato pela extensão .jpeg)
ggsave("figBer1.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)

