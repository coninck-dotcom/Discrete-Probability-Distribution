import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import rayleigh

# A distribuição de Rayleigh é frequentemente usada para modelar a magnitude de 
# vetores bidimensionais cujos componentes são normais e independentes (como a 
# velocidade do vento ou ruídos de sinal). Ela possui suporte não-negativo (x >= 0)
# e é definida por um parâmetro de escala (sigma).

# Versão Distribuição de Rayleigh

# 1. Definição do parâmetro da Distribuição de Rayleigh
sigma = 2.0  # Parâmetro de escala (controla a dispersão e o pico da curva)

# Determinar um limite superior adequado para o gráfico (cobre ~99.9% da distribuição)
# rayleigh.ppf equivale à função qrayleigh (Percent Point Function / Quantil)
x_min = 0
x_max = rayleigh.ppf(0.999, scale=sigma)

# 2. Suporte: Valores contínuos de 0 até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas usando o SciPy nativo
# rayleigh.pdf equivale a drayleigh (Densidade)
# rayleigh.cdf equivale a prayleigh (Acumulada)
fx = rayleigh.pdf(x, scale=sigma)
Fx = rayleigh.cdf(x, scale=sigma)

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
# Desenha a curva contínua da densidade (Assimétrica positiva, inicia em zero)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Rayleigh(sigma={sigma})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

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
ax2.set_xlabel("Valor (x)")
ax2.set_ylabel("F(x) = P(X <= x)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figRayleigh.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
