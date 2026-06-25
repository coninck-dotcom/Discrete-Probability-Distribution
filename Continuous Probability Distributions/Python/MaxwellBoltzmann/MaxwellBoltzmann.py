import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import maxwell

# A distribuição de Maxwell-Boltzmann é usada na física para descrever a 
# velocidade de partículas em um gás ideal. Ela possui suporte não-negativo
# (v >= 0) e é caracterizada por um único parâmetro de escala (a). 

# Versão Distribuição de Maxwell-Boltzmann

# 1. Definição do parâmetro da Distribuição de Maxwell-Boltzmann
a = 2.0  # Parâmetro de escala (depende da temperatura e da massa da partícula)

# Determinar um limite superior adequado para o gráfico (cobre ~99.9% da curva)
# Matematicamente, a velocidade máxima de visualização pode ser estimada por 5 * a
x_min = 0
x_max = 5 * a

# 2. Suporte: Valores contínuos de 0 até x_max (velocidades)
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas usando o SciPy nativo
# maxwell.pdf calcula a densidade de forma exata e otimizada
# maxwell.cdf calcula a probabilidade acumulada diretamente
fx = maxwell.pdf(x, scale=a)
Fx = maxwell.cdf(x, scale=a)

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
# Desenha a curva contínua da densidade (Velocidades de partículas)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Maxwell-Boltzmann(a={a})", weight='bold', pad=15)
ax1.set_xlabel("Velocidade (v)")
ax1.set_ylabel("f(v)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Inicia exatamente no zero)
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(x_min, x_max)
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))  # Quebras de 0 até 1 de 0.2 em 0.2
ax2.set_title("Distribuição Acumulada (CDF)", weight='bold', pad=15)
ax2.set_xlabel("Velocidade (v)")
ax2.set_ylabel("F(v) = P(V <= v)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figMaxwellBoltzmann.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()

