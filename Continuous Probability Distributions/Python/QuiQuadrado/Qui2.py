import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import chi2

# Versão Distribuição Qui-Quadrado

# 1. Definição dos parâmetros da Distribuição Qui-Quadrado
df = 5  # Graus de liberdade (df) - Deve ser maior que 0

# Determinar um limite superior adequado para o gráfico (99.9% da distribuição)
# chi2.ppf equivale à função qchisq do R (Percent Point Function / Quantil)
x_max = chi2.ppf(0.999, df=df)

# 2. Suporte: Valores contínuos de 0 até x_max (Suporte não-negativo)
x = np.linspace(0, x_max, 1000)

# 3. Cálculo das funções exatas
# chi2.pdf equivale a dchisq (Densidade)
# chi2.cdf equivale a pchisq (Acumulada)
fx = chi2.pdf(x, df=df)
Fx = chi2.cdf(x, df=df)

# ==============================================================================
# Configuração da figura para os gráficos lado a lado (equivalente ao patchwork)
# ==============================================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Estilo visual limpo (equivalente ao theme_classic)
for ax in [ax1, ax2]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(top=False, right=False)

# ------------------------------------------------------------------------------
# Gráfico 1: PDF (Função de Densidade de Probabilidade)
# ------------------------------------------------------------------------------
# Desenha a curva contínua da densidade (Assimétrica à direita)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(0, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Qui-Quadrado(df={df})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(0, x_max)
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))  # Quebras de 0 até 1 de 0.2 em 0.2
ax2.set_title("Distribuição Acumulada (CDF)", weight='bold', pad=15)
ax2.set_xlabel("Valor (x)")
ax2.set_ylabel("F(x) = P(X <= x)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figQuiQuadrado.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
