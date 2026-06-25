import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Versão Distribuição Normal Padrão

# 1. Definição dos parâmetros da Distribuição Normal Padrão
mu = 0     # Média fixa em 0
sigma = 1  # Desvio padrão fixo em 1

# Limites clássicos para cobrir 99.99% da curva padrão (4 desvios padrões)
x_min = -4
x_max = 4

# 2. Suporte: Valores contínuos de -4 até 4
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas
# norm.pdf equivale a dnorm (Densidade)
# norm.cdf equivale a pnorm (Acumulada)
fx = norm.pdf(x, loc=mu, scale=sigma)
Fx = norm.cdf(x, loc=mu, scale=sigma)

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
# Desenha a curva contínua da densidade (Sino de Gauss centrado no zero)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_xticks(np.arange(-4, 5, 1))  # Marcadores de -4 a 4 de 1 em 1
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title("Função de Densidade (PDF) - Normal Padrão Z ~ N(0, 1)", weight='bold', pad=15)
ax1.set_xlabel("Valor (z)")
ax1.set_ylabel("f(z)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Formato em S passando por 0.5 no x=0)
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(x_min, x_max)
ax2.set_xticks(np.arange(-4, 5, 1))  # Marcadores de -4 a 4 de 1 em 1
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))  # Quebras de 0 até 1 de 0.2 em 0.2
ax2.set_title("Distribuição Acumulada (CDF)", weight='bold', pad=15)
ax2.set_xlabel("Valor (z)")
ax2.set_ylabel("F(z) = P(Z <= z)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figNormalPadrao.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
