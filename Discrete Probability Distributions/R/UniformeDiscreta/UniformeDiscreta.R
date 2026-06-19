# Versão Uniforme Discreta
# Carregar as bibliotecas necessárias
if(!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
# Para juntar os gráficos lado a lado
if(!require(patchwork)) install.packages("patchwork"); library(patchwork)

# 1. Definição dos parâmetros da Distribuição Uniforme Discreta
a <- 1   # Limite inferior do suporte
b <- 10  # Limite superior do suporte

# Número total de pontos no suporte
k <- b - a + 1 

# 2. Suporte: Valores inteiros de 'a' até 'b'
x <- a:b  

# 3. Cálculo das funções de probabilidade exatas e criação do data.frame
dados_uniforme <- data.frame(
  x  = x,
  fx = rep(1 / k, k),  # PMF: Probabilidade constante de 1/k para os pontos
  Fx = seq(1 / k, 1, length.out = k) # CDF: Acumulado linear de 1/k até 1
)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões)
# ==============================================================================
g1 <- ggplot(dados_uniforme, aes(x = x, y = fx)) +
  # Desenha as linhas verticais para cada ponto do suporte
  geom_segment(aes(xend = x, yend = 0), color = "steelblue", linewidth = 1) +
  # Desenha os pontos no topo de cada bastão
  geom_point(color = "darkblue", size = 2.5) +
  # Configurações de eixos e títulos dinâmicos
  scale_x_continuous(breaks = seq(a, b, by = max(1, round((b-a)/10)))) +
  scale_y_continuous(limits = c(0, (1/k) * 1.2)) + # Ajusta o topo 
  labs(
    title = paste0("Função de Massa (PMF) - Ud(N=",b,")"),
    x = "Valor (x)",
    y = "P(X = x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos)
# ==============================================================================
# Criamos os limites dos degraus horizontais para cada x
dados_degraus <- data.frame(
  x     = dados_uniforme$x,
  xend  = dados_uniforme$x + 1, # Cada degrau horizontal 1 unid. para a direita
  y     = dados_uniforme$Fx
)

g2 <- ggplot() +
  # Linhas horizontais dos degraus da escada
  geom_segment(data = dados_degraus, aes(x = x, xend = xend, y = y, yend = y), 
               color = "darkorange", linewidth = 1) +
  # Pontos fechados (no início de cada degrau) indicando a continuidade à direita
  geom_point(data = dados_uniforme, aes(x = x, y = Fx), 
             color = "chocolate", size = 2) +
  # Configurações de eixos e títulos
  scale_x_continuous(breaks = seq(a, b + 1, by = max(1, round((b-a)/10)))) +
  scale_y_continuous(limits = c(0, 1.05), breaks = seq(0, 1, 0.2)) +
  labs(
    title = "Distribuição Acumulada (CDF)",
    x = "Valor (x)",
    y = "F(x) = P(X <= x)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# ==============================================================================
# Exibir os gráficos lado a lado
# ==============================================================================
grafico_final <- g1 + g2
# 2. Salvar como JPEG (o R reconhece o formato pela extensão .jpeg)
ggsave("figUd.jpeg", plot = grafico_final, width = 10, height = 6, dpi = 300)
