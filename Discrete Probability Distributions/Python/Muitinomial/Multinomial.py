import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import multinomial, binom  # Classes necessárias

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Multinomial
# ==============================================================================
# Exemplo: Uma urna com 3 cores de bolas. Extraímos N elementos com reposição.
n_ensaios = 10
probs = [0.5, 0.3, 0.2]  # Vetor de probabilidades (deve somar 1)

# Cenários teóricos para o Gráfico 1 (Comparando composições específicas)
cenarios_x = [
    [5, 3, 2],  # Exato esperado pela média
    [6, 2, 2],
    [4, 4, 2],
    [7, 2, 1],
    [3, 4, 3],
    [10, 0, 0]  # Cenário extremo
]

# Rótulos textuais para o eixo X do gráfico de cenários
nomes_cenarios = [f"({','.join(map(str, v))})" for v in cenarios_x]

# Cálculo da PMF exata usando multinomial.pmf()
prob_cenarios = [multinomial.pmf(v, n=n_ensaios, p=probs) for v in cenarios_x]

dados_pmf = pd.DataFrame({
    "Cenario": nomes_cenarios,
    "fx": prob_cenarios
})

# ==============================================================================
# 2. Distribuição Marginal (Para o gráfico de CDF)
# ==============================================================================
# A distribuição marginal de uma categoria individual é uma Binomial.
# Foco na Categoria 2 (Índice 1 no Python, probabilidade p = 0.3)
p_marginal = probs[1]
x_marginal = np.arange(0, n_ensaios + 1)

dados_cdf = pd.DataFrame({
    "x": x_marginal,
    "Fx": binom.cdf(x_marginal, n_ensaios, p_marginal)
})

# Cria a figura para colocar os dois gráficos lado a lado
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 6))

# ==============================================================================
# Gráfico 1: PMF de Cenários de Vetores - g1
# ==============================================================================
# Desenha as linhas verticais (geom_segment)
ax1.vlines(
    dados_pmf["Cenario"],
    ymin=0,
    ymax=dados_pmf["fx"],
    colors="steelblue",
    linewidth=3
)
# Desenha os pontos no topo (geom_point)
ax1.scatter(
    dados_pmf["Cenario"], dados_pmf["fx"], color="darkblue", s=80, zorder=3
)

# Configurações de eixos e títulos (com suporte a bold e símbolos gregos no LaTeX)
ax1.set_xlabel("Cenários de Vetores Resultantes (x1, x2, x3)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{PMF\ Multinomial:\ pmf(x,\ n,\ \theta)}$",
    pad=15
)
ax1.tick_params(axis='x', labelrotation=45) # Inclina rótulos para melhor leitura
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico 2: CDF Marginal (Foco na Categoria 2) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus da escada
x_degraus = np.concatenate(([-0.5], dados_cdf["x"], [n_ensaios + 1]))
y_degraus = np.concatenate(([0.0], dados_cdf["Fx"], [1.0]))

# Desenha os degraus horizontais da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2
)
# Pontos fechados no início de cada degrau
ax2.scatter(
    dados_cdf["x"], dados_cdf["Fx"], color="chocolate", s=40, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(-0.5, n_ensaios + 1.5)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(np.arange(0, n_ensaios + 2, max(1, n_ensaios // 10)))
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_xlabel("Número de Sucessos na Categoria 2 (x2)")
ax2.set_ylabel(r"$F(x_2) = P(X_2 \leq x_2)$")
ax2.set_title(
    r"$\mathbf{CDF\ Marginal\ (Foco\ na\ Categoria\ 2)}$",
    pad=15
)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento interno para os rótulos inclinados não cortarem
plt.tight_layout()

# 2. Salvar como JPEG com alta resolução
plt.savefig("figMultinom.jpeg", dpi=300, format="jpeg")
plt.close()
