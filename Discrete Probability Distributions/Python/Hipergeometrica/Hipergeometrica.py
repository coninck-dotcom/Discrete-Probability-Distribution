import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import hypergeom  # Classe para a Distribuição Hipergeométrica

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Hipergeométrica (Padrão SciPy)
# ==============================================================================
# Exemplo: Retirar cartas de um baralho ou bolas de uma urna
M_total = 50   # População total (No R seria m + n)
n_sucessos = 20 # Número de elementos de sucesso na população (No R seria 'm')
N_amostra = 10  # Tamanho da amostra retirada sem reposição (No R seria 'k')

# 2. Suporte Dinâmico: O número mínimo e máximo possível de sucessos na amostra
limite_inferior = max(0, N_amostra - (M_total - n_sucessos))
limite_superior = min(n_sucessos, N_amostra)
x = np.arange(limite_inferior, limite_superior + 1)

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# pmf() substitui dhyper e cdf() substitui phyper
# Parâmetros no SciPy: hypergeom.pmf(x, M, n, N)
dados_hiper = pd.DataFrame({
    "x": x,
    "fx": hypergeom.pmf(x, M_total, n_sucessos, N_amostra),
    "Fx": hypergeom.cdf(x, M_total, n_sucessos, N_amostra)
})

# Cria a figura para colocar os dois gráficos lado a lado (Equivalente ao patchwork)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# Definição dinâmica do intervalo dos eixos (passo dos ticks)
amplitude = limite_superior - limite_inferior
passo_ticks = max(1, int(np.round(amplitude / 10)))
ticks_pmf = np.arange(limite_inferior, limite_superior + 1, passo_ticks)
ticks_cdf = np.arange(limite_inferior, limite_superior + 2, passo_ticks)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
# Desenha as linhas verticais para cada ponto do suporte
ax1.vlines(
    dados_hiper["x"],
    ymin=0,
    ymax=dados_hiper["fx"],
    colors="steelblue",
    linewidth=2,
)
# Desenha os pontos no topo de cada bastão
ax1.scatter(
    dados_hiper["x"], dados_hiper["fx"], color="darkblue", s=50, zorder=3
)

# Configurações de eixos e títulos (Expressão matemática em LaTeX)
ax1.set_xlim(limite_inferior - 0.5, limite_superior + 0.5)
ax1.set_xticks(ticks_pmf)
ax1.set_xlabel("Número de Sucessos na Amostra (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ Hiper(M, n, N)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus da escada
x_degraus = np.concatenate(([limite_inferior - 0.5], dados_hiper["x"], [limite_superior + 1]))
y_degraus = np.concatenate(([0], dados_hiper["Fx"], [1]))

# Desenha os degraus horizontais da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2
)
# Pontos fechados no início de cada degrau indicando continuidade à direita
ax2.scatter(
    dados_hiper["x"], dados_hiper["Fx"], color="chocolate", s=40, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(limite_inferior - 0.5, limite_superior + 1.5)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(ticks_cdf)
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_xlabel("Número de Sucessos na Amostra (x)")
ax2.set_ylabel(r"$F(x) = P(X \leq x)$")
ax2.set_title(
    r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF):\ Hipergeom{\acute{e}}trica}$",
    pad=15,
)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento interno para os títulos e rótulos
plt.tight_layout()

# 2. Salvar como JPEG com alta resolução (Equivalente ao ggsave)
plt.savefig("figHiper.jpeg", dpi=300, format="jpeg")
plt.close()
