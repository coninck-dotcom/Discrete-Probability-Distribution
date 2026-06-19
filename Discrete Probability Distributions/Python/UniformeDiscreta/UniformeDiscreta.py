import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import randint  # Classe para a Uniforme Discreta

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Uniforme Discreta
# ==============================================================================
a = 1  # Limite inferior do suporte (inclusive)
b = 6  # Limite superior do suporte (inclusive) - Exemplo: Jogar um dado de 6 lados

# 2. Suporte: Valores inteiros de 'a' até 'b'
x = np.arange(a, b + 1)

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# Nota: No scipy.stats.randint, o limite superior é exclusivo, por isso usamos b + 1
dados_uniforme = pd.DataFrame(
    {"x": x, "fx": randint.pmf(x, a, b + 1), "Fx": randint.cdf(x, a, b + 1)}
)

# Cria a figura para colocar os dois gráficos lado a lado
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# ==============================================================================
# Gráfico da PMF (Gráfico de bastões) - g1
# ==============================================================================
# Desenha as linhas verticais
ax1.vlines(
    dados_uniforme["x"],
    ymin=0,
    ymax=dados_uniforme["fx"],
    colors="steelblue",
    linewidth=3,
)
# Desenha os pontos no topo
ax1.scatter(
    dados_uniforme["x"], dados_uniforme["fx"], color="darkblue", s=80, zorder=3
)

# Configurações de eixos e títulos (Suporte a LaTeX no título)
ax1.set_xlim(a - 0.5, b + 0.5)
ax1.set_xticks(x)
ax1.set_xlabel("Resultado (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ Unif(a, b)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus
x_degraus = np.concatenate(([a - 0.5], dados_uniforme["x"], [b + 1]))
y_degraus = np.concatenate(([0], dados_uniforme["Fx"], [1]))

# Desenha os degraus da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2.5
)
# Pontos fechados no início de cada degrau
ax2.scatter(
    dados_uniforme["x"], dados_uniforme["Fx"], color="chocolate", s=60, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(a - 0.5, b + 1)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(np.arange(a, b + 2))
ax2.set_xlabel("Resultado (x)")
ax2.set_ylabel("F(x)")
ax2.set_title(r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF)}$", pad=15)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento entre os subplots
plt.tight_layout()

# Save de arquivo único adaptado para a nova distribuição
plt.savefig("figUnifDiscreta1.jpeg", dpi=300, format="jpeg")
plt.close()
