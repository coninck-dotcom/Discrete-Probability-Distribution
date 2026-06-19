import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import bernoulli

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# 1. Definição dos parâmetros da Distribuição de Bernoulli
p = 0.6  # Probabilidade de sucesso

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# 1. Definição dos parâmetros da Distribuição de Bernoulli
p = 0.6  # Probabilidade de sucesso

# 2. Suporte: Bernoulli assume apenas os valores 0 e 1
x = np.array([0, 1])

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# Usamos a biblioteca scipy.stats.bernoulli para a PMF (pmf) e CDF (cdf)
dados_bernoulli = pd.DataFrame(
    {"x": x, "fx": bernoulli.pmf(x, p), "Fx": bernoulli.cdf(x, p)}
)

# Cria a figura para colocar os dois gráficos lado a lado (Equivalente ao patchwork)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
# Desenha as linhas verticais (geom_segment)
ax1.vlines(
    dados_bernoulli["x"],
    ymin=0,
    ymax=dados_bernoulli["fx"],
    colors="steelblue",
    linewidth=3,
)
# Desenha os pontos no topo (geom_point)
ax1.scatter(
    dados_bernoulli["x"],
    dados_bernoulli["fx"],
    color="darkblue",
    s=80,
    zorder=3,
)

# Configurações de eixos e títulos (com suporte a LaTeX no título)
ax1.set_xlim(-0.5, 1.5)
ax1.set_xticks(x)
ax1.set_xlabel("Resultado (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ Ber(\theta)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# No Python, o passo do degrau para funções discretas é feito perfeitamente com step()
# drawstyle="steps-post" garante que o degrau mude APÓS o ponto x, como na CDF real
x_degraus = np.array([-0.5, 0, 1, 2])
y_degraus = np.array([0, dados_bernoulli["Fx"][0], dados_bernoulli["Fx"][1], 1])

ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2.5
)
# Pontos fechados no início de cada degrau (geom_point)
ax2.scatter(
    dados_bernoulli["x"],
    dados_bernoulli["Fx"],
    color="chocolate",
    s=60,
    zorder=3,
)

# Configurações de eixos e títulos
ax2.set_xlim(-0.5, 2)
ax2.set_ylim(0, 1.05)
ax2.set_xticks([0, 1, 2])
ax2.set_xlabel("Resultado (x)")
ax2.set_ylabel("F(x)")
ax2.set_title(r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF)}$", pad=15)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento entre os subplots
plt.tight_layout()

# 2. Salvar como JPEG (Equivalente ao ggsave)
plt.savefig("figBer1.jpeg", dpi=300, format="jpeg")
plt.close()
