import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import poisson  # Classe para a Distribuição de Poisson

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição do parâmetro da Distribuição de Poisson
# ==============================================================================
lam = 6  # Taxa média de ocorrência (equivalente ao lambda do R)

# 2. Suporte: Limitamos para visualização prática usando a folga com o desvio padrão
limite_superior = int(np.round(lam + 4 * np.sqrt(lam)))
x = np.arange(0, limite_superior + 1)

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# pmf() substitui dpois e cdf() substitui ppois
dados_poisson = pd.DataFrame({
    "x": x,
    "fx": poisson.pmf(x, lam),
    "Fx": poisson.cdf(x, lam)
})

# Cria a figura para colocar os dois gráficos lado a lado (Equivalente ao patchwork)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# Definição dinâmica do intervalo dos eixos (passo dos ticks)
passo_ticks = max(1, int(np.round(limite_superior / 10)))
ticks_pmf = np.arange(0, limite_superior + 1, passo_ticks)
ticks_cdf = np.arange(0, limite_superior + 2, passo_ticks)

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
# Desenha as linhas verticais para cada ponto do suporte
ax1.vlines(
    dados_poisson["x"],
    ymin=0,
    ymax=dados_poisson["fx"],
    colors="steelblue",
    linewidth=2,
)
# Desenha os pontos no topo de cada bastão
ax1.scatter(
    dados_poisson["x"], dados_poisson["fx"], color="darkblue", s=50, zorder=3
)

# Configurações de eixos e títulos (Expressão matemática em LaTeX para o lambda)
ax1.set_xlim(-0.5, limite_superior + 0.5)
ax1.set_xticks(ticks_pmf)
ax1.set_xlabel("Número de Ocorrências (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ Pois(\lambda)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus da escada
x_degraus = np.concatenate(([-0.5], dados_poisson["x"], [limite_superior + 1]))
y_degraus = np.concatenate(([0], dados_poisson["Fx"], [1]))


# Desenha os degraus horizontais da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2
)
# Pontos fechados no início de cada degrau indicando continuidade à direita
ax2.scatter(
    dados_poisson["x"], dados_poisson["Fx"], color="chocolate", s=40, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(-0.5, limite_superior + 1.5)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(ticks_cdf)
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_xlabel("Número de Ocorrências (x)")
ax2.set_ylabel(r"$F(x) = P(X \leq x)$")
ax2.set_title(
    r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF)}$",
    pad=15,
)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento interno para os títulos e rótulos
plt.tight_layout()

# 2. Salvar como JPEG com alta resolução (Equivalente ao ggsave)
plt.savefig("figPois.jpeg", dpi=300, format="jpeg")
plt.close()
