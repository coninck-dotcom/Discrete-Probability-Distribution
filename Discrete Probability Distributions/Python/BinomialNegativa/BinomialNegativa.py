import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import nbinom  # Classe para a Distribuição Binomial Negativa

# Configura o estilo clássico/limpo semelhante ao theme_classic() do R
sns.set_theme(style="white")

# ==============================================================================
# 1. Definição dos parâmetros da Distribuição Binomial Negativa (Padrão SciPy/R)
# ==============================================================================
# Exemplo: Lançar uma moeda até conseguir obter 'r' caras
r = 4     # Número alvo de sucessos desejados (parâmetro 'n' no SciPy)
p = 0.3   # Probabilidade de sucesso em cada tentativa/ensaio (parâmetro 'p')

# 2. Suporte Dinâmico: Teoricamente infinito, mas limitamos para visualização prática
# Usamos a média e o desvio padrão dos fracassos para cortar a cauda longa
media_fracassos = (r * (1 - p)) / p
dp_fracassos = np.sqrt(r * (1 - p)) / p

limite_inferior = 0
limite_superior = int(np.round(media_fracassos + 4 * dp_fracassos))
x = np.arange(limite_inferior, limite_superior + 1)

# 3. Cálculo das funções de probabilidade exatas e criação do DataFrame
# pmf() e cdf() recebem (x, n, p) onde n é o número de sucessos alvo
dados_nbinom = pd.DataFrame({
    "x": x,
    "fx": nbinom.pmf(x, r, p),
    "Fx": nbinom.cdf(x, r, p)
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
# Desenha las líneas verticales para cada punto del soporte
ax1.vlines(
    dados_nbinom["x"],
    ymin=0,
    ymax=dados_nbinom["fx"],
    colors="steelblue",
    linewidth=2,
)
# Desenha os pontos no topo de cada bastão
ax1.scatter(
    dados_nbinom["x"], dados_nbinom["fx"], color="darkblue", s=50, zorder=3
)

# Configurações de eixos e títulos (Expressão matemática em LaTeX para o theta)
ax1.set_xlim(limite_inferior - 0.5, limite_superior + 0.5)
ax1.set_xticks(ticks_pmf)
ax1.set_xlabel("Número de Fracassos antes do r-ésimo Sucesso (x)")
ax1.set_ylabel("P(X = x)")
ax1.set_title(
    r"$\mathbf{Fun{\tilde{c}}{\tilde{a}}o\ de\ Massa\ (PMF):\ NBin(r,\ \theta)}$",
    pad=15,
)
ax1.spines["top"].set_visible(False)
ax1.spines["right"].set_visible(False)

# ==============================================================================
# Gráfico da CDF (Gráfico em escada/degraus perfeitos) - g2
# ==============================================================================
# Construção dinâmica dos pontos de quebra para os degraus da escada (correção ortográfica)
x_degraus = np.concatenate(([limite_inferior - 0.5], dados_nbinom["x"], [limite_superior + 1]))
y_degraus = np.concatenate(([0.0], dados_nbinom["Fx"], [1.0]))

# Desenha os degraus horizontais da escada
ax2.step(
    x_degraus, y_degraus, where="post", color="darkorange", linewidth=2
)
# Pontos fechados no início de cada degrau indicando continuidade à direita
ax2.scatter(
    dados_nbinom["x"], dados_nbinom["Fx"], color="chocolate", s=40, zorder=3
)

# Configurações de eixos e títulos
ax2.set_xlim(limite_inferior - 0.5, limite_superior + 1.5)
ax2.set_ylim(0, 1.05)
ax2.set_xticks(ticks_cdf)
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_xlabel("Número de Fracassos antes do r-ésimo Sucesso (x)")
ax2.set_ylabel(r"$F(x) = P(X \leq x)$")
ax2.set_title(
    r"$\mathbf{Distribui{\c{c}}{\tilde{a}}o\ Acumulada\ (CDF):\ Binomial\ Negativa}$",
    pad=15,
)
ax2.spines["top"].set_visible(False)
ax2.spines["right"].set_visible(False)

# Ajusta o espaçamento interno para os títulos e rótulos
plt.tight_layout()

# 2. Salvar como JPEG com alta resolução (Equivalente ao ggsave)
plt.savefig("figNBin.jpeg", dpi=300, format="jpeg")
plt.close()
