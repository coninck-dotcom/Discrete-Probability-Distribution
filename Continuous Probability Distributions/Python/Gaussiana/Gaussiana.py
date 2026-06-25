import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from scipy.stats import norm

# 1. Definição dos parâmetros da Distribuição Gaussiana (Não Padrão)
mu = 10  # Média (centro da distribuição)
sigma = 3  # Desvio padrão (dispersão/largura)

# Determinar limites adequados para cobrir 99.99% da distribuição (4 sigmas)
x_min = mu - 4 * sigma
x_max = mu + 4 * sigma

# 2. Suporte: Valores contínuos de x_min até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas
fx = norm.pdf(x, loc=mu, scale=sigma)  # PDF: Densidade de probabilidade
Fx = norm.cdf(x, loc=mu, scale=sigma)  # CDF: Probabilidade acumulada

# Configuração do estilo dos gráficos (similar ao theme_classic do R)
sns.set_theme(style="ticks")

# Criar a figura com dois gráficos lado a lado
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 6))

# ==============================================================================
# Gráfico da PDF (Função de Densidade de Probabilidade)
# ==============================================================================
# Desenha a curva contínua da densidade (Sino de Gauss)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(
    f"Função de Densidade (PDF) - Gaussiana(μ={mu}, σ={sigma})",
    fontsize=10,
    fontweight="bold",
    pad=15,
)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")
sns.despine(ax=ax1)  # Remove as bordas superior e direita

# ==============================================================================
# Gráfico da CDF (Função de Distribuição Acumulada Contínua)
# ==============================================================================
# Desenha a curva contínua acumulada (Formato em S suave)
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(x_min, x_max)
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))
ax2.set_title(
    "Distribuição Acumulada (CDF)", fontsize=10, fontweight="bold", pad=15
)
ax2.set_xlabel("Valor (x)")
ax2.set_ylabel("F(x) = P(X <= x)")
sns.despine(ax=ax2)  # Remove as bordas superior e direita

# Ajustar o layout para não sobrepor textos e salvar a imagem
plt.tight_layout()
plt.savefig("figGaussiana.jpeg", dpi=300, format="jpeg")
plt.show()
