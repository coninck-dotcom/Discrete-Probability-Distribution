import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import binom  # Classe para a Distribuição Binomial

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Binomial
# ==============================================================================
n = 10   # Número de ensaios/tentativas
p = 0.6  # Probabilidade de sucesso em cada ensaio

# 2. Suporte: A Binomial assume valores inteiros de 0 até n
x = np.arange(0, n + 1)

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# pmf() e cdf() calculam os valores correspondentes de forma exata
dados_binomial = pd.DataFrame({
    "x": x,
    "fx": binom.pmf(x, n, p),
    "Fx": binom.cdf(x, n, p)
})

# Cria a figura para colocar os dois gráficos lado a lado (Equivalente ao patchwork)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# Definição dinâmica do intervalo dos eixos (passo dos ticks baseado no tamanho de n)
passo_ticks = max(1, int(np.round(n / 10)))
ticks_pmf = np.arange(0, n + 1, passo_ticks)
ticks_cdf = np.arange(0, n + 2, passo_ticks)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
# Desenha as linhas verticais para cada ponto do suporte
ax1.vlines(
    dados_binomial["x"],
    ymin=0,
    ymax=dados_binomial["fx"],
    colors="steelblue",
    linewidth=2,
)
# Desenha os pontos no topo de cada bastão
ax1.scatter(
    dados_binomial["x"], dados_binomial["fx"], color="darkblue", s=50, zorder=3
)

# Configurações de eixos e títulos (Expressão matemática em LaTeX para o theta)
ax1.set_xlim(-0.5, n + 0.5)
ax1.set_xticks(ticks_pmf)
ax1.set_xlabel("Número de Sucessos (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ Bin(N,\ \theta)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus da escada
x_degraus = np.concatenate(([-0.5], dados_binomial["x"], [n + 1]))
y_degraus = np.concatenate(([0], dados_binomial["Fx"], [1]))

# Desenha os degraus horizontais da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2
)
# Pontos fechados no início de cada degrau indicando continuidade à direita
ax2.scatter(
    dados_binomial["x"], dados_binomial["Fx"], color="chocolate", s=40, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(-0.5, n + 1.5)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(ticks_cdf)
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_xlabel("Número de Sucessos (x)")
ax2.set_ylabel(r"$F(x) = P(X \leq x)$")
ax2.set_title(
    r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF):\ Binomial}$",
    pad=15,
)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento interno para os títulos não cortarem
plt.tight_layout()

# 2. Salvar como JPEG com alta resolução (Equivalente ao ggsave)
plt.savefig("figBin1.jpeg", dpi=300, format="jpeg")
plt.close()
